import juego.*
import elementos.*
object configuracion {
    const juego = elPreso
    const selector = selectorCeldas
    method configEscenario() {
        game.title("El Preso")
        game.height(11)
        game.width(14)
        game.cellSize(64)
  }
  
  method configControles() {
        // Controles de menú
        keyboard.enter().onPressDo({ juego.presionarEnter() })
        keyboard.up().onPressDo({ juego.presionarArriba() })
        keyboard.down().onPressDo({ juego.presionarAbajo() })
  
        // Controles dentro del juego
        keyboard.right().onPressDo({ juego.moverDerecha(selector) })
        keyboard.left().onPressDo({ juego.moverIzquierda(selector) })
        keyboard.space().onPressDo({ juego.presionarEspacio(selector) })
        keyboard.g().onPressDo({ juego.presionarG() })
        keyboard.p().onPressDo({ juego.presionarP() })
        keyboard.c().onPressDo({ juego.presionarC() })
  }
}