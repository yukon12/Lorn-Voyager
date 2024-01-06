require "source.constants"

-- Configuration.
function love.conf(t)
	t.window.title = TITLE
	t.window.width = WINDOW_WIDTH
	t.window.height = WINDOW_HEIGHT
	t.console = false
end
