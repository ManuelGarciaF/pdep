import errores.*

// State pattern
class EstadoCamion {

	method puedeCargar(camion, coso) = false

	method validarCarga(camion, coso) {
		throw new CargaException(message = "Camion no disponible para carga no puede cargarse")
	}

	method salirDeReparacion(camion) {
		throw new TransicionException(message = "El camion no puede salir de reparacion desde este estado")
	}

	method entrarEnReparacion(camion) {
		throw new TransicionException(message = "El camion no puede entrar en reparacion desde este estado")
	}

	method estaListoParaPartir(camion) = false

	method estaEnViaje() = false
	
	method estaCargando(camion) = false

}

object disponibleParaCarga inherits EstadoCamion {

	override method puedeCargar(camion, coso) = camion.puedeCargarPeso(coso)

	override method validarCarga(camion, coso) {
		camion.validarPeso(coso)
	}

	override method entrarEnReparacion(camion) {
		camion.estado(enReparacion)
	}

	override method estaListoParaPartir(camion) = camion.tienePesoSuficienteParaPartir()
	
	override method estaCargando(camion) = !camion.estaListoParaPartir()

}

object enReparacion inherits EstadoCamion {

	override method salirDeReparacion(camion) {
		camion.estado(disponibleParaCarga)
	}

}

object deViaje inherits EstadoCamion {

	override method entrarEnReparacion(camion) {
		camion.estado(enReparacion)
	}

	override method estaEnViaje() = true

}

