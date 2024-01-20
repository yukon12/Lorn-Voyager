Tiles = {nil}

-- Loads Tiles module.
function Tiles.load()
    Tiles.matrix = MatrixBool(COLUMN_NUMBER, ROW_NUMBER)

    for column = 1, COLUMN_NUMBER do
        for row = ROW_NUMBER-GROUND+1, ROW_NUMBER do
            Tiles.matrix[column][row] = true
        end
    end

    Tiles.matrix[1][6] = true
    Tiles.matrix[2][6] = true
    Tiles.matrix[3][6] = true
    Tiles.matrix[15][7] = false
    Tiles.matrix[15][8] = false
    Tiles.matrix[15][9] = false
    Tiles.matrix[16][6] = true
    Tiles.matrix[16][5] = true
    Tiles.matrix[17][6] = true
    Tiles.matrix[18][3] = true
    Tiles.matrix[19][3] = true
    Tiles.matrix[20][3] = true
    Tiles.matrix[21][3] = true
    Tiles.matrix[22][3] = true
    Tiles.matrix[23][6] = true
    Tiles.matrix[23][5] = true
    Tiles.matrix[24][7] = false
    Tiles.matrix[24][8] = false
    Tiles.matrix[24][9] = false
    Tiles.matrix[25][6] = true
    Tiles.matrix[25][5] = true
    Tiles.matrix[25][4] = true
    Tiles.matrix[25][3] = true
    Tiles.matrix[26][4] = true
    Tiles.matrix[27][3] = true
    Tiles.matrix[27][4] = true
    Tiles.matrix[29][4] = true
    Tiles.matrix[29][3] = true
    Tiles.matrix[30][4] = true
    Tiles.matrix[31][1] = true
    Tiles.matrix[31][2] = true
    Tiles.matrix[31][3] = true
    Tiles.matrix[31][4] = true
    Tiles.matrix[31][5] = true
    Tiles.matrix[31][6] = true
    Tiles.matrix[28][6] = true
    Tiles.matrix[29][6] = true
    Tiles.matrix[26][7] = false
    Tiles.matrix[27][7] = false
    Tiles.matrix[28][7] = false
    Tiles.matrix[29][7] = false
    Tiles.matrix[30][7] = false
    Tiles.matrix[26][8] = false
    Tiles.matrix[30][8] = false
    Tiles.matrix[30][6] = true
    Tiles.matrix[31][8] = false
    Tiles.matrix[32][8] = false
    Tiles.matrix[33][8] = false
    Tiles.matrix[33][7] = false
    Tiles.matrix[35][6] = true
    Tiles.matrix[36][6] = true
    Tiles.matrix[37][6] = true
    Tiles.matrix[38][6] = true
    Tiles.matrix[39][6] = true
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