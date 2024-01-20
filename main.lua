require "dependencies"

-- Main load function.
function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setLineWidth(PIXEL)

    Texture.load()
    Sound.load()
    Timer.load()
    Animation.load()
    Tiles.load()
    Particles.load()
    Player.load()
    Bullets.load()
    Crabs.load()        
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
    Particles.update(dt)
    Player.update(dt)
    Bullets.update(dt)
    Crabs.update(dt)
end

-- Main draw function.
function love.draw()
    local shift = Player.x-WINDOW_WIDTH/2
    shift = math.max(shift, 0)
    shift = math.min(shift, TILE_SIZE*COLUMN_NUMBER-WINDOW_WIDTH)
    
    love.graphics.clear(BLACK)

    love.graphics.translate(-shift/2, 0)
    
    love.graphics.draw(Texture.background, 0, 0, 0, PIXEL, PIXEL)
    love.graphics.draw(Texture.background, 24*TILE_SIZE, 0, 0, PIXEL, PIXEL)
    
    love.graphics.translate(-shift/2, 0)

    Tiles.draw()
    Particles.draw()
    Player.draw()
    Bullets.draw()
    Crabs.draw()

    love.graphics.translate(shift, 0)

    Interface.draw()
end