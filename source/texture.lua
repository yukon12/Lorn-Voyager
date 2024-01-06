Texture = {nil}

-- Loads Texture module.
function Texture.load()
    Texture.tile = love.graphics.newImage("resources/tile.png")
    Texture.topper = love.graphics.newImage("resources/topper.png")
    Texture.player = love.graphics.newImage("resources/player.png")
    Texture.box = love.graphics.newImage("resources/box.png")
end