import estados.*
import cosos.*
import errores.*

class Camion {

	const cargaMaxima
	const cosos = []
	var property estado

	method cargar(coso) {
		estado.validarCarga(self, coso)
		cosos.add(coso)
	}

	method validarPeso(coso) {
		if (!self.puedeCargarPeso(coso)) 
			throw new CargaException(message = "Peso máximo excedido")
	}

	method puedeCargar(coso) = estado.puedeCargar(self, coso) 	
	/* Ya que si puede cargar depende del estado, 
	 * delegamos la lógica
	 */

	method puedeCargarPeso(coso) = coso.peso() + self.cargaActual() <= cargaMaxima

	method cargaActual() = cosos.sum{ coso => coso.peso() }

	method salirDeReparacion() {
		estado.salirDeReparacion(self)
	}
	
	method entrarEnReparacion() {
		estado.entrarEnReparacion(self)
	}

	method estaListoParaPartir() = estado.estaListoParaPartir(self)

	method tienePesoSuficienteParaPartir() = self.cargaActual() >= cargaMaxima * 0.75

	method estaEnViaje() = estado.estaEnViaje()
	
	method elementosCargados() = cosos.map{ coso => coso.contenido() }.withoutDuplicates()

	method estaCargando(elemento) = estado.estaCargando(self) and self.tiene(elemento)
	
	method tiene(elemento) = self.elementosCargados().contains(elemento)

}

