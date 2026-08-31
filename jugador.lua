local animacion = require("animacion")

local jugador = {}


function jugador.crear()

    local j = {}


    j.ancho = 130
    j.alto = 105


    -- Pantalla: 639 x 360
    -- Suelo: 72 px desde abajo
    -- 360 - 72 = 288

    j.x = 639 / 2 - j.ancho / 2
    j.y = 288 - j.alto



    j.velocidad = 150

    -- 1 = derecha
    -- -1 = izquierda

    j.direccion = 1



    j.vida = 20
    j.vidaMaxima = 20

    j.danio = 2


    j.velocidadY = 0

    j.gravedad = 700

    j.fuerzaSalto = -300

    j.enSuelo = true


    j.estado = "idle"

    j.atacando = false

    j.tiempoAtaque = 0

    j.duracionAtaque = 0.6

    j.muerto = false


    j.idle = animacion.crear({

        "img/Jugador Idle/Wraith_03_Idle_000.png",
        "img/Jugador Idle/Wraith_03_Idle_001.png",
        "img/Jugador Idle/Wraith_03_Idle_002.png",
        "img/Jugador Idle/Wraith_03_Idle_003.png",
        "img/Jugador Idle/Wraith_03_Idle_004.png",
        "img/Jugador Idle/Wraith_03_Idle_005.png",
        "img/Jugador Idle/Wraith_03_Idle_006.png",
        "img/Jugador Idle/Wraith_03_Idle_007.png",
        "img/Jugador Idle/Wraith_03_Idle_008.png",
        "img/Jugador Idle/Wraith_03_Idle_009.png",
        "img/Jugador Idle/Wraith_03_Idle_00010.png",
        "img/Jugador Idle/Wraith_03_Idle_011.png"

    }, 0.08)

    j.walk = animacion.crear({

        "img/Jugador walk/Wraith_03_Moving Forward_000.png",
        "img/Jugador walk/Wraith_03_Moving Forward_001.png",
        "img/Jugador walk/Wraith_03_Moving Forward_002.png",
        "img/Jugador walk/Wraith_03_Moving Forward_003.png",
        "img/Jugador walk/Wraith_03_Moving Forward_004.png",
        "img/Jugador walk/Wraith_03_Moving Forward_005.png",
        "img/Jugador walk/Wraith_03_Moving Forward_006.png",
        "img/Jugador walk/Wraith_03_Moving Forward_007.png",
        "img/Jugador walk/Wraith_03_Moving Forward_008.png",
        "img/Jugador walk/Wraith_03_Moving Forward_009.png",
        "img/Jugador walk/Wraith_03_Moving Forward_010.png",
        "img/Jugador walk/Wraith_03_Moving Forward_011.png"

    }, 0.07)

    j.attack = animacion.crear({

        "img/Jugador attack/Wraith_03_Attack_000.png",
        "img/Jugador attack/Wraith_03_Attack_001.png",
        "img/Jugador attack/Wraith_03_Attack_002.png",
        "img/Jugador attack/Wraith_03_Attack_003.png",
        "img/Jugador attack/Wraith_03_Attack_004.png",
        "img/Jugador attack/Wraith_03_Attack_005.png",
        "img/Jugador attack/Wraith_03_Attack_006.png",
        "img/Jugador attack/Wraith_03_Attack_007.png",
        "img/Jugador attack/Wraith_03_Attack_008.png",
        "img/Jugador attack/Wraith_03_Attack_009.png",
        "img/Jugador attack/Wraith_03_Attack_010.png",
        "img/Jugador attack/Wraith_03_Attack_011.png"

    }, 0.05)



    j.dying = animacion.crear({

        "img/Jugador Die/Wraith_03_Dying_000.png",
        "img/Jugador Die/Wraith_03_Dying_001.png",
        "img/Jugador Die/Wraith_03_Dying_002.png",
        "img/Jugador Die/Wraith_03_Dying_003.png",
        "img/Jugador Die/Wraith_03_Dying_004.png",
        "img/Jugador Die/Wraith_03_Dying_005.png",
        "img/Jugador Die/Wraith_06_Dying_007.png",
        "img/Jugador Die/Wraith_03_Dying_008.png",
        "img/Jugador Die/Wraith_03_Dying_009.png",
        "img/Jugador Die/Wraith_03_Dying_0010.png",
        "img/Jugador Die/Wraith_03_Dying_011.png",
        "img/Jugador Die/Wraith_03_Dying_012.png",
        "img/Jugador Die/Wraith_03_Dying_013.png",
        "img/Jugador Die/Wraith_03_Dying_014.png"

    }, 0.08)


    return j

end


function jugador.recibirDanio(j, cantidad)

    if j.muerto then
        return
    end

    j.vida = j.vida - cantidad

    if j.vida <= 0 then

        j.vida = 0

        j.muerto = true

        j.estado = "dying"

        animacion.reiniciar(j.dying)

    end

end



function jugador.atacar(j)

    if j.muerto then
        return false
    end

    if j.atacando then
        return false
    end

    j.atacando = true

    j.tiempoAtaque = 0

    j.estado = "attack"

    animacion.reiniciar(j.attack)

    return true

end



function jugador.actualizar(j, dt)


    if j.muerto then

        animacion.actualizarUnaVez(
            j.dying,
            dt
        )

        return

    end


    if j.atacando then

        j.tiempoAtaque =
            j.tiempoAtaque + dt

        animacion.actualizar(
            j.attack,
            dt
        )


        if j.tiempoAtaque >= j.duracionAtaque then

            j.atacando = false

            j.estado = "idle"

        end


    else


        local moviendo = false


        if love.keyboard.isDown("left") or
           love.keyboard.isDown("a") then

            j.x =
                j.x - j.velocidad * dt

            j.direccion = -1

            moviendo = true

        end


        if love.keyboard.isDown("right") or
           love.keyboard.isDown("d") then

            j.x =
                j.x + j.velocidad * dt

            j.direccion = 1

            moviendo = true

        end


        if moviendo then

            j.estado = "walk"

            animacion.actualizar(
                j.walk,
                dt
            )

        else

            j.estado = "idle"

            animacion.actualizar(
                j.idle,
                dt
            )

        end

    end

    j.velocidadY =
        j.velocidadY +
        j.gravedad * dt

    j.y =
        j.y +
        j.velocidadY * dt


    local sueloY = 288


    if j.y + j.alto >= sueloY then

        j.y =
            sueloY - j.alto

        j.velocidadY = 0

        j.enSuelo = true

    else

        j.enSuelo = false

    end

    if j.x < 0 then
        j.x = 0
    end


    if j.x + j.ancho > 639 then

        j.x =
            639 - j.ancho

    end

end


function jugador.saltar(j)

    if j.muerto then
        return
    end

    if j.enSuelo then

        j.velocidadY =
            j.fuerzaSalto

        j.enSuelo = false

    end

end


function jugador.dibujar(j)

    local imagen


    if j.muerto then

        imagen =
            animacion.imagenActual(
                j.dying
            )

    elseif j.atacando then

        imagen =
            animacion.imagenActual(
                j.attack
            )

    elseif j.estado == "walk" then

        imagen =
            animacion.imagenActual(
                j.walk
            )

    else

        imagen =
            animacion.imagenActual(
                j.idle
            )

    end


    if j.direccion == -1 then

        love.graphics.draw(

            imagen,

            j.x + j.ancho,

            j.y,

            0,

            -1,

            1

        )

    else

        love.graphics.draw(

            imagen,

            j.x,

            j.y,

            0,

            1,

            1

        )

    end

end


return jugador