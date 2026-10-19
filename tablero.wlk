import wollok.game.*
import elementos.*
import jugadores.*

class Celda {
    var property position
    var property numero
    var property cerrada = false
    const reja = new Reja(position = position)

    method image() = "numero-" + numero + ".png"

    method mostrar() {
        game.addVisual(new BordeCelda(position = position))
        game.addVisual(self)
    }

    method alternarEstado() {
        if (cerrada) {
            cerrada = false
            game.removeVisual(reja)
        } else {
            cerrada = true
            game.addVisual(reja)
        }
    }

    method LevantarReja() {
      self.alternarEstado()
    }

    method esCeldaCerra() = cerrada
}

class BordeCelda {
    var property position

    method image() = "borde-negro.png"
}

class Reja {
    var property position 

    method image() = "reja-cerrada.png"
}

object tablero {
    var puedeElegir = false
    const posicionInicial = game.origin().right(1).up(6)
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

    method habilitarJugada() {
        self.cancelarSeleccion()
        puedeElegir = true
    }

    method elegir(numero, puntaje){
        if (puedeElegir) {
            const celda = celdas.get(numero - 1)
            if(not celda.cerrada() and celdasElegidas.size() < 2){
                celda.alternarEstado()
                celdasElegidas.add(celda)
                self.evaluarElegidas(puntaje)

                game.removeVisual(selector)         //CAMBIAR
                game.addVisual(selector)            //CAMBIAR
            }
        }
    }

    method evaluarElegidas(puntaje){
        const suma = self.sumaElegidas()
        if(suma > puntaje or (celdasElegidas.size() == 2 and suma != puntaje)){
            celdasElegidas.forEach({celda => celda.alternarEstado()})
            celdasElegidas.clear()
            puedeElegir = false
        } else if (celdasElegidas.size() == 2 and suma < puntaje){
            console.println("asdasd")
        }                  
    }


    method validarEvaluarElegidas(suma,puntaje) {
        if(suma <= puntaje or (celdasElegidas.size() == 2 and suma != puntaje)){
            self.error("no se puede elegir")
        }
    }

    // method confirmarJugada(jugador) {
    //    self.validarPuedeConfirmar()
    //    jugador.sumarPuntos(celdasElegidas.sum({celda=> celda.numero()}))
    //    celdasElegidas.clear()
    //    puedeElegir = false
    //    dados.habilitarJugada()
    // }

    method validarPuedeConfirmar() {
       if (self.sumaElegidas() != dados.puntaje()) {
           self.error("La suma de las celdas elegidas no coincide con el puntaje obtenido")
       }
    }

    method confirmarJugada(jugador) {
        self.validarPuedeConfirmar()
        self.sumarPuntos(jugador)
        celdasElegidas.clear()
        puedeElegir = false
        dados.habilitarJugada()
    }

    method sumarPuntos(jugador){
    const puntajeRestante = self.celdasRestantes()
        if(celdasElegidas.isEmpty()){
            jugador.sumarPuntos(puntajeRestante)
        } else {
            jugador.sumarPuntos(celdasElegidas.sum({celda=> celda.numero()}))
        } 
    }  

    method sumaElegidas(){
        var suma = 0
        celdasElegidas.forEach({celda => suma = suma + celda.numero()})
        return suma
    }

    method puedeCerrar(puntaje){
        const celdasAbiertas = celdas.filter({celda=> not celda.cerrada()}).map({celda=> celda.numero()})
        return celdasAbiertas.any({celda=> celda == puntaje or 
                                  celdasAbiertas.any({abierta => celda != abierta and celda + abierta == puntaje})})
    }

    method celdasRestantes(){
        return celdas.filter({celda=> not celda.cerrada()}).sum({celda=>celda.numero()})
    }

    method mostrar() {
        celdas.forEach { celda => celda.mostrar()}
    }

    method alternarCelda(numero) {
        celdas.get(numero - 1).alternarEstado()
    }

    method levantasRejas() {
    //   self.validarSiLasCledasEstanCerradas()
      celdas.forEach({celda => celda.LevantarReja()})
    }

    method validarSiLasCledasEstanCerradas() {
        if(!self.cadaCeldaEstaCerrada()){
            self.error("no estan cerradas todas las celdas")
        } 
    }

    method cadaCeldaEstaCerrada() {
        return celdas.all({celda => celda.cerrada()}) 
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
        celdas.forEach({celda=> if (celda.cerrada()){celda.alternarEstado()}})
    }
}