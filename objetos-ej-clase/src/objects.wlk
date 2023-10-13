object fiat600 {
    var tanqueNafta = 0

    method cargarNafta(litros) {
        // Minimo entre 27 y la suma
        tanqueNafta = 27.min(litros + tanqueNafta)
    }
    method consumirNafta(litros) {
        tanqueNafta = 0.max(tanqueNafta - litros)
    }
    method viajar(km) {
        self.consumirNafta(self.rendimiento(km))
    }
    method encender() {
        self.consumirNafta(0.2)
    }
    // Forma alternativa
    method tanque() = tanqueNafta
    // un Setter
    method tanque(litros) {
        tanqueNafta = litros
    }

    method puedeViajar(km) = tanqueNafta > self.rendimiento(km)

    method rendimiento(km) = km * 0.1

}

object meteoro {
    const auto = fiat600

    method irAlLaburo() {
        if (not self.meAlcanzaParaElViaje(5))
            auto.cargarNafta(10)

        auto.viajar(5)
    }

    method meAlcanzaParaElViaje(km) = auto.puedeViajar(2*km)
}

// Clases

object bife {
    const peso = 500

    method esSaludable() = peso < 500
}

class Ensalada {
    const ingredientes = [] // Valor default

    method esSaludable() = ingredientes.size() < 5
}

const ensaladaMixta = new Ensalada(ingredientes=["lechuga", "tomate", "cebolla"])
