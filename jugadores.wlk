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

  method puntaje() = puntaje

  method reiniciarPuntaje(){
    puntaje = 0
    self.mostrarPuntaje()
  }
  
  method sumarPuntos(puntos) {
    puntaje = puntaje + puntos
    self.mostrarPuntaje()
  }
  
  method restar10() {
    puntaje = (puntaje - 10).max(0)
    self.mostrarPuntaje()
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
