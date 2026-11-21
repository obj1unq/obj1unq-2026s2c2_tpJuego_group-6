import wollok.game.*
import elementos.*
import jugadores.*
import estados.*

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
    var estadoEleccion = noElegido //elegido o noElegido, indica si se puede elegir algunas de las celdas. CAMBIAR SI ES NECESARIO
    const posicionInicial
    const celdasElegidas = []

    method estadoEleccion(_estadoEleccion) {
      estadoEleccion = _estadoEleccion
    }

    const celdas = (1..9).map { numero =>
        new Celda(
            position = posicionInicial.right(numero - 1),
            numero = numero
        )
    }
    
    method jugador() = Jugador //CAMBIAR, ES una referencia global

    method dados() = dados //CAMBIAR, ES una referencia global

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

    method celdasAbiertas() = celdas.filter({celda => not celda.esCeldaCerrada()})

    method deshabilitarJugada() {
      estadoEleccion = noElegido
    }

    method hayJugadaPosible() {
      return self.hayUnaCeldaPosible() or self.hayDosCeldasPosible()
    }

    method habilitarJugada() {
        estadoEleccion = elegido
    }

    method elegir(numeroC, puntaje){
        const celda = celdas.get(numeroC - 1)
        self.validarPuedeElegir(celda)
        celda.alternarEstado()
        self.agregarCeldaElegida(celda)
        self.evaluarElegidas(puntaje)
        self.mostrarVisualSelector(selector) //CAMBIAR
    }

    method mostrarVisualSelector(selector) {
        game.removeVisual(selector)         
        game.addVisual(selector)            
    }

    method validarPuedeElegir(celda) {
        if(not estadoEleccion.puedeElegir() or celda.esCeldaCerrada() or celdasElegidas.size() >= 2){
            self.error("no puede elegir la celda")
        }
    }

    method agregarCeldaElegida(celda) {
      celdasElegidas.add(celda)
    }

    method evaluarElegidas(puntaje){
        self.mostrarVisualSelector(selector) //CAMBIAR
        self.validarEvaluarElegidas(self.sumaElegidas(),puntaje) //revisar porque con la validacion tapa el borde rojo de la celda al sacar el mostrarVisualSelector
        celdasElegidas.forEach({celda => celda.alternarEstado()})
        celdasElegidas.clear()
        estadoEleccion.avanzarEstado(self)              
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
        celdasElegidas.clear()
        estadoEleccion.avanzarEstado(self)
        dados.habilitarJugadaDado()
    }

    method sumarPuntos(jugador){
        jugador.sumarPuntos(self.celdasRestantes()) 
    }  

    method sumaElegidas(){
        return celdasElegidas.sum({celda => celda.numero()})
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

    method reiniciarCelda(){
        celdas.filter({celda=> celda.esCeldaCerrada()}).forEach({celda=> celda.alternarEstado()})
    }
}