import estados.*
import wollok.game.*
import configuracion.*

class Jugador {
  var puntaje = 0
  var property limitePuntaje = 50
  var property terminoRonda = false
  const property celdasElegidas = []
  var property position
  var property numero
  const tablero
  const marcador 
  
  method sumarPuntos(puntos) {
    puntaje = puntaje + puntos
    marcador.mostrar(puntaje)
  }
  
  method restar10() {
    puntaje = (puntaje - 10).max(0)
    marcador.mostrar(puntaje)
  }
  
  //method puntaje() = puntaje //marcador.mostrar(puntaje)

  method mostrarPuntaje() {
    marcador.mostrar(puntaje)
  }
  
  method estaEliminado() = puntaje >= limitePuntaje
  
  method image() = ("jugador-" + numero) + ".png"
  
  method tablero() = tablero

  method indicarSuTurno() {
    return "Es tu turno jugador nro " + numero + ", toca G Para tirar los dados"
  }

  
}

// class Puntaje {
//   var property jugador
  
//   method position() = jugador.position().down(1)
  
//   method text() = "Pts: " + jugador.puntaje().toString()
// }