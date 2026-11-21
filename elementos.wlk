import wollok.game.*
import configuracion.*
import estados.*

class Dado {
    var property numero = 1
    const property position

    method image() = "dadolado-" + numero + ".png"

    method tirar() {
        numero = (1..6).anyOne()
    }
}

object dados {
    const dado1 = new Dado(position = game.at(5,1))
    const dado2 = new Dado(position = game.at(6,1))
    var estadoDado = habilitado //HABILITADO PARA TIRAR DADO Y DESHABILITADO CUANDO NO PUEDE TIRAR. CAMBIAR NOMBRES SI ES NECESARIO

    method estadoDado(_estadoDado) {
      estadoDado = _estadoDado
    }

    method mostrar(){
        game.addVisual(dado1)
        game.addVisual(dado2)
    }

    method tirar(){
        self.validarSipuedeTirarDados()
        estadoDado.avanzarEstado(self)
        dado1.tirar()
        dado2.tirar()
    }

    method puntaje() = dado1.numero() + dado2.numero() 

    method validarSipuedeTirarDados() {
        if(!estadoDado.puedeTirar()) {
            self.error("No puede tirar mas de una vez el dado")
        }
    }

    method habilitarJugadaDado() {
        estadoDado.avanzarEstado(self)
    }
}

object selector {
    var property position = game.at(1,5)//game.origin().right(1).up(5)
    var property numero = 1

    method image() = "selector-rojo.png"

    method numeroSeleccionado() = numero

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

class Puntaje {
    const property numero
    const property position

    method image() = "numeroPuntaje-" + numero + ".png"
}

class Marcador {
    const property x
    const property y
    const puntaje = []
  
    method mostrar(numero) {
      self.limpiar()
      self.crearDigitos(numero)
      self.dibujar()
    }
  
    method crearDigitos(numero) {
      const texto = numero.toString()
      puntaje.addAll((0..texto.size() - 1).map({ i => self.crearDigito(texto.charAt(i), i) }))
    }
  
    method crearDigito(caracter, indice) = new Puntaje(numero = caracter, position = game.at(x + indice, y))
  
    method dibujar() {
      puntaje.forEach({ d => game.addVisual(d) })
    }
  
    method limpiar() {
      puntaje.forEach({ d => game.removeVisual(d) })
      puntaje.clear()
    }
}
