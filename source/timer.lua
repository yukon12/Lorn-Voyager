Timer = {nil}

-- Loads Timer module.
function Timer.load()
    Timer.time = 0
    Timer.stack = {nil}
end

-- Adds function that will be repeated with frequency specified by the interval.
function Timer.addRepeating(name, interval, callback)
    Timer.stack[name] = {
        type = "repeating",
        time = Timer.time,
        interval = interval,
        callback = callback
    }
end

-- Executes given element.
function Timer.handleElement(element)
    if element.type == "repeating" then
        if Timer.time - element.time > element.interval then
            element.time = element.time + element.interval
            element.callback()
        end
        return
    end
end

-- Timer module's update function.
function Timer.update(dt)
    Timer.time = Timer.time + dt

    for i, element in pairs(Timer.stack) do
        Timer.handleElement(element)
    end
end