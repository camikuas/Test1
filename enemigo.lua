local animacion = require("animacion")

local enemigo = {}


function enemigo.crear(x)

    local e = {}

    e.ancho = 130
    e.alto = 105


    e.x = x

    e.y = 288 - e.alto


    e.vida = 10

    e.vidaMaxima = 10

    e.danio = 1


    e.velocidad = 60

    e.direccion = 1

    e.estado = "walk"

    e.atacando = false

    e.tiempoAtaque = 0

    e.duracionAtaque = 0.5

    e.tiempoEntreAtaques = 0

    e.cooldownAtaque = 1

    e.muerto = false

    e.idle = animacion.crear({

        "img/Enemigo Idle/1 IDLE_000.png",
        "img/Enemigo Idle/1 IDLE_001.png",
        "img/Enemigo Idle/1 IDLE_002.png",
        "img/Enemigo Idle/1 IDLE_003.png",
        "img/Enemigo Idle/1 IDLE_004.png"

    }, 0.1)


    e.walk = animacion.crear({

        "img/Enemigo walk/2 WALK_000.png",
        "img/Enemigo walk/2 WALK_001.png",
        "img/Enemigo walk/2 WALK_002.png",
        "img/Enemigo walk/2 WALK_003.png",
        "img/Enemigo walk/2 WALK_004.png"

    }, 0.1)


    e.attack = animacion.crear({

        "img/Enemigo attack/5 ATTACK_000.png",
        "img/Enemigo attack/5 ATTACK_001.png",
        "img/Enemigo attack/5 ATTACK_002.png",
        "img/Enemigo attack/5 ATTACK_003.png",
        "img/Enemigo attack/5 ATTACK_004.png"

    }, 0.1)


    e.die = animacion.crear({

        "img/Enemigo Die/6 DIE_000.png",
        "img/Enemigo Die/6 DIE_001.png",
        "img/Enemigo Die/6 DIE_002.png",
        "img/Enemigo Die/6 DIE_003.png",
        "img/Enemigo Die/6 DIE_004.png"

    }, 0.1)


    return e

end


function enemigo.recibirDanio(e, cantidad)

    if e.muerto then
        return
    end


    e.vida =
        e.vida - cantidad


    if e.vida <= 0 then

        e.vida = 0

        e.muerto = true

        e.estado = "die"

        animacion.reiniciar(
            e.die
        )

    end

end



function enemigo.actualizar(e, jugador, dt)


    if e.muerto then

        animacion.actualizarUnaVez(
            e.die,
            dt
        )

        return nil

    end



    if e.tiempoEntreAtaques > 0 then

        e.tiempoEntreAtaques =
            e.tiempoEntreAtaques - dt

    end


    local distancia = math.abs(

        (e.x + e.ancho / 2) -
        (jugador.x + jugador.ancho / 2)

    )



    if distancia < 100 then

        e.atacando = true

        e.estado = "attack"

        e.tiempoAtaque =
            e.tiempoAtaque + dt

        animacion.actualizar(
            e.attack,
            dt
        )


        if e.tiempoAtaque >= e.duracionAtaque then

            e.tiempoAtaque = 0


            if e.tiempoEntreAtaques <= 0 then

                e.tiempoEntreAtaques =
                    e.cooldownAtaque

                return "golpe"

            end

        end


    else

        e.atacando = false

        e.estado = "walk"


        if e.x < jugador.x then

            e.x =
                e.x + e.velocidad * dt

            e.direccion = 1

        else

            e.x =
                e.x - e.velocidad * dt

            e.direccion = -1

        end


        animacion.actualizar(
            e.walk,
            dt
        )

    end


    return nil

end


function enemigo.dibujar(e)

    local imagen


    if e.muerto then

        imagen =
            animacion.imagenActual(
                e.die
            )

    elseif e.atacando then

        imagen =
            animacion.imagenActual(
                e.attack
            )

    else

        imagen =
            animacion.imagenActual(
                e.walk
            )

    end


    if e.direccion == -1 then

        love.graphics.draw(

            imagen,

            e.x + e.ancho,

            e.y,

            0,

            -1,

            1

        )

    else

        love.graphics.draw(

            imagen,

            e.x,

            e.y,

            0,

            1,

            1

        )

    end

end


return enemigo