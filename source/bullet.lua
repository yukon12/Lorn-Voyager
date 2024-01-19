Bullets = {nil}

-- Loads Bullet module.
function Bullets.load()
    Bullets.matrix = MatrixArray(COLUMN_NUMBER, ROW_NUMBER, {nil})
end

-- Checks if a bullet collides with any crabs.
function detectCrabCollision(column, row, x, y)
    for it = #Crabs.matrix[column][row], 1, -1 do
        if Crabs.matrix[column][row][it]:belongs(x, y) then
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
    for c = 1, COLUMN_NUMBER do
        for r = 1, ROW_NUMBER do
            for it = #Bullets.matrix[c][r], 1, -1 do
                Bullets.matrix[c][r][it]:draw()
            end
        end
    end
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
            love.graphics.draw(Texture.bullet, self.x, self.y, 0, PIXEL, PIXEL, 0, 0)
        end
    }
end