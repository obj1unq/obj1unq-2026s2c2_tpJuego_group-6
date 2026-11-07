import wollok.game.*
import jugadores.*
import tablero.*
import elementos.*

object juego {
    //var estado = "INICIO" // "INICIO", "SELECCION_JUGADORES", "SELECCION_PUNTAJE", "JUGANDO"
    var estado2 = inicio
    
    const property jugadores = []
    var indiceTurno = 0
    
    var cantidadJugadoresSeleccionada = 2
    var puntajeLimiteSeleccionado = 50
    const puntajesDisponibles = [50, 100, 150]
    var indicePuntaje = 0
    var juegoIniciado = false

    method estado() = estado2
    method cantidadJugadoresSeleccionada() = cantidadJugadoresSeleccionada
    method puntajeLimiteSeleccionado() = puntajeLimiteSeleccionado

    // method avanzarEstado() {
    //     if (estado == "INICIO") {
    //         estado = "SELECCION_JUGADORES"
    //         game.removeVisual(pantallaInicioVisual)
    //         game.addVisual(menuJugadoresVisual)
    //     } else if (estado == "SELECCION_JUGADORES") {
    //         estado = "SELECCION_PUNTAJE"
    //         game.removeVisual(menuJugadoresVisual)
    //         game.addVisual(menuPuntajeVisual)
    //     } else if (estado == "SELECCION_PUNTAJE") {
    //         self.comenzarPartidaReal()
    //     }
    // }

    method pasarMenu(){ //corregir?¿
        if (!juegoIniciado){
            juegoIniciado = true
            self.avanzarEstado2() 
        } else {
            self.avanzarEstado2()
        }
    }

    method avanzarEstado2() {
        estado2 = estado2.siguienteEstado()
    }

    // method incrementarJugadores() {
    //     if (estado == "SELECCION_JUGADORES" and cantidadJugadoresSeleccionada < 4) {
    //         cantidadJugadoresSeleccionada = cantidadJugadoresSeleccionada + 1
    //     }
    // }

    method incrementarJugadores2() {
        cantidadJugadoresSeleccionada = estado2.incrementarJugadores(cantidadJugadoresSeleccionada)
    }

    // method decrementarJugadores() {
    //     if (estado == "SELECCION_JUGADORES" and cantidadJugadoresSeleccionada > 2) {
    //         cantidadJugadoresSeleccionada = cantidadJugadoresSeleccionada - 1
    //     }
    // }

    method decrementarJugadores2() {
        cantidadJugadoresSeleccionada = estado2.decrementarJugadores(cantidadJugadoresSeleccionada)
    }

    // method siguientePuntaje() {
    //     if (estado == "SELECCION_PUNTAJE") {
    //         indicePuntaje = (indicePuntaje + 1) % puntajesDisponibles.size()
    //         puntajeLimiteSeleccionado = puntajesDisponibles.get(indicePuntaje)
    //     }
    // }

    method siguientePuntaje2() {
        indicePuntaje = estado2.siguientePuntaje(indicePuntaje,puntajesDisponibles)
        puntajeLimiteSeleccionado = puntajesDisponibles.get(indicePuntaje)
    }

    // method anteriorPuntaje() {
    //     if (estado == "SELECCION_PUNTAJE") {
    //         indicePuntaje = (indicePuntaje - 1 + puntajesDisponibles.size()) % puntajesDisponibles.size()
    //         puntajeLimiteSeleccionado = puntajesDisponibles.get(indicePuntaje)
    //     }
    // }

    method anteriorPuntaje2() {
        indicePuntaje = estado2.anteriorPuntaje(indicePuntaje,puntajesDisponibles)
        puntajeLimiteSeleccionado = puntajesDisponibles.get(indicePuntaje)
    }

    method moverDerecha(selector) {
        selector.moverDerecha()
    }

    method moverIzquierda(selector) {
        selector.moverIzquierda()
    }

    method presionarArriba() {
        estado2.presionarArriba(self)
    }

    method presionarAbajo() {
        estado2.presionarAbajo(self)
    }

    method presionarEspacio(selectorActual) {
        estado2.presionarEspacio(self, selectorActual)
    }

    method elegirCelda(selectorActual) {
        tablero.elegir(selectorActual.numeroSeleccionado(), dados.puntaje())
    }

    method presionarG() {
        estado2.presionarG(self)
    }

    method tirarDados() {
        dados.tirar()
        tablero.habilitarJugada()
        self.pasarTurnoSinJugada2()
    }

    method presionarP() {
        estado2.presionarP(self)
    }

    method confirmarJugada() {
        tablero.confirmarJugada(self.jugadorActual())
        self.pasarTurno()
    }

    method presionarC() {
        estado2.presionarC(self)
    }

    method cancelarJugada() {
        tablero.cancelarSeleccion()
        tablero.habilitarJugada()
    }

    method alterarRejasCeldas() {
        estado2.levantarRejas(self)
    }

    method levantarRejas() {
        tablero.levantasRejas()
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
        
        estado2 = jugando
        tablero.mostrar()
        dados.mostrar()
        game.addVisual(selector)
        game.addVisual(indicadorTurno)
    }

    method jugadorActual() = jugadores.get(indiceTurno)

    method pasarTurno() {
        indiceTurno = (indiceTurno + 1) % jugadores.size()
    }

    method pasarTurnoSinJugada2() { //COMPARAR SI HACE LO MISMO VISUALMENTE CON EL JUGADA3 LINEA 97
      if(not tablero.hayJugadaPosible()){
        tablero.sumarPuntos(self.jugadorActual())
        tablero.deshabilitarJugada()
        dados.habilitarJugada()
        self.pasarTurno()
      }
    }

    //jugada3
    method pasarTurnoSinJugada3() { 
        self.validarNoHayJugadaPosible()
        tablero.sumarPuntos(self.jugadorActual())
        tablero.deshabilitarJugada()
        dados.habilitarJugada()
        self.pasarTurno()
    }

    method validarNoHayJugadaPosible() {
      if (tablero.hayJugadaPosible()) {
        self.error("Todavia hay una jugada posible")
      }
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
        juego1.incrementarJugadores2()
    }

    method presionarAbajo(juego1) {
        juego1.decrementarJugadores2()
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
        juego1.siguientePuntaje2()
    }

    method presionarAbajo(juego1) {
        juego1.siguientePuntaje2()
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
}