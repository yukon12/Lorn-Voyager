Player = {nil}

-- Loads Player module.
function Player.load()
    Player.x = Utilities.fieldToCoordinate(10)
    Player.y = Utilities.fieldToCoordinate(6)
    Player.horizontalVelocity = 0
    Player.verticalVelocity = 0
    Player.health = 5
    Player.state = "idle"
    Player.direction = "right"
    Player.texture = Texture.player.idle
    Player.canShoot = true
    Player.canTakeDamage = true
    Player.particleSystem = love.graphics.newParticleSystem(Texture.pixel)
    Player.particleSystem:setParticleLifetime(0.5, 0.5)
    Player.particleSystem:setSpeed(-20, 20, -20, 20)
    Player.particleSystem:setLinearAcceleration(0, 0, -20, -20)
    Player.particleSystem:setEmissionArea("normal", 4, 0)
    Player.particleSystem:setColors(1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0)
end

-- Switches state of the player to the value given in argument.
function Player.setState(state)
    if Player.state == "walking" then
        Player.particleSystem:setEmissionRate(0)
    end

    Player.state = state

    if state == "idle" then
        Player.texture = Texture.player.idle
        return
    end

    if state == "walking" then
        Player.particleSystem:setEmissionRate(10)
        Player.texture = Texture.player.walking[1]
    end

    if state == "jumping" then
        Player.texture = Texture.player.jumpingFalling
        return
    end

    if state == "falling" then
        Player.texture = Texture.player.jumpingFalling
        return
    end

    if state == "dead" then
        Player.texture = Texture.player.jumpingFalling
    end
end

-- Returns true if the state of the player is equal to the value given in argument, returns false otherwise.
function Player.checkState(state)
    if Player.state == state then
        return true
    end
    return false
end

-- Checks whether move keys are down and sets direction and horizontalVelocity accordingly.
function Player.recognizeDirection()
    Player.horizontalVelocity = 0
    if love.keyboard.isDown('a') then
        Player.direction = "left"
        Player.horizontalVelocity = Player.horizontalVelocity - WALK_VELOCITY
    end
    if love.keyboard.isDown('d') then
        Player.direction = "right"
        Player.horizontalVelocity = Player.horizontalVelocity + WALK_VELOCITY
    end
end

-- Returns true if the direction of the player is equal to the value given in the argument, return false otherwise.
function Player.checkDirection(direction)
    if Player.direction == direction then
        return true
    end
    return false
end

-- Returns true if player touches tile from top, returns false otherwise.
function Player.collidesTileFromTop()
    local leftColumn = Utilities.coordinateToField(Player.x-3*PIXEL)
    local rightColumn = Utilities.coordinateToField(Player.x+3*PIXEL)
    local row = Utilities.coordinateToField(Player.y-TILE_SIZE/2)

    if Tiles.isTile(leftColumn, row) or Tiles.isTile(rightColumn, row) then
        return true
    end

    return false
end

-- Returns true if player touches tile from bottom, returns false othwerwise.
function Player.collidesTileFromBottom()
    local leftColumn = Utilities.coordinateToField(Player.x-3*PIXEL)
    local rightColumn = Utilities.coordinateToField(Player.x+3*PIXEL)
    local row = Utilities.coordinateToField(Player.y+TILE_SIZE/2)

    if Tiles.isTile(leftColumn, row) or Tiles.isTile(rightColumn, row) then
        return true
    end

    return false
end

-- Returns true if player touches tile from top, returns false otherwise.
function Player.collidesTileFromLeft()
    local column = Utilities.coordinateToField(Player.x-5*PIXEL)
    local topRow = Utilities.coordinateToField(Player.y-TILE_SIZE/2+PIXEL)
    local bottomRow = Utilities.coordinateToField(Player.y+TILE_SIZE/2-PIXEL)

    if Tiles.isTile(column, topRow) or Tiles.isTile(column, bottomRow) then
        return true
    end

    return false
end

-- Returns true if player touches tile from top, returns false otherwise.
function Player.collidesTileFromRight()
    local column = Utilities.coordinateToField(Player.x+5*PIXEL)
    local topRow = Utilities.coordinateToField(Player.y-TILE_SIZE/2+PIXEL)
    local bottomRow = Utilities.coordinateToField(Player.y+TILE_SIZE/2-PIXEL)

    if Tiles.isTile(column, topRow) or Tiles.isTile(column, bottomRow) then
        return true
    end

    return false
end

-- Returns opposite of `Player.collidesTileFromBottom()`.
function Player.isInAir()
    return not Player.collidesTileFromBottom()
end

-- Blocks player movement to left.
function Player.blockLeftMovement()
    if Player.checkDirection("left") and Player.collidesTileFromLeft() then
        Player.x = Utilities.fieldCenter(Player.x)-3*PIXEL
    end
end

-- Blocks player movement to right.
function Player.blockRightMovement()
    if Player.checkDirection("right") and Player.collidesTileFromRight() then
        if Player.x >= COLUMN_NUMBER*TILE_SIZE-TILE_SIZE/2 then
            Player.respawn()
        end
        Player.x = Utilities.fieldCenter(Player.x)+3*PIXEL
    end
end

-- Blocks player jumping.
function Player.blockTopMovement()
    if Player.collidesTileFromTop() then
        Player.y = Utilities.fieldCenter(Player.y)
        Player.verticalVelocity = 0
    end
end

-- Blocks player hitting the ground.
function Player.blockBottomMovement()
    if not Player.isInAir() then
        if Player.y >= WINDOW_HEIGHT-TILE_SIZE/2 then
            Player.health = 0
            Player.state = "dead"
            return
        end
        Player.setState("idle")
        Player.verticalVelocity = 0
        Player.y = Utilities.fieldCenter(Player.y)
    end
end

-- Makes player jump.
function Player.jump()
    Player.setState("jumping")
    Player.verticalVelocity = -JUMP_VELOCITY
end

-- Makes player bounce.
function Player.bounce()
    Player.setState("jumping")
    Player.verticalVelocity = -JUMP_VELOCITY/2
end

-- Resets player's hp, position and state.
function Player.respawn()
    Player.x = Utilities.fieldToCoordinate(10)
    Player.y = Utilities.fieldToCoordinate(6)
    Player.health = 5
    Player.setState("idle")
    Crabs.load()
end

-- Updates player's state and position.
function Player.update(dt)
    Player.particleSystem:update(dt)

    if love.keyboard.isDown('s') and Player.canShoot then
        local x = Player.x + (Player.direction == "right" and 4*PIXEL or -5*PIXEL)
        local y = Player.y
        local c = Utilities.coordinateToField(x)
        local r = Utilities.coordinateToField(y)
        table.insert(Bullets.matrix[c][r], Bullet(x, y, Player.direction))
        Player.canShoot = false
        Timer.addNonRepeating("reload", RELOAD_TIME, function()
            Player.canShoot = true
        end)
    end

    if Player.canTakeDamage and Player.health > 0 then
        local c = Utilities.coordinateToField(Player.x)
        local r = Utilities.coordinateToField(Player.y)
        for i, crab in pairs(Crabs.matrix[c][r]) do
            if math.abs(crab.x-Player.x) < TILE_SIZE and math.abs(crab.y-Player.y) < TILE_SIZE then
                Player.bounce()
                Player.health = Player.health-1
                if Player.health <= 0 then
                    Player.setState("dead")
                end
                Player.canTakeDamage = false
                Timer.addNonRepeating("immunity", IMMUNITY_TIME, function()
                    Player.canTakeDamage = true
                end)
            end
        end
    end

    if Player.checkState("idle") then
        if love.keyboard.isDown('a') or love.keyboard.isDown('d') then
            Player.setState("walking")
        end
        if love.keyboard.isDown("space") then
            Player.jump()
        end
        if Player.isInAir() then
            Player.setState("falling")
        end
        return
    end

    if Player.checkState("walking") then
        Player.x = Player.x + dt*Player.horizontalVelocity

        if not love.keyboard.isDown('a') and not love.keyboard.isDown('d') then
            Player.setState("idle")
        end
        if love.keyboard.isDown("space") then
            Player.jump()
        end
        if Player.isInAir() then
            Player.setState("falling")
        end

        Player.blockLeftMovement()
        Player.blockRightMovement()

        Player.recognizeDirection()
        return
    end

    if Player.checkState("jumping") then
        Player.x = Player.x + dt*Player.horizontalVelocity
        Player.verticalVelocity = Player.verticalVelocity + dt*GRAVITY
        Player.y = Player.y + dt*Player.verticalVelocity

        if Player.verticalVelocity > 0 then
            Player.setState("falling")
        end
        
        Player.blockTopMovement()
        Player.blockLeftMovement()
        Player.blockRightMovement()

        Player.recognizeDirection()
        return
    end

    if Player.checkState("falling") then
        Player.x = Player.x + dt*Player.horizontalVelocity
        Player.verticalVelocity = Player.verticalVelocity + dt*GRAVITY
        Player.y = Player.y + dt*Player.verticalVelocity

        if Player.y > TILE_SIZE*ROW_NUMBER+TILE_SIZE/2 then
            Player.respawn()
        end

        Player.blockBottomMovement()
        Player.blockLeftMovement()
        Player.blockRightMovement()

        Player.recognizeDirection()
        return
    end

    if Player.checkState("dead") then
        Player.verticalVelocity = Player.verticalVelocity + dt*GRAVITY
        Player.y = Player.y + dt*Player.verticalVelocity

        if Player.y > TILE_SIZE*ROW_NUMBER+TILE_SIZE/2 then
            Player.respawn()
        end
    end
end

-- Draws player.
function Player.draw()
    love.graphics.setColor(WHITE)
    love.graphics.draw(Player.particleSystem, Player.x, Player.y+TILE_SIZE/2, 0, PIXEL, PIXEL)
    love.graphics.setColor(1.0, 1.0, 1.0, 1.0)

    if Player.checkDirection("left") then
        love.graphics.draw(Player.texture, Player.x, Player.y, 0, -PIXEL, PIXEL, OFFSET, OFFSET)
        return
    end

    if Player.checkDirection("right") then
        love.graphics.draw(Player.texture, Player.x, Player.y, 0, PIXEL, PIXEL, OFFSET, OFFSET)
        return
    end
end