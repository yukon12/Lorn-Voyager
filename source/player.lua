Player = {nil}

-- Loads Player module.
function Player.load()
    Player.x = Utilities.fieldToCoordinate(3)
    Player.y = Utilities.fieldToCoordinate(6)
    Player.horizontalVelocity = 0
    Player.verticalVelocity = 0
    Player.state = "idle"
    Player.direction = "right"
    Player.walkingFrame = 1
    Player.currentTexture = Texture.player.idle

    Timer.addRepeating("walkingAnimation", 0.5, function()
        Player.walkingFrame = (Player.walkingFrame%2)+1
        if Player.checkState("walking") then
            Player.currentTexture = Texture.player.walking[Player.walkingFrame]
        end
    end)
end

-- Switches state of the player to the value given in argument.
function Player.setState(state)
    Player.state = state

    if state == "idle" then
        Player.currentTexture = Texture.player.idle
        return
    end

    if state == "walking" then
        Player.currentTexture = Texture.player.walking[1]
    end

    if state == "jumping" then
        Player.currentTexture = Texture.player.jumpingFalling
        Player.verticalVelocity = -JUMP_VELOCITY
        return
    end

    if state == "falling" then
        Player.currentTexture = Texture.player.jumpingFalling
        return
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
    local hV = 0
    if love.keyboard.isDown('a') then
        Player.direction = "left"
        hV = hV - WALK_VELOCITY
    end
    if love.keyboard.isDown('d') then
        Player.direction = "right"
        hV = hV + WALK_VELOCITY
    end
    Player.horizontalVelocity = hV
end

-- Returns true if the direction of the player is equal to the value given in the argument, return false otherwise.
function Player.checkDirection(direction)
    if Player.direction == direction then
        return true
    end
    return false
end

-- Returns true is player is in the air at the moment, returns false othwerwise.
function Player.isInAir()
    local leftColumn = Utilities.coordinateToField(Player.x-3*PIXEL)
    local rightColumn = Utilities.coordinateToField(Player.x+3*PIXEL)
    local row = Utilities.coordinateToField(Player.y+TILE_SIZE/2)

    if Tiles.isTile(leftColumn, row) or Tiles.isTile(rightColumn, row) then
        return false
    end

    return true
end

-- Updates player's state and position.
function Player.update(dt)
    Player.recognizeDirection()

    if Player.checkState("idle") then
        if love.keyboard.isDown('a') or love.keyboard.isDown('d') then
            Player.setState("walking")
        end
        if love.keyboard.isDown('w') then
            Player.setState("jumping")
        end
        if Player.isInAir() then
            Player.setState("falling")
        end
        return
    end

    if Player.checkState("walking") then
        if not love.keyboard.isDown('a') and not love.keyboard.isDown('d') then
            Player.setState("idle")
        end
        if love.keyboard.isDown('w') then
            Player.setState("jumping")
        end
        if Player.isInAir() then
            Player.setState("falling")
        end

        Player.x = Player.x + dt*Player.horizontalVelocity
        return
    end

    if Player.checkState("jumping") then
        if Player.verticalVelocity > 0 then
            Player.setState("falling")
        end

        Player.x = Player.x + MOVEMENT_IN_AIR*dt*Player.horizontalVelocity
        Player.verticalVelocity = Player.verticalVelocity + dt*GRAVITY
        Player.y = Player.y + dt*Player.verticalVelocity
        return
    end

    if Player.checkState("falling") then
        if not Player.isInAir() then
            Player.setState("idle")
            Player.verticalVelocity = 0
            Player.y = Utilities.fieldToCoordinate(Utilities.coordinateToField(Player.y))

        end

        Player.x = Player.x + MOVEMENT_IN_AIR*dt*Player.horizontalVelocity
        Player.verticalVelocity = Player.verticalVelocity + dt*GRAVITY
        Player.y = Player.y + dt*Player.verticalVelocity
        return
    end
end

-- Draw's player.
function Player.draw()
    if Player.checkDirection("left") then
        love.graphics.draw(Player.currentTexture, Player.x, Player.y, 0, -PIXEL, PIXEL, OFFSET, OFFSET)
        return
    end

    if Player.checkDirection("right") then
        love.graphics.draw(Player.currentTexture, Player.x, Player.y, 0, PIXEL, PIXEL, OFFSET, OFFSET)
        return
    end
end