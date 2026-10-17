import wollok.game.*

class Dado {
    var property numero = 1
    const property position

    method image() = "dadolado-" + numero + ".png"

    method tirar() {
        numero = (1..6).anyOne()
    }
}

object dados {
    const dado1 = new Dado(position = game.at(8,4))
    const dado2 = new Dado(position = game.at(9,4))
    var tiradas = true


    method mostrar(){
        game.addVisual(dado1)
        game.addVisual(dado2)
    }

    method tirar(){
        self.validarSipuedeTirarDados()
        tiradas = false
        dado1.tirar()
        dado2.tirar()
    }

    method puntaje() = dado1.numero() + dado2.numero() 

    method validarSipuedeTirarDados() {
        if(!tiradas) {
            self.error("no puede tirar mas de una vez el dado")
        }
    }

    method habilitarJugada() {
        tiradas = true
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

// == Movimiento ==
    method moverDerecha() {
        self.validarMoverDerecha()
        numero = numero + 1
        position = position.right(1)
    }

    method moverIzquierda() {
        self.validarMoverIzquierda()
        numero = numero - 1
        position = position.left(1)
    }

    method validarMoverDerecha() {
        if (numero >= 9){
            self.error("") // No se puede mover hacia la derecha
        }
    }
    
    method validarMoverIzquierda() { 
        if (numero <= 1){
            self.error("") // No se puede mover hacia la izquierda
        }
    }
}