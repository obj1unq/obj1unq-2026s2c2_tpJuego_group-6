import wollok.game.*
import configuracion.*

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
            self.error("No puede tirar mas de una vez el dado")
        }
    }

    method habilitarJugada() {
        tiradas = true
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

object celdaCerrada {
    method alternarEstado() {
      return celdaAbierta
    }

    method tieneReja() {
      return true
    }

    method mostrar(reja) {
      if(self.tieneReja()){
        game.addVisual(reja)
      }
    }
}

object celdaAbierta {
    method alternarEstado() {
      return celdaCerrada
    }

    method tieneReja() {
      return false
    }

    method mostrar(reja) {
      if(not self.tieneReja()){
        game.removeVisual(reja)
      }
    }
}

//---------------------------
//OBJETOS DEL JUEGO
//---------------------------
object pantallaInicioVisual {
    var property position = game.at(0, 0)
    method image() = "pantalla-inicio.png"
    // method text() = "--- EL PRESO ---\nPresione ENTER para comenzar"
}

object menuJugadoresVisual {
    const partida = juego
    var property position = game.at(3, 5)
    // method image() = "menu-" + juego.cantidadJugadoresSeleccionada() + "-jugadores.png" 
    method text() = "--- JUGADORES: " + partida.cantidadJugadoresSeleccionada() + " ---\nUse flecha ARRIBA / ABAJO\nPresione ENTER para confirmar"
}

object menuPuntajeVisual {
    const partida = juego
    var property position = game.at(3, 5)
    // method image() = "menu-puntaje-" + juego.puntajeLimiteSeleccionado() + ".png" 
    method text() = "--- LIMITE DE PUNTOS: " + partida.puntajeLimiteSeleccionado() + " ---\nUse flecha ARRIBA / ABAJO\nPresione ENTER para empezar a jugar"
}

object indicadorTurno {
    const partida = juego
    method position() {
        // Se ubica un casillero arriba del jugador que tiene el turno actual
        return partida.jugadorActual().position().right(1)
    }
    method image() = "indicador-turno2.png"
}

object inicio {
    method siguienteEstado() {
        game.removeVisual(pantallaInicioVisual)
        game.addVisual(menuJugadoresVisual)
        return seleccionJugadores
    }

    method presionarEspacio(juego1, selectorActual){}//no hace nada

    method presionarG(juego1) {} //no hace nada
    method presionarP(juego1){}//no hace nada
    method presionarC(juego1){} //no hace nada
}

object seleccionJugadores {
    method siguienteEstado() {
        game.removeVisual(menuJugadoresVisual)
        game.addVisual(menuPuntajeVisual)
        return seleccionPuntaje
    }

    method incrementarJugadores(cantJugadores) {
        return if (cantJugadores < 4) cantJugadores + 1 else cantJugadores
    }

    method decrementarJugadores(cantJugadores) {
      return if (cantJugadores > 2) cantJugadores - 1 else cantJugadores
    }

    method presionarArriba(juego1) {
        juego1.incrementarJugadores()
    }

    method presionarAbajo(juego1) {
        juego1.decrementarJugadores()
    }

    method presionarEspacio(juego1, selectorActual){} //no hace nada
    method presionarG(juego1) {} //no hace nada
    method presionarP(juego1){}//no hace nada
    method presionarC(juego1){} //no hace nada
}

object seleccionPuntaje {
    const partida = juego
    method siguienteEstado() {
        partida.comenzarPartidaReal()
        return jugando
    }

    method siguientePuntaje(indiceP,puntajeD) {
        return (indiceP + 1) % puntajeD.size()
    }

    method anteriorPuntaje(indiceP,puntajeD) {
        return (indiceP - 1 + puntajeD.size()) % puntajeD.size()
    }

    method presionarArriba(juego1) {
        juego1.siguientePuntaje()
    }

    method presionarAbajo(juego1) {
        juego1.siguientePuntaje()
    }

    method presionarEspacio(juego1, selectorActual){} //no hace nada
    method presionarG(juego1) {} //no hace nada
    method presionarP(juego1){}//no hace nada
    method presionarC(juego1){} //no hace nada
}

object jugando {
    
    method siguienteEstado() {
      return self
    }

    method presionarEspacio(juego1, selectorActual) {
        juego1.elegirCelda(selectorActual)
    }

    method presionarG(juego1) {
        juego1.tirarDados()
    }

    method presionarP(juego1) {
        juego1.confirmarJugada()
    }

    method presionarC(juego1) {
        juego1.cancelarJugada()
    }

    method levantarRejas(juego1) {
        juego1.levantarRejas()
    }

    method presionarArriba(juego1) {} //no hace nada
    method presionarAbajo(juego1) {} //no hace nada
}
object finPartida {
    const property position = game.at(5,2)

    method image() { //CHEQUEAR
        return "youwin.png"
    }

    method siguienteEstado() = self
    method presionarArriba(juego1) {} //no hace nada
    method presionarAbajo(juego1) {} //no hace nada 
    method presionarEspacio(juego1, selectorActual) {} //no hace nada
    method presionarG(juego1) {} //no hace nada
    method presionarP(juego1) {} //no hace nada
    method presionarC(juego1) {} //no hace nada
    method levantarRejas(juego1) {} //no hace nada
}
