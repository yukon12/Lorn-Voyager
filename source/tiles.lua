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
        for row = ROW_NUMBER-1, ROW_NUMBER do
            Tiles.matrix[column][row] = true
        end
    end
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
            love.graphics.draw(Texture.topper, Utilities.fieldToCoordinate(column), Utilities.fieldToCoordinate(row), 0, PIXEL, PIXEL, OFFSET, OFFSET)
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