//import juego.*
import wollok.game.*
import jugadores.*
import tablero.*
import elementos.*

object juego {
    var estado = inicio // "INICIO", "SELECCION_JUGADORES", "SELECCION_PUNTAJE", "JUGANDO"

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
        self.tableroActual().elegir(selectorActual.numeroSeleccionado(), dados.puntaje())
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

        const posicionesDisponiblesTableros = [game.at(1,3), game.at(1,5), game.at(1,7), game.at(1,9)]
        const posicionesDisponibles = [game.at(10, 3), game.at(10, 5), game.at(10, 7), game.at(10, 9)]

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
            //dados.tirar() //dejarlo o no a criterio
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
        //game.addVisual(finPartida) PROBAR
    //creo que faltaria poner en pantalla quien gana pero nose como!!
    }
}