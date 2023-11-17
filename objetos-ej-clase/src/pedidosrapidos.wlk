class Pedido {
	
	const items = #{}
	
	method precioBruto() = items.sum{ item => item.valor() }
	
}

class Item {
	
	const property producto
	var property cantidad
	
	method valor() = producto.precio() * cantidad
	
}

class Producto {
	
	const property precio
	
}

class Cliente {
	
	method costoEnvio(pedido) = 300.min(calculadorCuadras.costoEnvio(pedido.local(), self)) 
	
}

object calculadorCuadras {
	
	const valorMaximo = 300
	const valorPorCuadra = 15
	
	method costoEnvio(local, cliente) = valorMaximo.min(self.distancia(local, cliente) * valorPorCuadra)

	method distancia(local, cliente) = 0 

}