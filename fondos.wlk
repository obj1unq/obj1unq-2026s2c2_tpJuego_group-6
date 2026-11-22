import juego.*
object pantallaInicioVisual {
    var property position = game.at(-1, 0)
    method image() = "pantalla-inicio.png"
}

object menuJugadoresVisual {
    var property position = game.at(-1, 0)

    method image() = "fondoVisualJugadores.png"
}

object menuAvataresVisual {
    var property position = game.at(-1, 0)

    method image() = "fondoVisualAvatares.png"
}

object menuPuntajeVisual {
    var property position = game.at(-1, 0)
    method image() = "fondoVisualPuntaje.png"
}

object fondoVisual {
    var property position = game.at(-1, 0)
    method image() = "prisionfondo.png"
}

object indicadorTurno {
    const juego = elPreso
    method position() {
        // Se ubica un casillero arriba del jugador que tiene el turno actual
        return juego.jugadorActual().position().right(1)
    }
    method image() = "indicador-turno2.png"
}

object teclasArribaAbajo {
    var property position = game.at(2,2)

    method image() = "teclaArribaAbajo.png"
}

object vistaAvatar {
  const juego = elPreso
  var property position = game.at(6,4)
  method image() = "amongusGrande-" + juego.avatarEnSeleccion() + ".png"
  //method text() = "Jugador " + juego.jugadorEligiendo() 
}

object fondoFinPartida {
    const property position = game.at(5,2)

    method image() { 
        return "youwin.png"
    }
}