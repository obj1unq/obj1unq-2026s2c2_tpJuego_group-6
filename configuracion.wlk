import wollok.game.*
import jugadores.*
import tablero.*
import elementos.*

object juego {
    var estado = "INICIO" // "INICIO", "SELECCION_JUGADORES", "SELECCION_PUNTAJE", "JUGANDO"
    
    const property jugadores = []
    var indiceTurno = 0
    
    var cantidadJugadoresSeleccionada = 2
    var puntajeLimiteSeleccionado = 50
    const puntajesDisponibles = [50, 100, 150]
    var indicePuntaje = 0

    method estado() = estado
    method cantidadJugadoresSeleccionada() = cantidadJugadoresSeleccionada
    method puntajeLimiteSeleccionado() = puntajeLimiteSeleccionado

    method avanzarEstado() {
        if (estado == "INICIO") {
            estado = "SELECCION_JUGADORES"
            game.removeVisual(pantallaInicioVisual)
            game.addVisual(menuJugadoresVisual)
        } else if (estado == "SELECCION_JUGADORES") {
            estado = "SELECCION_PUNTAJE"
            game.removeVisual(menuJugadoresVisual)
            game.addVisual(menuPuntajeVisual)
        } else if (estado == "SELECCION_PUNTAJE") {
            self.comenzarPartidaReal()
        }
    }

    method incrementarJugadores() {
        if (estado == "SELECCION_JUGADORES" and cantidadJugadoresSeleccionada < 4) {
            cantidadJugadoresSeleccionada = cantidadJugadoresSeleccionada + 1
        }
    }

    method decrementarJugadores() {
        if (estado == "SELECCION_JUGADORES" and cantidadJugadoresSeleccionada > 2) {
            cantidadJugadoresSeleccionada = cantidadJugadoresSeleccionada - 1
        }
    }

    method siguientePuntaje() {
        if (estado == "SELECCION_PUNTAJE") {
            indicePuntaje = (indicePuntaje + 1) % puntajesDisponibles.size()
            puntajeLimiteSeleccionado = puntajesDisponibles.get(indicePuntaje)
        }
    }

    method anteriorPuntaje() {
        if (estado == "SELECCION_PUNTAJE") {
            indicePuntaje = (indicePuntaje - 1 + puntajesDisponibles.size()) % puntajesDisponibles.size()
            puntajeLimiteSeleccionado = puntajesDisponibles.get(indicePuntaje)
        }
    }

    method comenzarPartidaReal() {
        game.removeVisual(menuPuntajeVisual)
        
        const posicionesDisponibles = [game.at(1, 2), game.at(3, 2), game.at(5, 2), game.at(7, 2)]
    
        (1..cantidadJugadoresSeleccionada).forEach { i =>
            const pos = posicionesDisponibles.get(i - 1)
            const j = new Jugador(numero = i, position = pos, limitePuntaje = puntajeLimiteSeleccionado)
        
            jugadores.add(j)
            game.addVisual(j) // Muestra el sprite del jugador
            game.addVisual(new Puntaje(jugador = j)) // Muestra su puntaje abajo
        }
        
        estado = "JUGANDO"
        tablero.mostrar()
        dados.mostrar()
        game.addVisual(selector)
        game.addVisual(indicadorTurno)
    }

    method jugadorActual() = jugadores.get(indiceTurno)

    method pasarTurno() {
        indiceTurno = (indiceTurno + 1) % jugadores.size()
    }
}

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
        return juego.jugadorActual().position().up(1)
    }
    method image() = "indicador-turno.png"
}