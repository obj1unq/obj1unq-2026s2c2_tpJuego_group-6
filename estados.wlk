import fondos.*

//-------------------------------------
//ESTADOS DEL TABLERO
//-------------------------------------

object elegido {
    method puedeElegir() {
      return true
    }

    method avanzarEstado(tableroT) {
      tableroT.estadoEleccion(noElegido)
    }
}

object noElegido {
    method puedeElegir() {
      return false
    }

    method avanzarEstado(tableroT) {
      tableroT.estadoEleccion(elegido)
    }
} 

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
//ESTADOS DEL JUEGO
//-------------------------------------

class EstadoJuego {

    method siguienteEstado(juego1) //abstracto
    method mostrar() //abstracto
    method presionarArriba(juego1){}
    method presionarAbajo(juego1){}
    method presionarDerecha(juego1, selectorActual){}   //prefiero con arriba y abajo pero como quieras
    method presionarIzquierda(juego1, selectorActual){} 
    method presionarEspacio(juego1, selectorActual){}
    method presionarG(juego1){}
    method presionarP(juego1){}
    method presionarC(juego1){} 
    method levantarRejas(juego1){} 
}


object inicio inherits EstadoJuego {
    override method siguienteEstado(juego1) {
     self.mostrar()
     juego1.estado(seleccionJugadores)
     juego1.marcadorMenu().mostrar(juego1.cantidadJugadoresSeleccionada())
   }

   override method mostrar() {
      game.removeVisual(pantallaInicioVisual)
      game.addVisual(menuJugadoresVisual)
   }
}


object seleccionJugadores inherits EstadoJuego {
    override method siguienteEstado(juego1) {
      self.mostrar()
      juego1.marcadorMenu().limpiar()
      juego1.iniciarSeleccionAvatar()
      juego1.estado(seleccionAvatares)
      juego1.marcadorMenu().mostrar(juego1.jugadorEligiendo())
   }

   override method mostrar() {
      game.removeVisual(menuJugadoresVisual)
      game.addVisual(menuAvataresVisual)
      game.addVisual(vistaAvatar)
   }

    method cantidadDeJugadoresAJugar(cantJugadores) = if (cantJugadores < 4) cantJugadores + 1 else cantJugadores

    method cantidadJugadoresASacar(cantJugadores) = if (cantJugadores > 2) cantJugadores - 1 else cantJugadores

    override method presionarArriba(juego1) {
        juego1.incrementarJugadores()
    }

    override method presionarAbajo(juego1) {
        juego1.decrementarJugadores()
    }
}

object seleccionAvatares inherits EstadoJuego{ //COMPLETAR
    override method siguienteEstado(juego1){
      juego1.confirmarAvatar()
      if(juego1.todosEligieronAvatar()){
        self.mostrar()
        juego1.estado(seleccionPuntaje)
        juego1.marcadorMenu().mostrar(juego1.puntajeLimiteSeleccionado())
      }
    }
    override method mostrar(){
      game.removeVisual(menuAvataresVisual)
      game.removeVisual(vistaAvatar)
      game.addVisual(menuPuntajeVisual)
    }
    override method presionarArriba(juego1){juego1.moverAvatar(1)}
    override method presionarAbajo(juego1){juego1.moverAvatar(-1)}
}

object seleccionPuntaje inherits EstadoJuego{
    override method siguienteEstado(juego1) {
     self.mostrar()
     juego1.estado(jugando)
     juego1.comenzarPartidaReal()
   }

   override method mostrar() {
      game.removeVisual(menuPuntajeVisual)
      game.addVisual(fondoVisual)
   }

    method siguientePuntaje(indiceP,puntajeD) = (indiceP + 1) % puntajeD.size()

    method anteriorPuntaje(indiceP,puntajeD) = (indiceP - 1 + puntajeD.size()) % puntajeD.size()

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
        game.addVisual(fondoVisual)//cambiar por que esta de mas
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
    override method presionarDerecha(juego1, selectorActual) {
        selectorActual.moverDerecha()
    }

    override method presionarIzquierda(juego1, selectorActual) {
        selectorActual.moverIzquierda()
    }
}

object finPartida inherits EstadoJuego { 
    override method siguienteEstado(juego1) {
      self.mostrar()
      juego1.estado(self)
      //game.schedule(5000, {game.stop()})
    }

    override method mostrar() {
      game.addVisual(fondoFinPartida)
    }
}
