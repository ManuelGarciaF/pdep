class Deposito {
	
	const camiones = []
	
	method cargaTotalEnViaje() = self.camionesEnViaje().sum{ camion => camion.cargaActual() }
	
	method camionesEnViaje() {
		return camiones.filter{ camion => camion.estaEnViaje() }
	}

	method caminoesCargando(elemento) =	camiones.filter{ camion => camion.estaCargando(elemento) }
	
}
