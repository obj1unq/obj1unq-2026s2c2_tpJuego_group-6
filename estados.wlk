import fondos.*
import elementos.*

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

   method puedeTirar(){
    return true
   }
}
object deshabilitado {

   method puedeTirar(){
    return false
   }
}

//-------------------------------------
//ESTADOS DEL JUEGO
//-------------------------------------

class EstadoJuego {

    method siguienteEstado(juego) //abstracto
    method mostrar() //abstracto
    method presionarEnter(juego){}
    method presionarArriba(juego){}
    method presionarAbajo(juego){}
    method presionarDerecha(juego, selectorActual){}   //prefiero con arriba y abajo pero como quieras
    method presionarIzquierda(juego, selectorActual){} 
    method presionarEspacio(juego, selectorActual){}
    method presionarG(juego){}
    method presionarDelete(juego){} 
    method levantarRejas(juego){} 
}


object inicio inherits EstadoJuego {
    override method siguienteEstado(juego) {
     self.mostrar()
     juego.estado(tutorialTeclas)
   }

   override method mostrar() {
      game.removeVisual(pantallaInicioVisual)
      game.addVisual(fondoTutorialTeclas)
   }

   override method presionarEnter(juego) {
     self.siguienteEstado(juego)
   }
}

object tutorialTeclas inherits EstadoJuego {
  override method siguienteEstado(juego) {
     self.mostrar()
     juego.estado(seleccionJugadores)
     juego.marcadorMenu().mostrar(juego.cantidadJugadoresSeleccionada())
   }
  
  override method mostrar() {
      game.removeVisual(fondoTutorialTeclas)
      game.addVisual(menuJugadoresVisual)
   }

   override method presionarEnter(juego) {
     self.siguienteEstado(juego)
   }
}


object seleccionJugadores inherits EstadoJuego {
    override method siguienteEstado(juego) {
      self.mostrar()
      juego.marcadorMenu().limpiar()
      juego.iniciarSeleccionAvatar()
      juego.estado(seleccionAvatares)
      juego.marcadorMenu().mostrar(juego.jugadorEligiendo())
   }

   override method mostrar() {
      game.removeVisual(menuJugadoresVisual)
      game.addVisual(menuAvataresVisual)
      game.addVisual(vistaAvatar)
   }

    method cantidadDeJugadoresAJugar(cantJugadores) = if (cantJugadores < 4) cantJugadores + 1 else cantJugadores

    method cantidadJugadoresASacar(cantJugadores) = if (cantJugadores > 2) cantJugadores - 1 else cantJugadores

    override method presionarArriba(juego) {
        juego.incrementarJugadores()
    }

    override method presionarAbajo(juego) {
        juego.decrementarJugadores()
    }

    override method presionarEnter(juego) {
     self.siguienteEstado(juego)
   }
}

object seleccionAvatares inherits EstadoJuego{ //COMPLETAR
    override method siguienteEstado(juego){
      juego.confirmarAvatar()
      if(juego.todosEligieronAvatar()){
        self.mostrar()
        juego.estado(seleccionPuntaje)
        juego.marcadorMenu().mostrar(juego.puntajeLimiteSeleccionado())
      }
    }
    override method mostrar(){
      game.removeVisual(menuAvataresVisual)
      game.removeVisual(vistaAvatar)
      game.addVisual(menuPuntajeVisual)
    }
    override method presionarArriba(juego){juego.moverAvatar(1)}
    override method presionarAbajo(juego){juego.moverAvatar(-1)}
    
    override method presionarEnter(juego) {
     self.siguienteEstado(juego)
   }
}

object seleccionPuntaje inherits EstadoJuego{
    override method siguienteEstado(juego) {
     self.mostrar()
     juego.estado(jugando)
     juego.comenzarPartidaReal()
   }

   override method mostrar() {
      game.removeVisual(menuPuntajeVisual)
      game.addVisual(fondoVisual)
   }

    method siguientePuntaje(indiceP,puntajeD) = (indiceP + 1) % puntajeD.size()

    method anteriorPuntaje(indiceP,puntajeD) = (indiceP - 1 + puntajeD.size()) % puntajeD.size()

    override method presionarArriba(juego) {
        juego.moverAsiguientePuntaje()
    }

    override method presionarAbajo(juego) {
        juego.moverAnteriorPuntaje()
    }

    override method presionarEnter(juego) {
     self.siguienteEstado(juego)
   }
}


object jugando inherits EstadoJuego {

    override method siguienteEstado(juego) {
        self.mostrar()
        juego.estado(self)
    }

    override method mostrar() {
        game.addVisual(fondoVisual)//cambiar por que esta de mas
   }

    override method presionarEspacio(juego, selectorActual) {
        juego.elegirCelda(selectorActual)
    }

    override method presionarG(juego) {
        juego.tirarDados()
    }

    override method presionarEnter(juego) {
        juego.confirmarJugada() 
    }

    override method presionarDelete(juego) {
        juego.cancelarJugada()
    }

    override method levantarRejas(juego) {
        juego.levantarRejas()
    }
    override method presionarDerecha(juego, selectorActual) {
        selectorActual.moverDerecha()
    }

    override method presionarIzquierda(juego, selectorActual) {
        selectorActual.moverIzquierda()
    }
}

object finPartida inherits EstadoJuego { 
    override method siguienteEstado(juego) {
      juego.marcadorMenu().limpiar()
      game.clear()
      self.mostrar()
      juego.marcadorGanador().mostrar(ganadorVisual.ganador().numero())
      juego.estado(self)
      //game.schedule(5000, {game.stop()})
    }

    override method mostrar() {
      game.addVisual(fondoFinPartida)
      game.addVisual(ganadorVisual)
    }
}

