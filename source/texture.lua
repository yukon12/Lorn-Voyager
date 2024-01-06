Texture = {nil}

-- Loads Texture module.
function Texture.load()
    Texture.tile = love.graphics.newImage("resources/tile.png")
    Texture.topper = {
        top = love.graphics.newImage("resources/topper-top.png"),
        bottom = love.graphics.newImage("resources/topper-bottom.png"),
        left = love.graphics.newImage("resources/topper-left.png"),
        right = love.graphics.newImage("resources/topper-right.png")
    }
    Texture.player = {
        idle = love.graphics.newImage("resources/player-idle.png"),
        walking = {
            love.graphics.newImage("resources/player-walking-1.png"),
            love.graphics.newImage("resources/player-walking-2.png")
        },
        jumpingFalling = love.graphics.newImage("resources/player-jumping-falling.png")
    }
    Texture.box = love.graphics.newImage("resources/box.png")
end