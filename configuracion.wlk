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
    
    var cantidadJugadoresSeleccionada = 2
    var puntajeLimiteSeleccionado = 50
    const puntajesDisponibles = [50, 100, 150]
    var indicePuntaje = 0
    var juegoIniciado = false

    method estado() = estado
    method cantidadJugadoresSeleccionada() = cantidadJugadoresSeleccionada
    method puntajeLimiteSeleccionado() = puntajeLimiteSeleccionado

    method pasarMenu(){ //corregir?¿
        if (!juegoIniciado){
            juegoIniciado = true
            self.avanzarEstado2() 
        } else {
            self.avanzarEstado2()
        }
    }

    method avanzarEstado2() {
        estado = estado.siguienteEstado()
    }

    method incrementarJugadores2() {
        cantidadJugadoresSeleccionada = estado.incrementarJugadores(cantidadJugadoresSeleccionada)
    }

    method decrementarJugadores2() {
        cantidadJugadoresSeleccionada = estado.decrementarJugadores(cantidadJugadoresSeleccionada)
    }

    method siguientePuntaje2() {
        indicePuntaje = estado.siguientePuntaje(indicePuntaje,puntajesDisponibles)
        puntajeLimiteSeleccionado = puntajesDisponibles.get(indicePuntaje)
    }

    method anteriorPuntaje2() {
        indicePuntaje = estado.anteriorPuntaje(indicePuntaje,puntajesDisponibles)
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

    method elegirCelda(selectorActual) {
        self.tableroActual().elegir2(selectorActual.numeroSeleccionado(), dados.puntaje())
    }

    method presionarG() {
        estado.presionarG(self)
    }

    method tirarDados() {
        dados.tirar()
        self.tableroActual().habilitarJugada()
        self.pasarTurnoSinJugada2()
    }

    method presionarP() {
        estado.presionarP(self)
    }

    method confirmarJugada() {
        self.tableroActual().confirmarJugada(self.jugadorActual())
        self.pasarTurno()
    }

    method presionarC() {
        estado.presionarC(self)
    }

    method cancelarJugada() {
        self.tableroActual().cancelarSeleccion()
        self.tableroActual().habilitarJugada()
    }

    method alterarRejasCeldas() {
        estado.levantarRejas(self)
    }

    method levantarRejas() {
        self.validarSiPuedenLevantarRejas()
        tableros.forEach({tableroT => tableroT.levantarRejas()})
    }

    method validarSiPuedenLevantarRejas() {
        const estanCerradas = tableros.all({tableroT => tableroT.cadaCeldaEstaCerrada()})
        if(!estanCerradas){
            self.error("todos los tableros no tienen sus celdas cerradas")
        }
    }

    method comenzarPartidaReal() {
        game.removeVisual(menuPuntajeVisual)

        const posicionesDisponiblesTableros = [game.at(1,6), game.at(12,6), game.at(1,12), game.at(12,12)]
        const posicionesDisponibles = [game.at(1, 2), game.at(12, 2), game.at(1, 9), game.at(12, 9)]
    
        (1..cantidadJugadoresSeleccionada).forEach { i =>
            const pos = posicionesDisponibles.get(i - 1)
            const post = posicionesDisponiblesTableros.get(i - 1)
            const t = new Tablero(posicionInicial = post)
            const j = new Jugador(numero = i, position = pos, limitePuntaje = puntajeLimiteSeleccionado, tablero = t)
        
            jugadores.add(j)
            tableros.add(t)
            game.addVisual(j) // Muestra el sprite del jugador
            t.mostrar()
            game.addVisual(new Puntaje(jugador = j)) // Muestra su puntaje abajo
        }
        
        estado = jugando
        //tablero.mostrar()
        dados.mostrar()
        game.addVisual(selector)
        game.addVisual(indicadorTurno)
    }

    method tableroActual() = self.jugadorActual().tablero()

    method jugadorActual() = jugadores.get(indiceTurno)

    method pasarTurno() {
        indiceTurno = (indiceTurno + 1) % jugadores.size()
        self.reacomoDarSelector()
    }

    method reacomoDarSelector() {
      selector.position(self.tableroActual().posicionSelector(selector.numeroSeleccionado()))//CORREGIR
    }

    method pasarTurnoSinJugada2() { //COMPARAR SI HACE LO MISMO VISUALMENTE CON JUGADA3 LINEA 97
      if(not self.tableroActual().hayJugadaPosible()){
        self.tableroActual().sumarPuntos(self.jugadorActual())
        self.tableroActual().deshabilitarJugada()
        dados.habilitarJugada()
        self.pasarTurno()
      }
    }

    //jugada3
    method pasarTurnoSinJugada3() { 
        self.validarNoHayJugadaPosible()
        self.tableroActual().sumarPuntos(self.jugadorActual())
        self.tableroActual().deshabilitarJugada()
        dados.habilitarJugada()
        self.pasarTurno()
    }

    method validarNoHayJugadaPosible() {
      if (self.tableroActual().hayJugadaPosible()) {
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

    method presionarArriba(juego1) {
        //no hace nada
    }

    method presionarAbajo(juego1) {
        //no hace nada
    }
}