Font = {nil}

-- Loads Font module.
function Font.load()
    Font.small = love.graphics.newFont("resources/font.ttf", 32)
    Font.big = love.graphics.newFont("resources/font.ttf", 128)
end