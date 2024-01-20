Sound = {nil}

-- Loads Sound module.
function Sound.load()
    Sound.shoot = love.audio.newSource("resources/shoot.wav", "static")
    Sound.hurt = love.audio.newSource("resources/hurt.wav", "static")
    Sound.crab = love.audio.newSource("resources/crab.wav", "static")
    Sound.jump = love.audio.newSource("resources/jump.wav", "static")
end