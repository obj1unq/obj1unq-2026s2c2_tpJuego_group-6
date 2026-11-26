import mainJuego.*
import wollok.game.*
import jugadores.*
import tablero.*
import elementos.*
import estados.*
import fondos.*
import config.*

object elPreso {
    var property estado = inicio // "INICIO", "SELECCION_JUGADORES", "SELECCION_AVARES", "SELECCION_PUNTAJE", "JUGANDO"

    const property jugadores = []
    const property tableros = []
    var indiceTurno = 0
    var participantesRonda = []

    const avataresDisponibels = [1,2,3,4,5,6,7,8]
    const property avataresElegidos = []
    var avatarCursor = 1
    var jugadorEligiendo = 1
    var indiceAvatar = 0

    var cantidadJugadoresSeleccionada = 2
    var puntajeLimiteSeleccionado = 50
    const puntajesDisponibles = [20,50, 100, 150]//sacar ese 20
    var indicePuntaje = 0
    const property marcadorMenu = new Marcador(x = 9, y = 7)
    const property marcadorGanador = new Marcador(x = 8, y = 3)

    method empezarJuego() {
      configuracion.configEscenario()
      configuracion.configControles()
      game.addVisual(pantallaInicioVisual)
      game.start()
    }

    method cantidadJugadoresSeleccionada() = cantidadJugadoresSeleccionada
    method puntajeLimiteSeleccionado() = puntajeLimiteSeleccionado

    method avatarEnSeleccion() = avataresDisponibels.get(indiceAvatar)
    method jugadorEligiendo() = jugadorEligiendo

    method avataresDisponibles() = avataresDisponibels.filter({avatar => not avataresElegidos.contains(avatar)})

    method iniciarSeleccionAvatar(){
        avataresElegidos.clear()
        jugadorEligiendo = 1
        indiceAvatar = 0
        avatarCursor = self.avataresDisponibles().first()
    }
    //no se me ocurre como hacer sin recursion
    method siguienteLibre(desde, avatar){
        const total = avataresDisponibels.size()
        const elegido = ((desde - 1 + avatar) % total) + 1
        return if(avataresElegidos.contains(elegido)){
            self.siguienteLibre(elegido, avatar)
        }else{
            elegido
        }
    }
    method iniciarSeleccion(){
        avataresElegidos.clear()
        jugadorEligiendo = 1
        indiceAvatar = 0
    }
    

    method moverAvatar(avatar){
        avatarCursor = self.siguienteLibre(avatarCursor, avatar)
        const total = avataresDisponibels.size()
        indiceAvatar = (indiceAvatar + avatar + total) % total

    }
    
    method confirmarAvatar(){
        avataresElegidos.add(self.avatarEnSeleccion())
        if(not self.todosEligieronAvatar()){
            jugadorEligiendo = jugadorEligiendo + 1
            marcadorMenu.mostrar(jugadorEligiendo)
        }
    }

    method todosEligieronAvatar()= avataresElegidos.size() == cantidadJugadoresSeleccionada

    // method presionarEnter() {
    //     estado.siguienteEstado(self)  //AVANZA A LOS SIGUIENTE ESTADOS DEL JUEGO
    // }

    method presionarEnter() { //AVANZA A LOS SIGUIENTE ESTADOS DEL JUEGO
      estado.presionarEnter(self)
    }

    method avanzarEstado() {
      estado.siguienteEstado(self)
    }

    method incrementarJugadores() {
        cantidadJugadoresSeleccionada = estado.cantidadDeJugadoresAJugar(cantidadJugadoresSeleccionada)
        marcadorMenu.mostrar(cantidadJugadoresSeleccionada)
    }

    method decrementarJugadores() {
        cantidadJugadoresSeleccionada = estado.cantidadJugadoresASacar(cantidadJugadoresSeleccionada)
        marcadorMenu.mostrar(cantidadJugadoresSeleccionada)
    }

    method moverAsiguientePuntaje() {
        indicePuntaje = estado.siguientePuntaje(indicePuntaje, puntajesDisponibles)
        puntajeLimiteSeleccionado = puntajesDisponibles.get(indicePuntaje)
        marcadorMenu.mostrar(puntajeLimiteSeleccionado)
    }

    method moverAnteriorPuntaje() {
        indicePuntaje = estado.anteriorPuntaje(indicePuntaje, puntajesDisponibles)
        puntajeLimiteSeleccionado = puntajesDisponibles.get(indicePuntaje)
        marcadorMenu.mostrar(puntajeLimiteSeleccionado)
    }

    method comenzarPartidaReal() {
        marcadorMenu.limpiar()

        const posicionesDisponiblesTableros = [game.at(1,3), game.at(1,5), game.at(1,7), game.at(1,9)]
        const posicionesDisponibles = [game.at(10, 3), game.at(10, 5), game.at(10, 7), game.at(10, 9)]

        (1..cantidadJugadoresSeleccionada).forEach { i =>
            const pos = posicionesDisponibles.get(i - 1)
            const post = posicionesDisponiblesTableros.get(i - 1)
            const t = new Tablero(posicionInicial = post)
            const m = new Marcador(x = pos.x(), y = pos.y() - 1)
            const j = new Jugador(numero = i, position = pos, limitePuntaje = puntajeLimiteSeleccionado, tablero = t ,marcador = m, avatar = avataresElegidos.get(i-1))

            jugadores.add(j)
            tableros.add(t)
            game.addVisual(j)   // Muestra el sprite del jugador
            t.mostrar()
            j.mostrarPuntaje() // Muestra su puntaje abajo
        }
        estado = jugando
        dados.mostrar()
        game.addVisual(selectorCeldas)
        game.addVisual(indicadorTurno)
        self.empezarRonda(jugadores)
    }

    method tableroActual() = self.jugadorActual().tablero()

    method jugadorActual() = jugadores.get(indiceTurno)

    method estaEnJuego(jugador) = participantesRonda.contains(jugador) and not jugador.terminoRonda()

    method hayJugadoresEnJuego() = jugadores.any({ j => self.estaEnJuego(j) })

    method pasarTurno() {
        if (self.hayJugadoresEnJuego()) {
            indiceTurno = (indiceTurno + 1) % jugadores.size()
            self.saltearQuienNoJuega()
            self.reacomodarSelector()
            game.say(self.jugadorActual(), self.jugadorActual().indicarSuTurno()) //INDICA EN PANTALLA CUANDO ES EL TURNO DEL JUGADOR ACTUAL
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
        selectorCeldas.position(self.tableroActual().posicionSelector(selectorCeldas.numeroSeleccionado()))
    }

    method pasarTurnoSinJugada() {
        self.validarNoHayJugadaPosible()
        self.terminarParticipacion()
        self.pasarTurno()
        //dados.tirar() //dejarlo o no a criterio
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
        dados.habilitarJugadaDado()
        jugador.terminoRonda(true) //CAMBIAR ESE TRUE
    }

    method jugadoresActivos() = jugadores.filter({ jugador => not jugador.estaEliminado() })

    method terminarRonda() {
        const restantes = self.jugadoresActivos()
        if (restantes.size() == 1) {
            self.terminarPartida()
            }else if(restantes.isEmpty()){
                self.empezarOvertime()
            }else {
            self.empezarRonda(restantes)
        }
    }

    method empezarOvertime(){
        participantesRonda.forEach({jugador=> jugador.reiniciarPuntaje()})
        self.empezarRonda(participantesRonda)
    }

    method empezarRonda(participantes) {
        participantesRonda = participantes
        tableros.forEach({ tablero => tablero.reiniciarCelda() })
        jugadores.forEach({ jugador => jugador.terminoRonda(false) }) //CAMBIAR ESE FALSE
        indiceTurno = 0
        self.saltearQuienNoJuega()
        self.reacomodarSelector()
    }

    method terminarPartida() {
        ganadorVisual.ganador(self.mostrarGanador()) 
        finPartida.siguienteEstado(self)
    }

    method mostrarGanador() {
      return if (self.jugadoresActivos().isEmpty()) {
        jugadores.min({j => j.puntaje()})
      } else {
        self.jugadoresActivos().first()
      }
    }

    method moverDerecha(selector) {
        //selector.moverDerecha()
        estado.presionarDerecha(self, selector)
    }

    method moverIzquierda(selector) {
        //selector.moverIzquierda()
        estado.presionarIzquierda(self, selector)
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

    method presionarDelete() {
        estado.presionarDelete(self)
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
        self.pasarTurnoSinJugada()
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
}