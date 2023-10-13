import rolandoHechizos.hechizoBasico

object personaje { // Companion object

	const property valorBaseHechiceria = 3 // Lo vuelve publico, define getters y setters automaticamente

}

class Personaje {

	var property valorBaseLucha = 1
	var property hechizoPreferido = hechizoBasico
	const artefactos = []
	const capacidadDeCarga
	var monedas = 100

	method nivelDeHechiceria() = personaje.valorBaseHechiceria() * hechizoPreferido.poder() + fuerzaOscura.valor()

	method seCreePoderoso() = hechizoPreferido.esPoderoso()

	method agregarArtefacto(artefacto) {
		artefactos.add(artefacto)
	}

	method removerArtefacto(artefacto) {
		artefactos.remove(artefacto)
	}

	method valorDeLucha() = valorBaseLucha + self.aporteDeArtefactos()

	method unidadesDeMejorArtefactoSinArtefacto(artefactoRemovido) {
		const copiaArtefactos = artefactos.copyWithout(artefactoRemovido)
		const mejorArtefacto = copiaArtefactos.max{ artefacto => artefacto.unidadesDeLucha(self) }
		return mejorArtefacto.unidadesDeLucha(self)
	}

	method aporteDeArtefactos() = artefactos.sum{ artefacto => artefacto.unidadesDeLucha(self) }

	method masLuchadorQueHechicero() = self.valorDeLucha() > self.nivelDeHechiceria()

	method comprarArtefacto(artefacto) {
		if (monedas >= artefacto.precio() and self.capacidadRestante() >= artefacto.peso()) {
			monedas -= artefacto.precio()
			self.agregarArtefacto(artefacto)
		} // TODO
	}

	method comprarHechizo(hechizo) {
		const precioFinal = 0.max(hechizo.precio() - hechizoPreferido.precio() / 2)
		if (monedas >= precioFinal) {
			monedas -= precioFinal
			hechizoPreferido = hechizo
		}
	}

	method capacidadRestante() = capacidadDeCarga - artefactos.sum{ artefacto => artefacto.peso() }

}

class Npc inherits Personaje {
	
	const nivelDificultad = dificultadModerada
	
	override method valorDeLucha() = super() * nivelDificultad.multiplicador()
}

class NivelDificultad {
	const property multiplicador
}
const dificultadFacil = new NivelDificultad(multiplicador = 1)
const dificultadModerada = new NivelDificultad(multiplicador = 2)
const dificultadDificil = new NivelDificultad(multiplicador = 4)

object fuerzaOscura {

	var valor = 5

	method valor() = valor

	method provocarEclipse() {
		valor *= 2
	}

}

class Comerciante {
	
	var property categoria
	var property comision
		
	method aplicarImpuesto(artefacto) = artefacto.precio() + categoria.impuesto(artefacto.precio(), self)
	
	method recategorizar() {
		categoria.recategorizar(self)
	} 
	
	method duplicarComision() {
		comision *= 2
	}
}

object independiente {
	
	method impuesto(monto, comerciante) = monto * comerciante.comision() 
	
	method recategorizar(comerciante) {
		comerciante.duplicarComision()
		if (comerciante.comision() > 0.21) {
			comerciante.categoria(registrado)
		} 
	}
	
}

object registrado {
	
	const iva = 0.21
	
	method impuesto(monto, comerciante) = monto * iva
	
	method recategorizar(comerciante) {
		comerciante.categoria(conImpuestoALasGanancias)
	}
	
}

object conImpuestoALasGanancias {
	
	var property minimoNoImponible = 42
	var property recargo = 0.35
	
	method impuesto(monto, comerciante) = 0.max(monto - minimoNoImponible) * recargo
	
	method recategorizar(comerciante) {}
}











