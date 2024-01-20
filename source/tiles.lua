Tiles = {nil}

-- Loads Tiles module.
function Tiles.load()
    Tiles.matrix = MatrixBool(COLUMN_NUMBER, ROW_NUMBER)

    for column = 1, COLUMN_NUMBER do
        for row = ROW_NUMBER-GROUND+1, ROW_NUMBER do
            Tiles.matrix[column][row] = true
        end
    end

    Tiles.matrix[15][6] = true
    Tiles.matrix[16][6] = true
    Tiles.matrix[17][6] = true
    Tiles.matrix[13][7] = false
    Tiles.matrix[13][8] = false
    Tiles.matrix[13][9] = false
end

-- Returns true if there is a tile at a given column or row.
function Tiles.isTile(column, row)
    if column < 1 or column > COLUMN_NUMBER then
        return true
    end

    if row < 1 or row > ROW_NUMBER then
        return true
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