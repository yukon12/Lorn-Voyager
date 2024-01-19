Animation = {nil}

-- Loads Animation module.
function Animation.load()
    Animation.frame = 1
    Timer.addRepeating("animation", 0.1, function()
        Animation.frame = (Animation.frame%2)+1
        if Player.checkState("walking") then
            Player.texture = Texture.player.walking[Animation.frame]
        end
        Crabs.texture = Texture.crab[Animation.frame]
    end)
end