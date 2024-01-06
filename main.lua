require "dependencies"

-- Main load function.
function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    Texture.load()
    Player.load()
    Tiles.load()
end

-- Checks if key is pressed.
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

-- Main update function.
function love.update(dt)
    Player.update(dt)
end

-- Main draw function.
function love.draw()
    love.graphics.clear(BLACK)
    Player.draw()
    Tiles.draw()
end