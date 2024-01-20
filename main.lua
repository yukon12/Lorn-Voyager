require "dependencies"

-- Main load function.
function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setLineWidth(PIXEL)

    StateMachine.load()
    Texture.load()
    Sound.load()
    Font.load()
    Timer.load()
    StateMachine.loadGame()     
end

-- Checks if key is pressed.
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

-- Main update function.
function love.update(dt)
    StateMachine.update(dt)
end

-- Main draw function.
function love.draw()
    StateMachine.draw()
end