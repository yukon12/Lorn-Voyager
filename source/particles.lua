Particles = {nil}

function Particles.load()
    Particles.array = {nil}
end

function Particles.add(x, y, color, length, system)
    system:emit(100)
    table.insert(Particles.array, {x = x, y = y, color = color, length = length, system = system})
end

function Particles.update(dt)
    for it = #Particles.array, 1, -1 do
        local element = Particles.array[it]
        element.system:update(dt)
        element.length = element.length - dt
        if element.length < 0 then
            table.remove(Particles.array, it)
        end
    end
end

function Particles.draw()
    for i, element in pairs(Particles.array) do
        love.graphics.setColor(element.color)
        love.graphics.draw(element.system, element.x, element.y, 0, PIXEL, PIXEL)
    end
    love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
end