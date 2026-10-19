import wollok.game.*

class Jugador {
    var puntaje = 0
    var property limitePuntaje = 50 
    //var turnos
    const property celdasElegidas = []
    var property position  
    var property numero  
    const totalTablero = 45

    method sumarPuntos(puntos){
        if(puntaje < limitePuntaje){
            puntaje += puntos
        }
        else {
            game.say(self, "Gg nt")               //INNECESARIO DEL MOMENTO
            game.schedule(5000, { game.stop() })  //
        }                                         //   
    }

    method restar10(){
        puntaje = (puntaje - 10).max(0)
    }

    method puntaje()= totalTablero - puntaje        //Cambiar esto, hacer recorrido por celdas abiertas para saber cual fue el puntaje final de esa ronda

    method image() = "jugador-" + numero + ".png"
}

class Puntaje{
    var property jugador
    method position() = jugador.position().down(1)


    method text() = "Pts: " + jugador.puntaje().toString()
}
