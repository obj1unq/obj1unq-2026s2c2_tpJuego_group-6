import wollok.game.*
import direcciones.*

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

    method LevantarReja() {
      self.alternarEstado()
    }

    method esCeldaCerra() {
      return cerrada
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

    //camios que se podria agregar al movimiento?-----------------------------------------
    method avanzar() {
        numero = numero + 1
		position = game.at((game.width() - 2).min(position.x() + 1), position.y()) 
	}

    method retroceder() {
        numero = numero - 1
		position = game.at(1.max(position.x() - 1), position.y()) 
	}
    //---------------------------------------------------------------------------------------


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

    method levantasRejas() {
      if(self.cadaCeldaEstaCerrada()){
      celdas.forEach({celda => celda.LevantarReja()})
      }
    }

    method cadaCeldaEstaCerrada() {
        return celdas.all({celda => celda.cerrada()}) 
    }

}

object dadoAleatorio1 {
    const property position = game.at(9,4)
    //var numeroDado = 1.randomUpTo(9).truncate(0)
    const dadosAleatorios = ["dadolado-1.png", "dadolado-2.png", "dadolado-3.png", "dadolado-4.png", "dadolado-5.png", "dadolado-6.png"]
    var dadoActual = "dadolado-1.png"

    method image() {
      return dadoActual
    }

    method tirarDados() {
      dadoActual = dadosAleatorios.anyOne()
    }
}

class Dado {

}

class Jugador {
    //var puntaje
    //var turnos
    var property position = game.at(0,10)  

    method image() {
      return "jugador-1.png"
    }

    method tirarDados() {
        
    } 
}



