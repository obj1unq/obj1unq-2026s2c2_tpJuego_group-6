import wollok.game.*

class Jugador {
  var puntaje = 0
  var property limitePuntaje = 50
  //var turnos
  var property terminoRonda = false
  const property celdasElegidas = []
  var property position
  var property numero
  const tablero
  
  method sumarPuntos(puntos) {
    puntaje = puntaje + puntos
  }
  
  method restar10() {
    puntaje = (puntaje - 10).max(0)
  }
  
  method puntaje() = puntaje
  
  method estaEliminado() = puntaje >= limitePuntaje
  
  method image() = ("jugador-" + numero) + ".png"
  
  method tablero() = tablero
}

class Puntaje {
  var property jugador
  
  method position() = jugador.position().down(1)
  
  method text() = "Pts: " + jugador.puntaje().toString()
}