StateMachine = {nil}

-- Loads StateMachine module.
function StateMachine.load()
    StateMachine.state = "title"
    StateMachine.transition = {nil}
    StateMachine.transition.first = nil
    StateMachine.transition.second = nil
    StateMachine.transition.position = 0
    StateMachine.transition.velocity = 0
    StateMachine.transition.after = nil
    StateMachine.transition.shift = 0
end

-- Loads all modules related to game state.
function StateMachine.loadGame()
    Animation.load()
    Tiles.load()
    Particles.load()
    Player.load()
    Bullets.load()
    Crabs.load()   
end

-- Changes state.
function StateMachine.changeState(state)
    StateMachine.state = state
end

-- Checks whether state in the argument is currently choosen.
function StateMachine.checkState(state)
    if StateMachine.state == state then
        return true
    end
    return false
end

-- Starts state transition.
function StateMachine.startTransition(first, second, position, velocity, after)
    StateMachine.changeState("transition")
    StateMachine.transition.first = first
    StateMachine.transition.second = second
    StateMachine.transition.position = position
    StateMachine.transition.shift = -position
    StateMachine.transition.velocity = velocity
    StateMachine.transition.after = after
end

-- Updates currently chosen state.
function StateMachine.update(dt)
    if StateMachine.checkState("transition") then
        StateMachine.transition.shift = StateMachine.transition.shift - dt*StateMachine.transition.velocity
        if StateMachine.transition.velocity > 0 and StateMachine.transition.shift <= 0 then
            StateMachine.changeState(StateMachine.transition.after)
        end
        if StateMachine.transition.velocity < 0 and StateMachine.transition.shift >= 0 then
            StateMachine.changeState(StateMachine.transition.after)
        end
        return
    end

    if StateMachine.checkState("title") then
        if love.keyboard.isDown("return") then
            StateMachine.startTransition(StateMachine.drawTitleScreen, StateMachine.drawGame, -1000, 500, "game")
        end
        return
    end

    if StateMachine.checkState("game") then
        Timer.update(dt)
        Particles.update(dt)
        Player.update(dt)
        Bullets.update(dt)
        Crabs.update(dt)
        return
    end

    if StateMachine.checkState("lose") then
        if love.keyboard.isDown("return") then
            StateMachine.loadGame()
            StateMachine.startTransition(StateMachine.drawLoseScreen, StateMachine.drawGame, -1000, 500, "game")
        end
    end

    if StateMachine.checkState("win") then
        if love.keyboard.isDown("return") then
            StateMachine.loadGame()
            StateMachine.startTransition(StateMachine.drawWinScreen, StateMachine.drawTitleScreen, -1000, 500, "title")
        end
    end
end

-- Draws title screen.
function StateMachine.drawTitleScreen(x, y)
    love.graphics.setColor(BLUE)
    love.graphics.printf("Lorn Voyager", Font.big, x+WINDOW_WIDTH/2-300, y+100, 600, "center")
    love.graphics.setColor(WHITE)
    love.graphics.printf("Press ENTER to continue.", Font.small, x+WINDOW_WIDTH/2-300, y+500, 600, "center")
    love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
end

-- Draws lose screen.
function StateMachine.drawLoseScreen(x, y)
    love.graphics.setColor(RED)
    love.graphics.printf("You've lost!", Font.big, x+WINDOW_WIDTH/2-300, y+100, 600, "center")
    love.graphics.setColor(WHITE)
    love.graphics.printf("Press ENTER to try again.", Font.small, x+WINDOW_WIDTH/2-300, y+500, 600, "center")
    love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
end

-- Draws win screen.
function StateMachine.drawWinScreen(x, y)
    love.graphics.setColor(YELLOW)
    love.graphics.printf("You've won!", Font.big, x+WINDOW_WIDTH/2-300, y+100, 600, "center")
    love.graphics.setColor(WHITE)
    love.graphics.printf("Press ENTER to go to the title screen.", Font.small, x+WINDOW_WIDTH/2-300, y+500, 600, "center")
    love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
end

-- Draws game.
function StateMachine.drawGame(x, y)
    love.graphics.translate(x, y)
    local shift = Player.x-WINDOW_WIDTH/2
    shift = math.max(shift, 0)
    shift = math.min(shift, TILE_SIZE*COLUMN_NUMBER-WINDOW_WIDTH)
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
    love.graphics.translate(-x, -y)
end

-- Draws currently chosen state.
function StateMachine.draw()
    if StateMachine.checkState("transition") then
        love.graphics.clear(BLACK)
        love.graphics.translate(0, StateMachine.transition.shift)
        StateMachine.transition.first(0, StateMachine.transition.position)
        StateMachine.transition.second(0, 0)
        return
    end

    if StateMachine.checkState("title") then
        love.graphics.clear(BLACK)
        StateMachine.drawTitleScreen(0, 0)
        return
    end

    if StateMachine.checkState("game") then
        love.graphics.clear(BLACK)
        StateMachine.drawGame(0, 0)
        return 
    end

    if StateMachine.checkState("lose") then
        love.graphics.clear(BLACK)
        StateMachine.drawLoseScreen(0, 0)
        return 
    end

    if StateMachine.checkState("win") then
        love.graphics.clear(BLACK)
        StateMachine.drawWinScreen(0, 0)
        return 
    end
end