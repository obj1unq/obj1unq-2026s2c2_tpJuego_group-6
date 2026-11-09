import wollok.game.*
import elementos.*
import jugadores.*

class Celda {
    var property position
    var property numero
    var property estado = celdaAbierta
    const reja = new Reja(position = position)

    method image() = "numero-" + numero + ".png"

    method mostrar() {
        game.addVisual(new BordeCelda(position = position))
        game.addVisual(self)
    }

    method alternarEstado() {
        estado = estado.alternarEstado()
        estado.mostrar(reja)
    }

    method LevantarReja() {
      self.alternarEstado()
    }

    method esCeldaCerrada() = estado.tieneReja()
}

class BordeCelda {
    var property position

    method image() = "borde-negro.png"
}

class Reja {
    var property position 

    method image() = "reja-cerrada.png"
}

class Tablero {
    var puedeElegir = false
    const posicionInicial  //game.origin().right(1).up(6)
    const celdasElegidas = []

    const celdas = (1..9).map { numero =>
        new Celda(
            position = posicionInicial.right(numero - 1),
            numero = numero
        )
    }
    
    method jugador() {
      return Jugador
    }

    method dados() {
      return dados
    }

    method posicionSelector(numeroS) {
      return celdas.get(numeroS - 1).position()
    }

    method hayUnaCeldaPosible() {
      //entre las celdas abiertas, chequea si hay al menos una que cumpla con el puntaje de los dados actual
      return celdas.any({celda => not celda.esCeldaCerrada() and celda.numero() == dados.puntaje()})
    }

    method hayDosCeldasPosible() {
      //busca las dos celdas posibles que de la suma de esas dos celdas, de el puntaje de los dados actual
      return self.celdasAbiertas().any({celda1 => self.celdasAbiertas().any({celda2 => celda1 != celda2 and 
                                        celda1.numero() + celda2.numero() == dados.puntaje()})})
    }

    method celdasAbiertas() {
      return celdas.filter({celda => not celda.esCeldaCerrada()})
    }

    method deshabilitarJugada() {
      puedeElegir = false
    }

    method hayJugadaPosible() {
      return self.hayUnaCeldaPosible() or self.hayDosCeldasPosible()
    }

    method habilitarJugada() {
        //self.cancelarSeleccion() //porque este cancelarSeleccion esta aca?
        puedeElegir = true
    }

    // method elegir(numero, puntaje){
    //     if (puedeElegir) {
    //         const celda = celdas.get(numero - 1)
    //         if(not celda.esCeldaCerrada() and celdasElegidas.size() < 2){
    //             celda.alternarEstado()
    //             celdasElegidas.add(celda)
    //             self.evaluarElegidas2(puntaje)

    //             game.removeVisual(selector)         //CAMBIAR
    //             game.addVisual(selector)            //CAMBIAR
    //         }
    //     }
    // }

    method elegir2(numeroC, puntaje){
        const celda = celdas.get(numeroC - 1)
        self.validarPuedeElegir(celda)
        celda.alternarEstado()
        self.agregarCeldaElegida(celda)
        self.evaluarElegidas2(puntaje)
        self.mostrarVisualSelector(selector) //CAMBIAR
    }

    method mostrarVisualSelector(selector) {
        game.removeVisual(selector)         
        game.addVisual(selector)            
    }

    method validarPuedeElegir(celda) {
        if(not puedeElegir or celda.esCeldaCerrada() or celdasElegidas.size() >= 2){
            self.error("no puede elegir la celda")
        }
    }

    method agregarCeldaElegida(celda) {
      celdasElegidas.add(celda)
    }


    // method evaluarElegidas(puntaje){
    //     const suma = self.sumaElegidas()
    //     if(suma > puntaje or (celdasElegidas.size() == 2 and suma != puntaje)){
    //         celdasElegidas.forEach({celda => celda.alternarEstado()})
    //         celdasElegidas.clear()
    //         puedeElegir = false
    //     }                
    // }

    method evaluarElegidas2(puntaje){
        self.mostrarVisualSelector(selector) //CAMBIAR
        self.validarEvaluarElegidas(self.sumaElegidas(),puntaje) //revisar porque con la validacion tapa el borde rojo de la celda
        celdasElegidas.forEach({celda => celda.alternarEstado()})
        celdasElegidas.clear()
        puedeElegir = false              
    }


    method validarEvaluarElegidas(suma,puntaje) {
        if(suma <= puntaje or (celdasElegidas.size() == 2 and suma != puntaje)){
            self.error("no se puede elegir")
        }
    }

    method validarPuedeConfirmar() {
       if (self.sumaElegidas() != dados.puntaje()) {
           self.error("La suma de las celdas elegidas no coincide con el puntaje obtenido")
       }
    }

    method confirmarJugada(jugador) {
        self.validarPuedeConfirmar()
        //self.sumarPuntos(jugador)
        celdasElegidas.clear()
        puedeElegir = false
        dados.habilitarJugada()
    }

    method sumarPuntos(jugador){
    /*const puntajeRestante = self.celdasRestantes()
        if(celdasElegidas.isEmpty()){
            jugador.sumarPuntos(puntajeRestante)
        } else {
            jugador.sumarPuntos(celdasElegidas.sum({celda=> celda.numero()}))
        }*/
    jugador.sumarPuntos(self.celdasRestantes()) 
    }  

    method sumaElegidas(){
        return celdasElegidas.sum({celda => celda.numero()})
    }

    method puedeCerrar(puntaje){
        const celdasAbiertas = celdas.filter({celda=> not celda.cerrada()}).map({celda=> celda.numero()})
        return celdasAbiertas.any({celda=> celda == puntaje or 
                                  celdasAbiertas.any({abierta => celda != abierta and celda + abierta == puntaje})})
    }

    method celdasRestantes(){
        return celdas.filter({celda=> not celda.esCeldaCerrada()}).sum({celda=>celda.numero()})
    }

    method mostrar() {
        celdas.forEach { celda => celda.mostrar()}
    }

    method alternarCelda(numero) {
        celdas.get(numero - 1).alternarEstado()
    }

    method levantarRejas() {
      self.validarSiLasCledasEstanCerradas()
      celdas.forEach({celda => celda.LevantarReja()})
    }

    method validarSiLasCledasEstanCerradas() {
        if(!self.cadaCeldaEstaCerrada()){
            self.error("no estan cerradas todas las celdas")
        } 
    }

    method cadaCeldaEstaCerrada() {
        return celdas.all({celda => celda.esCeldaCerrada()}) 
    }

    method cancelarSeleccion() {
        celdasElegidas.forEach({ celda => celda.alternarEstado() })
        celdasElegidas.clear()
    }

    method puedeSeguirTurno(puntaje) {
        return self.puedeCerrar(puntaje)
    }

    ///*   method terminarTurno(jugador) {
    //    jugador.sumarPuntos(self.celdasRestantes())
    //    if (self.cadaCeldaEstaCerrada()) {
    //        jugador.restar10()
    //}
    //self.reiniciarCelda()
    //}*/
    method reiniciarCelda(){
        celdas.filter({celda=> celda.esCeldaCerrada()}).forEach({celda=> celda.alternarEstado()})
    }
}