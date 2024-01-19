Bullets = {nil}

-- Loads Bullet module.
function Bullets.load()
    Bullets.matrix = MatrixArray(COLUMN_NUMBER, ROW_NUMBER, {nil})
end

-- Checks if a bullet collides with any crabs.
function detectCrabCollision(column, row, x, y)
    for it = #Crabs.matrix[column][row], 1, -1 do
        if Crabs.matrix[column][row][it]:belongs(x, y) then
            local particleSystem = love.graphics.newParticleSystem(Texture.pixel)
            particleSystem:setParticleLifetime(0.5, 0.5)
            particleSystem:setSpeed(-20, 20, -20, 20)
            particleSystem:setLinearAcceleration(0, 0, 20, 20)
            particleSystem:setEmissionArea("normal", 4, 4)
            particleSystem:setColors(1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0)
            local x = Crabs.matrix[column][row][it].x
            local y = Crabs.matrix[column][row][it].y
            Particles.add(x, y, RED, 1, particleSystem)
            table.remove(Crabs.matrix[column][row], it)
            return true
        end
    end
end

-- Updates bullets.
function Bullets.update(dt)
    for c = 1, COLUMN_NUMBER do
        for r = 1, ROW_NUMBER do
            for it = #Bullets.matrix[c][r], 1, -1 do
                Bullets.matrix[c][r][it]:update(dt)
                local ac = Utilities.coordinateToField(Bullets.matrix[c][r][it].x)
                if ac ~= c then
                    if not Tiles.isTile(ac, r) then
                        table.insert(Bullets.matrix[ac][r], Bullets.matrix[c][r][it])
                    end
                    table.remove(Bullets.matrix[c][r], it)
                else
                    if detectCrabCollision(c, r, Bullets.matrix[c][r][it].x, Bullets.matrix[c][r][it].y) then
                        table.remove(Bullets.matrix[c][r], it)
                    end
                end
            end
        end
    end
end

-- Draws bullets.
function Bullets.draw()
    love.graphics.setColor(YELLOW)
    for c = 1, COLUMN_NUMBER do
        for r = 1, ROW_NUMBER do
            for it = #Bullets.matrix[c][r], 1, -1 do
                Bullets.matrix[c][r][it]:draw()
            end
        end
    end
    love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
end

function Bullet(x, y, direction)
    return {
        x = x,
        y = y,
        velocity = (direction=="right") and BULLET_VELOCITY or -BULLET_VELOCITY,

        -- Bullet's update function.
        update = function(self, dt)
            self.x = self.x + dt*self.velocity
        end,

        -- Bullet's draw function.
        draw = function(self)
            love.graphics.draw(Texture.pixel, self.x, self.y, 0, PIXEL, PIXEL, 0, 0)
        end
    }
end