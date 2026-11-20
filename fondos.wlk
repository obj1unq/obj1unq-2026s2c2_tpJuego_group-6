import configuracion.*
object pantallaInicioVisual {
    var property position = game.at(-1, 0)
    method image() = "pantalla-inicio.png"
    // method text() = "--- EL PRESO ---\nPresione ENTER para comenzar"
}

// object menuJugadoresVisual { //cambiar, a un solo objeto o clase, por que hace lo mismo que menuPuntajeVisuall
//     //var property position = game.at(3, 5)
//     var property position = game.at(-1, 0)
//     // method image() = "menu-" + juego.cantidadJugadoresSeleccionada() + "-jugadores.png" 
//     //method text() = "--- JUGADORES: " + juego.cantidadJugadoresSeleccionada() + " ---\nUse flecha ARRIBA / ABAJO\nPresione ENTER para confirmar"

//     method image() = "celdas.png"
// }

// object menuPuntajeVisual { //cambiar, a un solo objeto por que hace lo mismo que menuJHugadoreVisual
//     var property position = game.at(-1, 0)
//     // method image() = "menu-puntaje-" + juego.puntajeLimiteSeleccionado() + ".png" 
//     //method text() = "--- LIMITE DE PUNTOS: " + juego.puntajeLimiteSeleccionado() + " ---\nUse flecha ARRIBA / ABAJO\nPresione ENTER para empezar a jugar"
//     method image() = "celdas.png"
// }

object fondoVisual {
    var property position = game.at(-1, 0)
    method image() = "celdas.png"
}

object indicadorTurno {
    method position() {
        // Se ubica un casillero arriba del jugador que tiene el turno actual
        return juego.jugadorActual().position().right(1)
    }
    method image() = "indicador-turno2.png"
}

object fondoJugadoresCantidad {
    var property position = game.at(3,-2)

    method image() = "cantidadJugadoresFondo.png"
}

object fondojugadores {
    var property position = game.at(3,2)

    method image() = "jugadoresFondo.png"
}

object teclasArribaAbajo {
    var property position = game.at(4,2)

    method image() = "teclaArribaAbajo.png"
}

object fondoCantidadPuntos {
    var property position = game.at(3,-2)

    method image() = "cantidadPuntos.png"
}

object fondoLimitePuntos {
    var property position = game.at(3,2)

    method image() = "limitepuntos.png"
}

object fondoEnter {
    var property position = game.at(3,-3)

    method image() = "presionarenter.png"
}
