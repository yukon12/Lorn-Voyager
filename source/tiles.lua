Tiles = {nil}

-- Loads Tiles module.
function Tiles.load()
    Tiles.matrix = {nil}

    for column = 1, COLUMN_NUMBER do
        Tiles.matrix[column] = {nil}    
    end

    for column = 1, COLUMN_NUMBER do
        for row = 1, ROW_NUMBER do
            Tiles.matrix[column][row] = false
        end
    end

    for column = 1, COLUMN_NUMBER do
        for row = ROW_NUMBER-GROUND+1, ROW_NUMBER do
            Tiles.matrix[column][row] = true
        end
    end

    Tiles.matrix[6][7] = true
    Tiles.matrix[7][7] = true
    Tiles.matrix[8][7] = true
    Tiles.matrix[16][3] = true
    Tiles.matrix[16][4] = true
    Tiles.matrix[17][4] = true
    Tiles.matrix[18][4] = true

    Tiles.matrix[22][8] = false
    Tiles.matrix[22][9] = false
    Tiles.matrix[22][10] = false
end

-- Returns true if there is a tile at a given column or row.
function Tiles.isTile(column, row)
    if column < 1 or column > COLUMN_NUMBER then
        return false
    end

    if row < 1 or row > ROW_NUMBER then
        return false
    end

    if Tiles.matrix[column][row] then
        return true
    end

    return false
end

function Tiles.drawTile(column, row)
    if Tiles.isTile(column, row) then
        love.graphics.draw(Texture.tile, Utilities.fieldToCoordinate(column), Utilities.fieldToCoordinate(row), 0, PIXEL, PIXEL, OFFSET, OFFSET)
        if not Tiles.isTile(column, row-1) then
            love.graphics.draw(Texture.topper.top, Utilities.fieldToCoordinate(column), Utilities.fieldToCoordinate(row), 0, PIXEL, PIXEL, OFFSET, OFFSET)
        end
        if not Tiles.isTile(column, row+1) then
            love.graphics.draw(Texture.topper.bottom, Utilities.fieldToCoordinate(column), Utilities.fieldToCoordinate(row), 0, PIXEL, PIXEL, OFFSET, OFFSET)
        end
        if not Tiles.isTile(column-1, row) then
            love.graphics.draw(Texture.topper.left, Utilities.fieldToCoordinate(column), Utilities.fieldToCoordinate(row), 0, PIXEL, PIXEL, OFFSET, OFFSET)
        end
        if not Tiles.isTile(column+1, row) then
            love.graphics.draw(Texture.topper.right, Utilities.fieldToCoordinate(column), Utilities.fieldToCoordinate(row), 0, PIXEL, PIXEL, OFFSET, OFFSET)
        end
    end
end

-- Draws tiles.
function Tiles.draw()
    for column = 1, COLUMN_NUMBER do
        for row = 1, ROW_NUMBER do
            Tiles.drawTile(column, row)
        end
    end
end