local jugador = require("jugador")
local enemigo = require("enemigo")
local ataque = require("ataque")


local ANCHO = 639
local ALTO = 360

local SUELO = 288

local TIEMPO_TOTAL = 30

-- VARIABLES

local fondo

local jugadorPrincipal

local enemigos = {}

local efectoAtaque


-- TIEMPO

local tiempoJuego = 0

-- ESTADO

local juegoTerminado = false

local gano = false


-- OLEADAS

local oleada3 = false

local oleada10 = false

local oleada17 = false

local oleada24 = false



-- SONIDOS

local musicaForest

local musicaSpooky

local sonidoAtaqueJugador

local sonidoAtaqueEnemigo



function love.load()


    love.window.setMode(
        ANCHO,
        ALTO
    )

    love.window.setTitle(
        "Arena - Sobrevive 30 segundos"
    )

    fondo =
        love.graphics.newImage(
            "img/Fondo bosque oscuro.png"
        )


    jugadorPrincipal =
        jugador.crear()


    efectoAtaque =
        ataque.crear()


    musicaForest =
        love.audio.newSource(
            "menu/Musica/Fondo/Forest.wav",
            "stream"
        )


    musicaSpooky =
        love.audio.newSource(
            "menu/Musica/Fondo/spookymagic.wav",
            "stream"
        )


    musicaForest:setLooping(true)

    musicaSpooky:setLooping(true)


    musicaForest:setVolume(0.5)

    musicaSpooky:setVolume(0.5)


    musicaForest:play()

    musicaSpooky:play()

    sonidoAtaqueJugador =
        love.audio.newSource(
            "menu/Musica/efecto/magic-strike.wav",
            "static"
        )


    sonidoAtaqueEnemigo =
        love.audio.newSource(
            "menu/Musica/efecto/sword-slash.wav",
            "static"
        )




    math.randomseed(os.time())

end

function crearEnemigo()

    local x


    if math.random(1, 2) == 1 then

        x = -130

    else

        x = ANCHO + 130

    end


    local nuevoEnemigo =
        enemigo.crear(x)


    table.insert(
        enemigos,
        nuevoEnemigo
    )

end

function crearOleada(cantidad)

    for i = 1, cantidad do

        crearEnemigo()

    end

end

function hayColision(a, b)

    if a.x < b.x + b.ancho and
       a.x + a.ancho > b.x and
       a.y < b.y + b.alto and
       a.y + a.alto > b.y then

        return true

    end


    return false

end


function atacarEnemigos()

    local areaAtaque = {}


    areaAtaque.ancho = 130

    areaAtaque.alto = 105

    areaAtaque.y =
        jugadorPrincipal.y


    if jugadorPrincipal.direccion == 1 then

        areaAtaque.x =
            jugadorPrincipal.x +
            jugadorPrincipal.ancho

    else

        areaAtaque.x =
            jugadorPrincipal.x -
            areaAtaque.ancho

    end


    for i = 1, #enemigos do

        local e =
            enemigos[i]


        if not e.muerto then

            if hayColision(
                areaAtaque,
                e
            ) then

                -- El jugador hace 2 daño

                enemigo.recibirDanio(
                    e,
                    jugadorPrincipal.danio
                )

            end

        end

    end

end


function love.update(dt)

    if juegoTerminado then
        return
    end


    tiempoJuego =
        tiempoJuego + dt


    if tiempoJuego >= TIEMPO_TOTAL then

        tiempoJuego =
            TIEMPO_TOTAL

        juegoTerminado = true

        gano = true

        return

    end


    jugador.actualizar(
        jugadorPrincipal,
        dt
    )



    ataque.actualizar(
        efectoAtaque,
        dt
    )


    if tiempoJuego >= 3 and
       not oleada3 then

        crearOleada(1)

        oleada3 = true

    end


    if tiempoJuego >= 10 and
       not oleada10 then

        crearOleada(2)

        oleada10 = true

    end


    if tiempoJuego >= 17 and
       not oleada17 then

        crearOleada(3)

        oleada17 = true

    end


    -- ======================================

    if tiempoJuego >= 24 and
       not oleada24 then

        crearOleada(4)

        oleada24 = true

    end


    for i = #enemigos, 1, -1 do

        local e =
            enemigos[i]


        local resultado =
            enemigo.actualizar(
                e,
                jugadorPrincipal,
                dt
            )


        if resultado == "golpe" then

            jugador.recibirDanio(
                jugadorPrincipal,
                e.danio
            )


            sonidoAtaqueEnemigo:stop()

            sonidoAtaqueEnemigo:play()

        end


        if e.muerto and
           e.die.terminada then

            table.remove(
                enemigos,
                i
            )

        end

    end


    if jugadorPrincipal.muerto then

        juegoTerminado = true

        gano = false

    end

end



function love.keypressed(tecla)


    if tecla == "up" or
       tecla == "w" then

        jugador.saltar(
            jugadorPrincipal
        )

    end


    if tecla == "r" and
       juegoTerminado then

        reiniciarJuego()

    end

end



function love.mousepressed(x, y, boton)

    if juegoTerminado then
        return
    end


    -- Click izquierdo

    if boton == 1 then

        local ataco =
            jugador.atacar(
                jugadorPrincipal
            )


        if ataco then

            -- Sonido

            sonidoAtaqueJugador:stop()

            sonidoAtaqueJugador:play()


            -- Magia

            ataque.iniciar(
                efectoAtaque,
                jugadorPrincipal
            )


            -- Daño

            atacarEnemigos()

        end

    end

end


function reiniciarJuego()

    jugadorPrincipal =
        jugador.crear()


    enemigos = {}


    efectoAtaque =
        ataque.crear()


    tiempoJuego = 0


    juegoTerminado = false

    gano = false


    oleada3 = false

    oleada10 = false

    oleada17 = false

    oleada24 = false

end


function love.draw()


    -- ======================================
    -- FONDO
    -- ======================================

    love.graphics.draw(
        fondo,
        0,
        0
    )


    -- ======================================
    -- ENEMIGOS
    -- ======================================

    for i = 1, #enemigos do

        enemigo.dibujar(
            enemigos[i]
        )

    end


    jugador.dibujar(
        jugadorPrincipal
    )


    ataque.dibujar(
        efectoAtaque
    )

    dibujarInterfaz()



    if juegoTerminado then

        dibujarPantallaFinal()

    end

end


function dibujarInterfaz()



    love.graphics.setColor(
        0.5,
        0,
        0
    )


    love.graphics.rectangle(
        "fill",
        10,
        10,
        150,
        20
    )


    local anchoVida =

        150 *
        (
            jugadorPrincipal.vida /
            jugadorPrincipal.vidaMaxima
        )


    love.graphics.setColor(
        0,
        0.8,
        0
    )


    love.graphics.rectangle(
        "fill",
        10,
        10,
        anchoVida,
        20
    )


    love.graphics.setColor(
        1,
        1,
        1
    )


    love.graphics.print(
        "VIDA: " ..
        jugadorPrincipal.vida ..
        " / " ..
        jugadorPrincipal.vidaMaxima,

        10,
        35
    )


    local tiempoRestante =

        math.ceil(
            TIEMPO_TOTAL -
            tiempoJuego
        )


    if tiempoRestante < 0 then

        tiempoRestante = 0

    end


    love.graphics.print(
        "TIEMPO: " ..
        tiempoRestante,

        540,
        15
    )


    love.graphics.setColor(
        1,
        1,
        1
    )

end


function dibujarPantallaFinal()


    love.graphics.setColor(
        0,
        0,
        0,
        0.7
    )


    love.graphics.rectangle(
        "fill",
        0,
        0,
        ANCHO,
        ALTO
    )


    love.graphics.setColor(
        1,
        1,
        1
    )


    if gano then

        love.graphics.printf(
            "¡GANASTE!",
            0,
            140,
            ANCHO,
            "center"
        )


        love.graphics.printf(
            "Sobreviviste los 30 segundos",
            0,
            180,
            ANCHO,
            "center"
        )

    else

        love.graphics.printf(
            "PERDISTE",
            0,
            140,
            ANCHO,
            "center"
        )


        love.graphics.printf(
            "El jugador murió",
            0,
            180,
            ANCHO,
            "center"
        )

    end


    love.graphics.printf(
        "Presiona R para volver a jugar",
        0,
        220,
        ANCHO,
        "center"
    )

end
