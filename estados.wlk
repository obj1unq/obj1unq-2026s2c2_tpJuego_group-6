import configuracion.*

//-------------------------------------
//ESTADOS DE LA CELDA
//-------------------------------------
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

//-------------------------------------
//ESTADOS DEL DADO
//-------------------------------------

object habilitado {
   method avanzarEstado(dados1){
    dados1.estadoDado(deshabilitado)
   }

   method puedeTirar(){
    return true
   }
}
object deshabilitado {
   method avanzarEstado(dados1){
    dados1.estadoDado(habilitado)
   }

   method puedeTirar(){
    return false
   }
}

//-------------------------------------
//ESTADOS DEL JUEGO Y OBJETOS VISUALES
//-------------------------------------
object pantallaInicioVisual {
    var property position = game.at(0, 0)
    method image() = "pantalla-inicio.png"
    // method text() = "--- EL PRESO ---\nPresione ENTER para comenzar"
}

object menuJugadoresVisual {
    var property position = game.at(3, 5)
    // method image() = "menu-" + juego.cantidadJugadoresSeleccionada() + "-jugadores.png" 
    method text() = "--- JUGADORES: " + juego.cantidadJugadoresSeleccionada() + " ---\nUse flecha ARRIBA / ABAJO\nPresione ENTER para confirmar"
}

object menuPuntajeVisual {
    var property position = game.at(3, 5)
    // method image() = "menu-puntaje-" + juego.puntajeLimiteSeleccionado() + ".png" 
    method text() = "--- LIMITE DE PUNTOS: " + juego.puntajeLimiteSeleccionado() + " ---\nUse flecha ARRIBA / ABAJO\nPresione ENTER para empezar a jugar"
}

object indicadorTurno {
    method position() {
        // Se ubica un casillero arriba del jugador que tiene el turno actual
        return juego.jugadorActual().position().right(1)
    }
    method image() = "indicador-turno2.png"
}

class EstadoJuego {
    method siguienteEstado(juego1) //abstracto
    method mostrar() //abstracto
    method presionarArriba(juego1){} //no hace nada
    method presionarAbajo(juego1){} //no hace nada
    method presionarEspacio(juego1, selectorActual){} //no hace nada
    method presionarG(juego1){}  //no hace nada
    method presionarP(juego1){} //no hace nada
    method presionarC(juego1){} //no hace nada
    method levantarRejas(juego1){} //no hace nada
}


object inicio inherits EstadoJuego {
    override method siguienteEstado(juego1) {
     self.mostrar()
     juego1.estado(seleccionJugadores)
   }

   override method mostrar() {
     game.removeVisual(pantallaInicioVisual)
     game.addVisual(menuJugadoresVisual)
   }
}


object seleccionJugadores inherits EstadoJuego {
    override method siguienteEstado(juego1) {
     self.mostrar()
     juego1.estado(seleccionPuntaje)
   }

   override method mostrar() {
     game.removeVisual(menuJugadoresVisual)
     game.addVisual(menuPuntajeVisual)
   }

    method cantidadDeJugadoresAJugar(cantJugadores) { //cambiar a consulta
        return if (cantJugadores < 4) cantJugadores + 1 else cantJugadores
    }

    method cantidadJugadoresASacar(cantJugadores) {
      return if (cantJugadores > 2) cantJugadores - 1 else cantJugadores
    }

    override method presionarArriba(juego1) {
        juego1.incrementarJugadores()
    }

    override method presionarAbajo(juego1) {
        juego1.decrementarJugadores()
    }
}


object seleccionPuntaje inherits EstadoJuego{
    override method siguienteEstado(juego1) {
     juego1.estado(jugando)
     juego1.comenzarPartidaReal()
   }

   override method mostrar() {
     game.removeVisual(menuJugadoresVisual)
   }

    method siguientePuntaje(indiceP,puntajeD) {
        return (indiceP + 1) % puntajeD.size()
    }

    method anteriorPuntaje(indiceP,puntajeD) {
        return (indiceP - 1 + puntajeD.size()) % puntajeD.size()
    }

    override method presionarArriba(juego1) {
        juego1.moverAsiguientePuntaje()
    }

    override method presionarAbajo(juego1) {
        juego1.moverAnteriorPuntaje()
    }
}


object jugando inherits EstadoJuego {
    override method siguienteEstado(juego1) {
        self.mostrar()
        juego1.estado(self)
    }

    override method mostrar() {
     game.removeVisual(menuPuntajeVisual)
   }

    override method presionarEspacio(juego1, selectorActual) {
        juego1.elegirCelda(selectorActual)
    }

    override method presionarG(juego1) {
        juego1.tirarDados()
    }

    override method presionarP(juego1) {
        juego1.confirmarJugada()
    }

    override method presionarC(juego1) {
        juego1.cancelarJugada()
    }

    override method levantarRejas(juego1) {
        juego1.levantarRejas()
    }
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

object fondoFinPartida {
    const property position = game.at(5,2)

    method image() { //CHEQUEAR
        return "youwin.png"
    }
}
