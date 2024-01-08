Bullets = {nil}

function Bullet(x, y, direction)
    return {
        x = x,
        y = y,
        velocity = (direction=="right") and BULLET_VELOCITY or -BULLET_VELOCITY,

        -- Checks if the bullet collides with any tile.
        collidesWithTile = function(self)
            return Tiles.isTile(Utilities.coordinateToField(self.x), Utilities.coordinateToField(self.y))
        end,

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