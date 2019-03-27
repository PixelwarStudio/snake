select_speed = {}

-- lib
local gamestate = require("lib.gamestate")
local helper = require("lib.helper")

local current_speed = 1

local selected_level
function select_speed:enter(last, level)
    selected_level = level
end

function select_speed:keyreleased(key)
    if key == "left" then
        current_speed = current_speed == 1 and 5 or current_speed - 1
    elseif key == "right" then
        current_speed = current_speed == 5 and 1 or current_speed + 1
    elseif key == "return" then
        gamestate.switch(game, selected_level, current_speed)
    elseif key == "escape" then
        gamestate.switch(menu)
    end
end

function select_speed:draw()
    love.graphics.setColor({255, 255, 255})

    helper.setFont("ThaleahFat", 100)
    love.graphics.printf("Select Speed", 0, 0, love.graphics.getWidth(), "center")

    helper.setFont("ThaleahFat", 300)
    love.graphics.printf(current_speed, 0, (love.graphics.getHeight()-300) / 2, love.graphics.getWidth(), "center")
end

return select_speed