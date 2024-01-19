Crabs = {nil}

-- Spawns crap at a given position.
function Crabs.spawn(column, row)
    table.insert(Crabs.matrix[column][row], Crab(column, row))
end

-- Loads Crabs module.
function Crabs.load()
    Crabs.matrix = MatrixArray(COLUMN_NUMBER, ROW_NUMBER)
    Crabs.texture = Texture.crab[1]
    
    Crabs.spawn(5, 1)
    Crabs.spawn(10, 1)
    Crabs.spawn(15, 1)
    Crabs.spawn(20, 1)
    Crabs.spawn(25, 1)
end

-- Updates all crabs.
function Crabs.update(dt)
    for c = 1, COLUMN_NUMBER do
        for r = 1, ROW_NUMBER do
            for it = #Crabs.matrix[c][r], 1, -1 do
                Crabs.matrix[c][r][it]:update(dt)
                local ac = Utilities.coordinateToField(Crabs.matrix[c][r][it].x)
                local ar = Utilities.coordinateToField(Crabs.matrix[c][r][it].y)
                if ac ~= c or ar ~= r then
                    table.insert(Crabs.matrix[ac][ar], Crabs.matrix[c][r][it])
                    table.remove(Crabs.matrix[c][r], it)
                end
            end
        end
    end
end

-- Draws all crabs.
function Crabs.draw()
    for c = 1, COLUMN_NUMBER do
        for r = 1, ROW_NUMBER do
            for it = #Crabs.matrix[c][r], 1, -1 do
                Crabs.matrix[c][r][it]:draw(dt)
            end
        end
    end
end

function Crab(column, row)
    return {
        x = Utilities.fieldToCoordinate(column),
        y = Utilities.fieldToCoordinate(row),
        horizontalVelocity = 0,
        verticalVelocity = 0,
        direction = "right",

        -- Returns true if crab is about to fall from tile to the left.
        willFallFromLeft = function(self)
            local column = Utilities.coordinateToField(self.x-7*PIXEL)
            local row = Utilities.coordinateToField(self.y+TILE_SIZE/2)

            if Tiles.isTile(column, row) then
                return false
            end

            return true
        end,

        -- Returns true if crab is about to fall from tile to the left.
        willFallFromRight = function(self)
            local column = Utilities.coordinateToField(self.x+7*PIXEL)
            local row = Utilities.coordinateToField(self.y+TILE_SIZE/2)

            if Tiles.isTile(column, row) then
                return false
            end

            return true
        end,

        -- Returns true if crab touches tile from bottom, returns false othwerwise.
        collidesFromBottom = function(self)
            if self:willFallFromLeft() and self:willFallFromRight() then
                return false
            end
            return true
        end,

        -- Returns true if crab touches tile from left, returns false otherwise.
        collidesFromLeft = function(self)
            local column = Utilities.coordinateToField(self.x-TILE_SIZE/2)
            local topRow = Utilities.coordinateToField(self.y-7*PIXEL)
            local bottomRow = Utilities.coordinateToField(self.y+7*PIXEL)

            if Tiles.isTile(column, topRow) or Tiles.isTile(column, bottomRow) then
                return true
            end

            return false
        end,

        -- Returns true if crab touches tile from left, returns false otherwise.
        collidesFromRight = function(self)
            local column = Utilities.coordinateToField(self.x+TILE_SIZE/2)
            local topRow = Utilities.coordinateToField(self.y-7*PIXEL)
            local bottomRow = Utilities.coordinateToField(self.y+7*PIXEL)

            if Tiles.isTile(column, topRow) or Tiles.isTile(column, bottomRow) then
                return true
            end

            return false
        end,

        -- Returns true if a given point is in the hurtbox of a crab.
        belongs = function(self, x, y)
            if x >= self.x-7*PIXEL and x <= self.x+7*PIXEL and y >= self.y-TILE_SIZE/2 and y <= self.y+TILE_SIZE/2 then
                return true
            end
            return false
        end,

        -- Crab's update function.
        update = function(self, dt)
            if not self:collidesFromBottom() then
                self.verticalVelocity = self.verticalVelocity + dt*GRAVITY
                self.y = self.y + dt*self.verticalVelocity 
                return
            end

            if self.verticalVelocity > 0 then
                self.verticalVelocity = 0
                self.y = Utilities.fieldCenter(self.y)
            end

            self.horizontalVelocity = -CRAB_VELOCITY
            if self.direction == "right" then
                self.horizontalVelocity = CRAB_VELOCITY
            end

            self.x = self.x + dt*self.horizontalVelocity
            
            if self.direction == "left" and (self:collidesFromLeft() or self.x < TILE_SIZE/2 or self:willFallFromLeft()) then
                self.direction = "right"
                return
            end

            if self:collidesFromRight() or self.x > TILE_SIZE*COLUMN_NUMBER-TILE_SIZE/2 or self:willFallFromRight() then
                self.direction = "left"
            end
        end,

        -- Crab's draw function.
        draw = function(self)
            love.graphics.draw(Texture.crab[Animation.frame], self.x, self.y, 0, PIXEL, PIXEL, OFFSET, OFFSET)
        end
    }
end