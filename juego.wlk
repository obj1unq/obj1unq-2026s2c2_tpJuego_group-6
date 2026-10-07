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
    var puedeElegir = false
    const posicionInicial = game.origin().right(1).up(6)
    const celdasElegidas = []
    const celdas = (1..9).map { numero =>
        new Celda(
            position = posicionInicial.right(numero - 1),
            numero = numero
        )
    }

    method habilitarJugada() {
        self.cancelarSeleccion()
        puedeElegir = true
    }

    method elegir(numero, puntaje){
        if (puedeElegir) {
            const celda = celdas.get(numero - 1)
            if(not celda.cerrada() and celdasElegidas.size() < 2){
                celda.alternarEstado()
                celdasElegidas.add(celda)
                self.evaluarElegidas(puntaje)
            }
        }
    }

    method evaluarElegidas(puntaje){
        const suma = self.sumaElegidas()
        if(suma > puntaje or (celdasElegidas.size() == 2 and suma != puntaje)){
            celdasElegidas.forEach({celda => celda.alternarEstado()})
            celdasElegidas.clear()
            puedeElegir = false
        }
    }

     method confirmarJugada(jugador) {
        self.validarPuedeConfirmar()
        jugador.sumarPuntos(celdasElegidas.sum({celda=> celda.numero()}))
        celdasElegidas.clear()
        puedeElegir = false
    }
    method validarPuedeConfirmar() {
        if (self.sumaElegidas() != dados.puntaje()) {
            self.error("La suma de las celdas elegidas no coincide con el puntaje obtenido")
        }
    }

    method sumaElegidas(){
        var suma = 0
        celdasElegidas.forEach({celda => suma = suma + celda.numero()})
        return suma
    }
    method puedeCerrar(puntaje){
        const celdasAbiertas = celdas.filter({celda=> not celda.cerrada()}).map({celda=> celda.numero()})
        return celdasAbiertas.any({celda=> celda == puntaje or 
                                  celdasAbiertas.any({abierta => celda != abierta and celda + abierta == puntaje})})
    }
    method celdasRestantes(){
        return celdas.filter({celda=> not celda.cerrada()}).sum({celda=>celda.numero()})
         
    }

    method mostrar() {
        celdas.forEach { celda => celda.mostrar()}}

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
    method cancelarSeleccion() {
    celdasElegidas.forEach({ celda => celda.alternarEstado() })
    celdasElegidas.clear()
}
    method puedeSeguirTurno(puntaje) {
        return self.puedeCerrar(puntaje)
}

 /*   method terminarTurno(jugador) {
        jugador.sumarPuntos(self.celdasRestantes())
        if (self.cadaCeldaEstaCerrada()) {
            jugador.restar10()
    }
    self.reiniciarCelda()
}*/
    method reiniciarCelda(){
        celdas.forEach({celda=> if (celda.cerrada()){celda.alternarEstado()}})
    }
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
  const dado1 = new Dado(position = game.at(8,4))
  const dado2 = new Dado(position = game.at(9,4))
  method mostrar(){
    game.addVisual(dado1)
    game.addVisual(dado2)
  }
  method tirar(){
    dado1.tirar()
    dado2.tirar()
  }
  method puntaje() = dado1.numero() + dado2.numero() 
}
class Puntaje{
    var property position = game.at(0,9)
    var property jugador
    method text(){
        return jugador.puntaje().toString()
    }
}
class Jugador {
    var puntaje = 0
    //var turnos
    const property celdasElegidas = []
    var property position = game.at(0,10)  
    const celdas = #{}

    method sumarPuntos(puntos){
       // puntaje = puntaje + celdasElegidas.sum({celda=>celda.numero()})
          puntaje = puntaje + puntos
    }

    method restar10(){
        puntaje = (puntaje - 10).max(0)
    }

    method puntaje()= puntaje
    method image() {
      return "jugador-1.png"
    }

    method tirarDados() {
        
    } 
}