import wollok.game.*

class Jugador {
    var puntaje = 0
    //var turnos
    const property celdasElegidas = []
    var property position = game.at(0,10)  
    const celdas = #{}
    const totalTablero = 45

    method sumarPuntos(puntos){
        if(puntaje < 50){
            puntaje = puntaje + puntos
        }
        else {
            game.say(self, "Gg nt")               //INNECESARIO DEL MOMENTO
            game.schedule(5000, { game.stop() })  //
        }                                         //   
    }

    method restar10(){
        puntaje = (puntaje - 10).max(0)
    }

    method puntaje()= totalTablero - puntaje

    method image() {
        return "jugador-1.png"
    }
}

class Puntaje{
    var property position = game.at(0,9)
    var property jugador
    method text(){
        return jugador.puntaje().toString()
    }
}
