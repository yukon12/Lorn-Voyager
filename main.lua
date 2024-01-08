require "dependencies"

-- Main load function.
function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setLineWidth(PIXEL)

    Texture.load()
    Timer.load()
    Player.load()
    Tiles.load()

    table.insert(Crabs, Crab(8, 1))
    table.insert(Crabs, Crab(2, 5))
    table.insert(Crabs, Crab(10, 2))
    table.insert(Crabs, Crab(18, 1))
    table.insert(Crabs, Crab(25, 2))

    animationFrame = 1
    Timer.addRepeating("walkingAnimation", 0.1, function()
        animationFrame = (animationFrame%2)+1
        if Player.checkState("walking") then
            Player.currentTexture = Texture.player.walking[animationFrame]
        end
    end)
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
    local it = 1
    for i, crab in pairs(Crabs) do
        crab:update(dt)
    end
    while it <= #Bullets do
        Bullets[it]:update(dt)
        if Bullets[it]:collidesWithTile() then
            table.remove(Bullets, it)
            it = it - 1
        else
            for i, crab in pairs(Crabs) do
                if crab:belongs(Bullets[it].x, Bullets[it].y) then
                    table.remove(Crabs, i)
                    break
                end
            end
        end
        it = it + 1
    end
end

-- Main draw function.
function love.draw()
    local shift = Player.x-WINDOW_WIDTH/2
    shift = math.max(shift, 0)
    shift = math.min(shift, TILE_SIZE*COLUMN_NUMBER-WINDOW_WIDTH)
    
    love.graphics.clear(BLACK)

    love.graphics.translate(-shift, 0)
    
    Tiles.draw()
    for i, crab in pairs(Crabs) do
        crab:draw()
    end
    for i, bullet in pairs(Bullets) do
        bullet:draw()
    end
    Player.draw()

    love.graphics.translate(shift, 0)

    Interface.draw()
end