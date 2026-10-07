object derecha {
    method siguiente(posicion) {
        self.validarSiguiente(posicion)
        return posicion.right(1)
    }
    method validarSiguiente(posicion) {
        if(posicion.x() == game.width() - 1 ) {
            self.error('No se puede mover a la derecha')
        }
    }
}