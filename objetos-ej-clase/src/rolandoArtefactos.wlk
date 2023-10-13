import rolandoPersonaje.fuerzaOscura

class Artefacto {
	const fechaDeCompra
	
	method pesoBase() = 0

	method factorDeCorreccion() {
		const fechaActual = new Date()
		return 1.min((fechaActual - fechaDeCompra) / 1000)
	}
	
	method peso() = 0.max(self.pesoBase() - self.factorDeCorreccion())
}

object arma {

	const unidadesLucha = 3

	method unidadesDeLucha(luchador) = unidadesLucha
	
	method precio() = 5 * unidadesLucha

}

class CollarDivino inherits Artefacto {

	var property cantidadDePerlas = 5

	method unidadesDeLucha(luchador) = cantidadDePerlas
	
	method precio() = 2 * cantidadDePerlas

	override method pesoBase() = 0.5 * cantidadDePerlas
}

class Mascara inherits Artefacto {

	const indiceDeOscuridad
	var property unidadesMinimas = 4

	method unidadesDeLucha() = unidadesMinimas.max(fuerzaOscura.valor() / 2) * indiceDeOscuridad

	method unidadesDeLucha(luchador) = self.unidadesDeLucha()
	
	method precio() = 70 + fuerzaOscura.valor() * indiceDeOscuridad

	override method pesoBase() = 0.max(self.unidadesDeLucha() - 3)

}

class Armadura inherits Artefacto {

	const property unidadesBase = 2
	var property refuerzo = nulo

	method unidadesDeLucha(luchador) = unidadesBase + refuerzo.unidadesDeLucha(luchador)

	method precio() = refuerzo.precio(self) 
	
	override method pesoBase() = refuerzo.pesoRefuerzo()
}


class CotaDeMalla {
	
	const unidadesLucha

	method unidadesDeLucha(luchador) = unidadesLucha
	
	method precio(armadura) = unidadesLucha / 2
	
	method pesoRefuerzo() = 1
}

object bendicion {

	method unidadesDeLucha(luchador) = luchador.nivelDeHechiceria()

	method precio(armadura) = armadura.unidadesBase()
	
	method pesoRefuerzo() = 0
}

object nulo {

	method unidadesDeLucha(luchador) = 0
	
	method precio(armadura) = 2

	method pesoRefuerzo() = 0
}

object espejoFantastico {

	method unidadesDeLucha(luchador) = luchador.unidadesDeMejorArtefactoSinArtefacto(self)
	
}

