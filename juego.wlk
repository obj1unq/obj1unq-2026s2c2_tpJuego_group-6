import wollok.game.*

class Celda {
    var property position
    var property numero
    var property cerrada = false
    const reja = new Reja(position = position)

    method image() {
        return "numero-" + numero + ".png"
    }

    method mostrar() {
        game.addVisual(new BordeCelda(position = position))
        game.addVisual(self)
    }

    method alternarEstado() {
        if (cerrada) {
            cerrada = false
            game.removeVisual(reja)
        } else {
            cerrada = true
            game.addVisual(reja)
        }
    }
}

class BordeCelda {
    var property position

    method image() {
        return "borde-negro.png"
    }
}

class Reja {
    var property position 

    method image(){
        return "reja-cerrada.png"
    }
}

class Selector {
    var property position = game.origin().right(1).up(6)
    var property numero = 1

    method image() {
        return "selector-rojo.png"
    }

    method numeroSeleccionado() {
        return numero
    }

    method moverDerecha() {
        if (numero < 9) {
            numero = numero + 1
            position = position.right(1)
        }
    }

    method moverIzquierda() {
        if (numero > 1) {
            numero = numero - 1
            position = position.left(1)
        }
    }
}

object tablero {
    const posicionInicial = game.origin().right(1).up(6)

    const celdas = (1..9).map { numero =>
        new Celda(
            position = posicionInicial.right(numero - 1),
            numero = numero
        )
    }

    method mostrar() {
        celdas.forEach { celda =>
            celda.mostrar()
        }
    }

    method alternarCelda(numero) {
        celdas.get(numero - 1).alternarEstado()
    }

}