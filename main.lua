require "dependencies"

-- Main load function.
function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    Texture.load()
    Timer.load()
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
    Timer.update(dt)
    Player.update(dt)
end

-- Main draw function.
function love.draw()
    local shift = Player.x-WINDOW_WIDTH/2
    shift = math.max(shift, 0)
    shift = math.min(shift, TILE_SIZE*COLUMN_NUMBER-WINDOW_WIDTH)
    love.graphics.translate(-shift, 0)
    love.graphics.clear(BLACK)
    Player.draw()
    Tiles.draw()
end