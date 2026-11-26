import wollok.game.*
import estados.*
import fondos.*

class Celda {
    var property position
    var property numero
    var property estado = celdaAbierta
    const reja = new Reja(position = position)

    method image() = "numero-" + numero + ".png"

    method mostrar() {
        game.addVisual(new BordeCelda(position = position))
        game.addVisual(self)
    }

    method alternarEstado() {
        estado = estado.alternarEstado()
        estado.mostrar(reja)
    }

    method LevantarReja() {
      self.alternarEstado()
    }

    method esCeldaCerrada() = estado.tieneReja()

}

class BordeCelda {
    var property position

    method image() = "borde-negro.png"
}

class Reja {
    var property position 

    method image() = "reja-cerrada.png"
}

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
        game.addVisual(avisoTirarDados)
    }
    method mostrarAviso(){
        game.removeVisual(dado1)
        game.removeVisual(dado2)
        game.addVisual(avisoTirarDados)
    }

    method tirar(){
        self.validarSipuedeTirarDados()
        estadoDado = deshabilitado
        dado1.tirar()
        dado2.tirar()
        self.mostrarResultado()
    }

    method puntaje() = dado1.numero() + dado2.numero() 

    method validarSipuedeTirarDados() {
        if(!estadoDado.puedeTirar()) {
            self.error("No puede tirar mas de una vez el dado")
        }
    }

    method habilitarJugadaDado() {
        estadoDado.habilitar(self)
        estadoDado = habilitado
    }
    method mostrarResultado(){
        game.removeVisual(avisoTirarDados)
        game.addVisual(dado1)
        game.addVisual(dado2)
    }
}

object selectorCeldas {
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

//CREA EL PUNTAJE EN PANTALLA
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
