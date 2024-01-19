Interface = {nil}

-- Draws interface.
function Interface.draw()
    love.graphics.setColor(GREY)
    love.graphics.rectangle("fill", PIXEL/2, PIXEL/2, (64-1)*PIXEL, (4-1)*PIXEL)
    if Player.health > 0 then
        love.graphics.setColor(RED)
        love.graphics.rectangle("fill", PIXEL/2, PIXEL/2, (64-1)*PIXEL*Player.health/5, (4-1)*PIXEL)
    end
    love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
end