local ataque = {}


function ataque.crear()

    local a = {}


    a.imagen =
        love.graphics.newImage(
            "img/2.png"
        )


    a.anchoFrame = 72

    a.altoFrame = 72

    a.cantidadFrames = 8


    a.frame = 1

    a.tiempo = 0

    a.velocidad = 0.06

    a.activo = false


    a.direccion = 1

    a.x = 0

    a.y = 0


    return a

end

function ataque.iniciar(a, jugador)

    a.activo = true

    a.frame = 1

    a.tiempo = 0

    a.direccion =
        jugador.direccion


    if jugador.direccion == 1 then

        a.x =
            jugador.x +
            jugador.ancho

    else

        a.x =
            jugador.x -
            130

    end


    a.y = jugador.y

end

function ataque.actualizar(a, dt)

    if not a.activo then
        return
    end


    a.tiempo =
        a.tiempo + dt


    if a.tiempo >= a.velocidad then

        a.tiempo = 0

        a.frame =
            a.frame + 1


        if a.frame > a.cantidadFrames then

            a.frame = 1

            a.activo = false

        end

    end

end


function ataque.dibujar(a)

    if not a.activo then
        return
    end


    local quad =
        love.graphics.newQuad(

            (a.frame - 1) *
            a.anchoFrame,

            0,

            a.anchoFrame,

            a.altoFrame,

            a.imagen:getWidth(),

            a.imagen:getHeight()

        )


    local escalaX =
        130 / 72

    local escalaY =
        105 / 72


    if a.direccion == -1 then

        love.graphics.draw(

            a.imagen,

            quad,

            a.x + 130,

            a.y,

            0,

            -escalaX,

            escalaY

        )

    else

        love.graphics.draw(

            a.imagen,

            quad,

            a.x,

            a.y,

            0,

            escalaX,

            escalaY

        )

    end

end


return ataque