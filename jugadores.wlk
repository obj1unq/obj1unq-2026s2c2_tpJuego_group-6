import wollok.game.*

class Jugador {
  var puntaje = 0
  var property limitePuntaje = 50
  var property terminoRonda = false
  const property celdasElegidas = []
  var property position
  var property numero
  const tablero
  const marcador
  var property avatar   
  
  method sumarPuntos(puntos) {
    puntaje = puntaje + puntos
    marcador.mostrar(puntaje)
  }
  
  method restar10() {
    puntaje = (puntaje - 10).max(0)
    marcador.mostrar(puntaje)
  }

  method mostrarPuntaje() {
    marcador.mostrar(puntaje)
  }
  
  method estaEliminado() = puntaje >= limitePuntaje
  
  method image() = "amongus-" + avatar + ".png"
  
  method tablero() = tablero

  method indicarSuTurno() {
    return "Es tu turno jugador nro " + numero + ", toca G Para tirar los dados"
  }

  
}
