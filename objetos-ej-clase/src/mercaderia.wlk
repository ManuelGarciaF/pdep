class Orden {

	const items = []

	method costoTotal() = items.sum{ item => item.costo() }

	method productosDelicados() = items.filter{ item => item.esDelicado() }.sortedBy{ item1 , item2 => item1.nombre() < item2.nombre() }

	method cantidadDe(nombreProducto) = items.filter{ item => item.nombre() == nombreProducto }.sum{ item => item.cantidad() }
	
	method productos() = items.map{ item => item.producto() }

}

class Item {

	const property producto
	const property cantidad

	method costo() = producto.costo() * cantidad

	method esDelicado() = producto.esDelicado()

	method nombre() = producto.nombre()

}

object producto {

	const property pesoDelicado = 5

}

class Producto {

	const valorAlmacenaje
	const property nombre = ""
	const peso

	method costoProduccion() // Metodo abstracto

	method costoAlmacenaje() = peso * valorAlmacenaje

	method costo() = self.costoProduccion() + self.costoAlmacenaje()

	method esDelicado() = peso < producto.pesoDelicado()

}

object productoComprado {

	const property indiceTraslado = 1.2

}

class ProductoComprado inherits Producto {

	const precioCompra

	override method costoProduccion() = precioCompra

	override method costoAlmacenaje() = super() * productoComprado.indiceTraslado()

}

object productoConservado {

	const property costoConservacion = 100

}

class ProductoConservado inherits Producto {

	const precioCompra
	var diasConservacion

	override method costoProduccion() = precioCompra + (diasConservacion * peso * productoConservado.costoConservacion())

}

object productoFabricado {

	const property costoHsHombre = 500

}

class ProductoFabricado inherits Producto {

	const cantidadHsHombre

	override method costoProduccion() = cantidadHsHombre * productoFabricado.costoHsHombre()

}

class Lote {

	const ordenes = []

	method cantidadDe(nombreProducto) = ordenes.sum{ orden => orden.cantidadDe(nombreProducto) }

	method productos() = 
		ordenes.flatMap{ orden => orden.productos() }
			.withoutDuplicates()
			.sortedBy{ producto1, producto2 => self.cantidadDe(producto1.nombre()) > self.cantidadDe(producto2.nombre()) }

}

