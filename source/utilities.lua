Utilities = {nil}

-- Returns x or y of a column or a row.
function Utilities.fieldToCoordinate(field)
    return (field-0.5)*TILE_SIZE
end

-- Returns index of a column or a row located at a given x or y.
function Utilities.coordinateToField(coordinate)
    return math.floor(coordinate/TILE_SIZE)+1
end

-- Returns position of a column or a row located at a given x or y.
function Utilities.fieldCenter(coordinate)
    return Utilities.fieldToCoordinate(Utilities.coordinateToField(coordinate))
end