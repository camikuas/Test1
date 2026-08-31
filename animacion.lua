local animacion = {}


function animacion.crear(listaImagenes, velocidad)

    local anim = {}

    anim.imagenes = {}

    for i = 1, #listaImagenes do
        anim.imagenes[i] = love.graphics.newImage(listaImagenes[i])
    end

    anim.frame = 1
    anim.tiempo = 0
    anim.velocidad = velocidad
    anim.terminada = false

    return anim

end


function animacion.actualizar(anim, dt)

    if anim.terminada then
        return
    end

    anim.tiempo = anim.tiempo + dt

    if anim.tiempo >= anim.velocidad then

        anim.tiempo = 0
        anim.frame = anim.frame + 1

        if anim.frame > #anim.imagenes then
            anim.frame = 1
        end

    end

end


function animacion.actualizarUnaVez(anim, dt)

    if anim.terminada then
        return
    end

    anim.tiempo = anim.tiempo + dt

    if anim.tiempo >= anim.velocidad then

        anim.tiempo = 0
        anim.frame = anim.frame + 1

        if anim.frame > #anim.imagenes then

            anim.frame = #anim.imagenes
            anim.terminada = true

        end

    end

end


function animacion.imagenActual(anim)

    return anim.imagenes[anim.frame]

end


function animacion.reiniciar(anim)

    anim.frame = 1
    anim.tiempo = 0
    anim.terminada = false

end


return animacion