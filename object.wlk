import juego.*

object celdaCerrada {
    method alternarEstado() {
      return celdaAbierta
    }

    method tieneReja() {
      return true
    }

    method mostrar(reja) {
      if(self.tieneReja()){
        game.addVisual(reja)
      }
    }
}

object celdaAbierta {
    method alternarEstado() {
      return celdaCerrada
    }

    method tieneReja() {
      return false
    }

    method mostrar(reja) {
      if(not self.tieneReja()){
        game.removeVisual(reja)
      }
    }
}