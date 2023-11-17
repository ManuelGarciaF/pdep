class Linea {
	
	const property numero
	const packs = []
	const consumos = []
	var deuda = 0
	var tipoLinea = lineaComun
	
	method promedioConsumos(fechaInicio, fechaFin) =
		(consumos.filter{ consumo => consumo.entre(fechaInicio, fechaFin) }
			.sum{ consumo => consumo.precio() }) / (consumos.size()).max(1)
	
	method totalMes() =
		consumos.filter{ consumo => consumo.ultimoMes() }
			.sum{ consumo => consumo.precio()}
			
	method agregarPack(pack) {
		packs.add(pack)
	}
	
	method hacerConsumo(consumo) {
		tipoLinea.hacerConsumo(self, consumo)
	}
	
	method agregarConsumo(consumo) {
		consumos.add(consumo)
	}
	
	method agregarDeuda(deudaAgregada) {
		deuda += deudaAgregada
	}
	
	method cambiarPlan(nuevoPlan) {
		tipoLinea = nuevoPlan
	}
	
	method puedeHacerConsumo(consumo) = packs.any{ pack => pack.satisface(consumo) }
	
	method usarPack(consumo) {
		packs.filter{ pack => pack.satisface(consumo) }.last().consumir(consumo)
	}
	
	method limpiarPacks() {
		packs.removeAllSuchThat{ pack => pack.vencido() or pack.acabado() }
	}
	
}

object lineaComun {
	method hacerConsumo(linea, consumo) {
		if (!linea.puedeHacerConsumo(consumo))
			throw new LineaException(message = "No se puede realizar el consumo con los packs de la linea")
		
		linea.agregarConsumo(consumo)
		linea.usarPack(consumo)
	}
}

object lineaBlack {
	
	method hacerConsumo(linea, consumo) {
		if (linea.puedeHacerConsumo(consumo))
			linea.usarPack(consumo)
		else
			linea.agregarDeuda(consumo.precio())
		
		linea.agregarConsumo(consumo)
	}

}

object lineaPlatinum {
	
	method hacerConsumo(linea, consumo) {
		linea.agregarConsumo(consumo)
	}

}


class Consumo {
	
	const fecha = new Date()
	
	method entre(fechaInicio, fechaFin) = fecha.between(fechaInicio, fechaFin)
	
	method ultimoMes() = (fecha - (new Date())) <= 30
	
	method cubiertoPorMegas(megasDisponibles) = false
	
	method cubiertoPorInternetIlimitado() = false
	
	method cubiertoPorLlamadasGratis() = false
	
	method megas() = 0 // Nunca se va a ejecutar pero elimina warnings
	
}

object consumoInternet {
	const property precioPorMB = 0.10
}

class ConsumoInternet inherits Consumo {
	
	const property megas
	
	method precio() = megas * consumoInternet.precioPorMB()
	
	override method cubiertoPorMegas(megasDisponibles) = megas <= megasDisponibles
	
	override method cubiertoPorInternetIlimitado() = true
		
}

object consumoLlamada {
	const property precioPorSegundo = 0.05
	const property precioFijo = 1
}

class ConsumoLlamada inherits Consumo {
	
	const segundos
	
	method precio() = consumoLlamada.precioFijo() + self.precioVariable()
	
	method precioVariable() = (segundos - 30).max(0) * consumoLlamada.precioPorSegundo()
	
	override method cubiertoPorLlamadasGratis() = true
	
}

class Pack {
	
	const vencimiento
	
	method consumir(consumo) {} // Por defecto no hacer nada
	
	method vencido() = vencimiento < new Date()
	
	method satisface(consumo) = !self.vencido()
	
	method acabado() = false // Cubre packs que no se acaban

}

class PackCredito inherits Pack {
	
	var credito
	
	override method satisface(consumo) = super(consumo) and consumo.precio() <= credito
	
	override method consumir(consumo) {
		credito -= consumo.precio()
	}
	
	override method acabado() = credito == 0
	
}

class PackMBLibres inherits Pack {
	
	var megasLibres
	
	override method satisface(consumo) = super(consumo) and consumo.cubiertoPorMegas(megasLibres)
	
	override method consumir(consumo) {
		megasLibres -= consumo.megas()
	}
	
	override method acabado() = megasLibres == 0
	
}

class PackMBLibresPlusPlus inherits Pack {
	
	var megasLibres
	
	override method satisface(consumo) = super(consumo) and consumo.cubiertoPorMegas(megasLibres.max(0.1))
	
	override method consumir(consumo) {
		megasLibres -= consumo.megas()
	}
	
	override method acabado() = megasLibres == 0
	
}

class PackLlamadasGratis inherits Pack {
	
	override method satisface(consumo) = super(consumo) and consumo.cubiertoPorLlamadasGratis()
	
}

class PackInternetIlimitadoFindes inherits Pack {
	
	override method satisface(consumo) = super(consumo) and consumo.cubiertoPorInternetIlimitado() and self.esFinde()
	
	method esFinde() = (new Date()).isWeekendDay()
	
}

class LineaException inherits Exception {}




