-- Creates new matrix of x and y dimensions filled with `false.
function MatrixBool(c, r, value)
    matrix = {nil}
    for x = 1, c do
        matrix[x] = {nil}
        for y = 1, r do
            matrix[x][y] = false
        end
    end
    return matrix
end

-- Creates new matrix of x and y dimensions filled with empty arrays.
function MatrixArray(c, r)
    matrix = {nil}
    for x = 1, c do
        matrix[x] = {nil}
        for y = 1, r do
            matrix[x][y] = {nil}
        end
    end
    return matrix
end