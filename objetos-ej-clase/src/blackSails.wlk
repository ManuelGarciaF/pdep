class Embarcacion {

	const caniones = []
	const tripulacion
	const property ubicacion
	var botin = 0 // Doy valores por defecto para evitar warnings

	/** Punto 1 */
	method poderDanio() = tripulacion.corajeTotal() + self.danioCaniones()

	method danioCaniones() = caniones.sum{ canion => canion.danio() }

	/** Punto 2 */
	method tripulanteMasCorajudo() = tripulacion.pirataMasCorajudo()

	/** Punto 3 */
	method puedeConflictuar(otraEmbarcacion) = ubicacion.estaCerca(otraEmbarcacion.ubicacion())

	method tieneHabilNegociador() = tripulacion.tieneHabilNegociador()

	method botin() = botin

	method variarBotin(variacion) {
		botin += variacion
	}

	method sumarCorajeBase(cantidad) {
		tripulacion.sumarCorajeBase(cantidad)
	}

	method elimintarCobardes(numero) {
		tripulacion.elimintarCobardes(numero)
	}

// TODO Estos 4 metodos
// atacado.nuevoCapitan(atacante.contramaestre())
// atacante.promoverCorajudo()
// atacado.agregarTripulantes(atacante.eliminarMasCorajudos(3))

	method envejecerCaniones(cantidadAnios) {
		caniones.forEach{ canion => canion.envejecer(cantidadAnios) }
	}
}

class Ubicacion {

	const property oceano
	const property x
	const property y

	method estaCerca(otraUbicacion) = oceano == otraUbicacion.oceano() && self.estaEnRangoConflicto(otraUbicacion)

	method estaEnRangoConflicto(otraUbicacion) = ((x - otraUbicacion.x()).square() + (y - otraUbicacion.y()).square()).squareRoot() < ubicacion.rangoMinimoConflicto()

}

object ubicacion {

	var property rangoMinimoConflicto = 2

}

class Tripulacion {

	const property piratas = []
	var property contramaestre
	var property capitan

	method corajeTotal() = self.tripulacion().sum{ tripulante => tripulante.coraje() }

	method tripulacion() {
		const tripulantes = piratas.copy()
		tripulantes.addAll([ capitan, contramaestre ])
		return tripulantes
	}

	method pirataMasCorajudo() = piratas.max{ pirata => pirata.coraje() }

	method tieneHabilNegociador() = self.tripulacion().any{ tripulante => tripulante.esHabilNegociador() }

	method sumarCorajeBase(cantidad) {
		self.tripulacion().forEach{ tripulante => tripulante.sumarCorajeBase(cantidad)}
	}

	method elimintarCobardes(numero) {
		const masCobardes = piratas.sortedBy{ p1 , p2 => p1.coraje() < p2.coraje() }.take(numero)
		piratas.removeAll(masCobardes)
	}

}

class Canion {

	const danioBase
	var antiguedad = 0

	method danio() = 0.max(danioBase * (1 - canion.indiceDesgaste() * antiguedad))
	
	method envejecer(aniosAgregados) {
		antiguedad += aniosAgregados
	}

}

object canion {

	const property indiceDesgaste = 0.01
	var property danioBaseFabricacion = 350

	/** Punto 6 */
	method crear() = new Canion(danioBase = danioBaseFabricacion)

}

class Tripulante {

	var corajeBase
	const armas = []
	const inteligencia

	method corajeBase() = corajeBase

	method coraje() = corajeBase + self.danioTotal()

	method danioTotal() = armas.sum{ arma => arma.danio() }

	method esHabilNegociador() = inteligencia > tripulante.inteligenciaRequeridaNegociador()

	method sumarCorajeBase(cantidad) {
		corajeBase += cantidad
	}

}

object tripulante {

	const property inteligenciaRequeridaNegociador = 50

}

// Armas
object cuchillo {

	var property danio = 5

	method danio(tripulante) = danio

}

class Espada {

	const danio

	method danio(tripulante) = danio

}

class Pistola {

	const calibre
	const material

	method danio(tripulante) = calibre * indexadorMateriales.indice(material)

}

class Insulto {

	const frase

	method danio(tripulante) = self.palabras() * tripulante.corajeBase()

	method palabras() = frase.split(" ").size()

}

object indexadorMateriales {

	method indice(material) = 42

}

// Contiendas
class Contienda {

	method puedeSuceder(atacante, atacado) = atacante.puedeConflictuar(atacado) and self.puedeGanar(atacante, atacado)

	method puedeGanar(atacante, atacado)

	method tomar(atacante, atacado) {
		if (!self.puedeSuceder(atacante, atacado)) throw new ContiendaException(message = "No puede suceder la contienda")
		self.realizarToma(atacante, atacado)
	}

	method realizarToma(atacante, atacado)

}

object batalla inherits Contienda {

	override method puedeGanar(atacante, atacado) = atacante.poderDanio() > atacado.poderDanio()

	override method realizarToma(atacante, atacado) {
		atacante.sumarCorajeBase(5)
		atacado.elimintarCobardes(3)
		atacado.nuevoCapitan(atacante.contramaestre())
		atacante.promoverCorajudo()
		atacado.agregarTripulantes(atacante.eliminarMasCorajudos(3))
	}

}

object negociacion inherits Contienda {

	override method puedeGanar(atacante, atacado) = atacante.tieneHabilNegociador()

	override method realizarToma(atacante, atacado) {
		const medioBotin = atacado.botin() / 2
		atacante.variarBotin(medioBotin)
		atacante.variarBotin(-medioBotin)
	}

}

class ContiendaException inherits Exception {

}

// Bestias
class Bestia {

	const property fuerza

	method curzarA(embarcacion) {
		if (fuerza > embarcacion.poderDanio()) self.afectar(embarcacion)
	}

	method afectar(embarcacion)

}

class BallenaAzul inherits Bestia {

	override method afectar(embarcacion) {
		embarcacion.envejecerCaniones(8)
	}

}

