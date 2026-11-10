//import juego.*
import wollok.game.*
import jugadores.*
import tablero.*
import elementos.*

object juego {
    //var estado = "INICIO" // "INICIO", "SELECCION_JUGADORES", "SELECCION_PUNTAJE", "JUGANDO"
    var estado = inicio

    const property jugadores = []
    const property tableros = []
    var indiceTurno = 0
    var participantesRonda = []

    var cantidadJugadoresSeleccionada = 2
    var puntajeLimiteSeleccionado = 50
    const puntajesDisponibles = [50, 100, 150]
    var indicePuntaje = 0
    var juegoIniciado = false

    method estado() = estado
    method cantidadJugadoresSeleccionada() = cantidadJugadoresSeleccionada
    method puntajeLimiteSeleccionado() = puntajeLimiteSeleccionado

    method pasarMenu() {
        if (!juegoIniciado) {
            juegoIniciado = true
            self.avanzarEstado()
        } else {
            self.avanzarEstado()
        }
    }

    method avanzarEstado() {
        estado = estado.siguienteEstado()
    }

    method incrementarJugadores() {
        cantidadJugadoresSeleccionada = estado.incrementarJugadores(cantidadJugadoresSeleccionada)
    }

    method decrementarJugadores() {
        cantidadJugadoresSeleccionada = estado.decrementarJugadores(cantidadJugadoresSeleccionada)
    }

    method siguientePuntaje() {
        indicePuntaje = estado.siguientePuntaje(indicePuntaje, puntajesDisponibles)
        puntajeLimiteSeleccionado = puntajesDisponibles.get(indicePuntaje)
    }

    method anteriorPuntaje() {
        indicePuntaje = estado.anteriorPuntaje(indicePuntaje, puntajesDisponibles)
        puntajeLimiteSeleccionado = puntajesDisponibles.get(indicePuntaje)
    }

    method moverDerecha(selector) {
        selector.moverDerecha()
    }

    method moverIzquierda(selector) {
        selector.moverIzquierda()
    }

    method presionarArriba() {
        estado.presionarArriba(self)
    }

    method presionarAbajo() {
        estado.presionarAbajo(self)
    }

    method presionarEspacio(selectorActual) {
        estado.presionarEspacio(self, selectorActual)
    }

    method presionarG() {
        estado.presionarG(self)
    }

    method presionarP() {
        estado.presionarP(self)
    }

    method presionarC() {
        estado.presionarC(self)
    }

    method alterarRejasCeldas() {
        estado.levantarRejas(self)
    }

    method elegirCelda(selectorActual) {
        self.tableroActual().elegir2(selectorActual.numeroSeleccionado(), dados.puntaje())
    }

    method tirarDados() {
        dados.tirar()
        self.tableroActual().habilitarJugada()
        self.pasarTurnoSinJugada2()
    }

    method confirmarJugada() {
        self.tableroActual().confirmarJugada(self.jugadorActual())
        if (self.tableroActual().cadaCeldaEstaCerrada()) {
            self.terminarParticipacion()
        }
        self.pasarTurno()
    }

    method cancelarJugada() {
        self.tableroActual().cancelarSeleccion()
        self.tableroActual().habilitarJugada()
    }

    method levantarRejas() {
        self.validarSiPuedenLevantarRejas()
        tableros.forEach({ tableroT => tableroT.levantarRejas() })
    }

    method validarSiPuedenLevantarRejas() {
        if (!self.estanTodosLosTablerosCerrados()) {
            self.error("todos los tableros no tienen sus celdas cerradas")
        }
    }

    method estanTodosLosTablerosCerrados() {
        return tableros.all({ tableroT => tableroT.cadaCeldaEstaCerrada() })
    }

    method comenzarPartidaReal() {
        game.removeVisual(menuPuntajeVisual)

        const posicionesDisponiblesTableros = [game.at(1,5), game.at(12,5), game.at(1,11), game.at(12,11)]
        const posicionesDisponibles = [game.at(1, 2), game.at(12, 2), game.at(1, 8), game.at(12, 8)]

        (1..cantidadJugadoresSeleccionada).forEach { i =>
            const pos = posicionesDisponibles.get(i - 1)
            const post = posicionesDisponiblesTableros.get(i - 1)
            const t = new Tablero(posicionInicial = post)
            const j = new Jugador(numero = i, position = pos, limitePuntaje = puntajeLimiteSeleccionado, tablero = t)

            jugadores.add(j)
            tableros.add(t)
            game.addVisual(j)   // Muestra el sprite del jugador
            t.mostrar()
            game.addVisual(new Puntaje(jugador = j)) // Muestra su puntaje abajo
        }

        estado = jugando
        dados.mostrar()
        game.addVisual(selector)
        game.addVisual(indicadorTurno)
        self.empezarRonda()
    }

    method tableroActual() = self.jugadorActual().tablero()

    method jugadorActual() = jugadores.get(indiceTurno)

    method estaEnJuego(jugador) = not jugador.estaEliminado() and not jugador.terminoRonda()

    method hayJugadoresEnJuego() = jugadores.any({ j => self.estaEnJuego(j) })

    method pasarTurno() {
        if (self.hayJugadoresEnJuego()) {
            indiceTurno = (indiceTurno + 1) % jugadores.size()
            self.saltearQuienNoJuega()
            self.reacomodarSelector()
        } else {
            self.terminarRonda()
        }
    }

    method saltearQuienNoJuega() {
        if (not self.estaEnJuego(self.jugadorActual())) {
            indiceTurno = (indiceTurno + 1) % jugadores.size()
            self.saltearQuienNoJuega()
        }
    }

    method reacomodarSelector() {
        selector.position(self.tableroActual().posicionSelector(selector.numeroSeleccionado()))
    }

    method pasarTurnoSinJugada2() {
        if (not self.tableroActual().hayJugadaPosible()) {
            self.terminarParticipacion()
            self.pasarTurno()
        }
    }

    method pasarTurnoSinJugada3() {
        self.validarNoHayJugadaPosible()
        self.terminarParticipacion()
        self.pasarTurno()
    }

    method validarNoHayJugadaPosible() {
        if (self.tableroActual().hayJugadaPosible()) {
            self.error("Todavia hay una jugada posible")
        }
    }

    method terminarParticipacion() {
        const jugador = self.jugadorActual()
        const tablero = self.tableroActual()
        tablero.sumarPuntos(jugador)
        if (tablero.cadaCeldaEstaCerrada()) {
            jugador.restar10()
        }
        tablero.deshabilitarJugada()
        dados.habilitarJugada()
        jugador.terminoRonda(true)
    }

    method jugadoresActivos() = jugadores.filter({ jugador => not jugador.estaEliminado() })

    method terminarRonda() {
        const restantes = self.jugadoresActivos()
        if (restantes.size() <= 1) {
            self.terminarPartida()
            }else {
            self.empezarRonda()
        }
    }

    method empezarRonda() {
        tableros.forEach({ tablero => tablero.reiniciarCelda() })
        jugadores.forEach({ jugador => jugador.terminoRonda(false) })
        participantesRonda = self.jugadoresActivos()
        indiceTurno = 0
        self.saltearQuienNoJuega()
        self.reacomodarSelector()
    }

    method terminarPartida() {
        estado = finPartida
    //creo que faltaria poner en pantalla quien gana pero nose como!!
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
    method siguienteEstado() = self
    method presionarArriba(juego1) {}
    method presionarAbajo(juego1) {}
    method presionarEspacio(juego1, selectorActual) {}
    method presionarG(juego1) {}
    method presionarP(juego1) {}
    method presionarC(juego1) {}
    method levantarRejas(juego1) {}
}