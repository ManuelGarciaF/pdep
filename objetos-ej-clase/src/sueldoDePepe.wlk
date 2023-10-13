object pepe {
	var puesto = cadete
	var bonoPorPresentismo = nulo
	var faltas = 0
	var bonoPorResultados = nulo
	const empleados = []
	
	method sueldo() = 
		puesto.neto() +
		bonoPorPresentismo.valor(self) +
		bonoPorResultados.valor(self)
	
	// Setters
	method puesto(_puesto) {
		puesto = _puesto
	}
	method bonoPorPresentismo(_bonoPorPresentismo) {
		bonoPorPresentismo = _bonoPorPresentismo
	}
	method faltas(_faltas) {
		faltas = _faltas
	}
	method bonoPorResultados(_bonoPorResultados) {
		bonoPorResultados = _bonoPorResultados
	}
	method neto() = puesto.neto() // No debe recaer en otros objetos saber como calcular el sueldo neto de pepe
	method faltas() = faltas
	
	method totalSueldos() = empleados.sum{empleado => empleado.sueldo()}
}

object gerente {
	method neto() = 1000
}

object cadete {
	method neto() = 1500
}

object presentismo {
	method valor(empleado) =
		if (empleado.faltas() == 0)
			100
		else if (empleado.faltas() == 1)
			50
		else
			0
}

object nulo {
	method valor(empleado) = 0
}

object resultadoVariable {
	method valor(empleado) = empleado.neto() * 0.1
}

object resultadoFijo {
	method valor(empleado) = 80
}