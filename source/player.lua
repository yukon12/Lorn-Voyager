Player = {nil}

-- Loads Player module.
function Player.load()
    Player.x = Utilities.fieldToCoordinate(10)
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
    if Player.checkDirection("left") and (Player.collidesTileFromLeft() or Player.x < 5*PIXEL)then
        Player.x = Utilities.fieldCenter(Player.x)-3*PIXEL
    end
end

-- Blocks player movement to right.
function Player.blockRightMovement()
    if Player.checkDirection("right") and (Player.collidesTileFromRight() or Player.x > COLUMN_NUMBER*TILE_SIZE-5*PIXEL) then
        Player.x = Utilities.fieldCenter(Player.x)+3*PIXEL
    end
end

-- Blocks player jumping.
function Player.blockTopMovement()
    if Player.collidesTileFromTop() or Player.y < TILE_SIZE/2 then
        Player.y = Utilities.fieldCenter(Player.y)
        Player.verticalVelocity = 0
    end
end

-- Blocks player hitting the ground.
function Player.blockBottomMovement()
    if not Player.isInAir() then
        Player.setState("idle")
        Player.verticalVelocity = 0
        Player.y = Utilities.fieldCenter(Player.y)
    end
end

-- Updates player's state and position.
function Player.update(dt)
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

        Player.recognizeDirection()
        return
    end

    if Player.checkState("walking") then
        Player.x = Player.x + dt*Player.horizontalVelocity

        if not love.keyboard.isDown('a') and not love.keyboard.isDown('d') then
            Player.setState("idle")
        end
        if love.keyboard.isDown('w') then
            Player.setState("jumping")
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
            Player.x = Utilities.fieldToCoordinate(10)
            Player.y = Utilities.fieldToCoordinate(6)
        end

        Player.blockBottomMovement()
        Player.blockLeftMovement()
        Player.blockRightMovement()

        Player.recognizeDirection()
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