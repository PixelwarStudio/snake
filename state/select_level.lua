select_level = {}

-- lib
local gamestate = require("lib.gamestate")
local helper = require("lib.helper")

-- state
select_speed = select_speed or require("state.select_speed")
menu = menu or require("state.menu")

-- game config
local gc = require("game_conf")

-- load level
local level = require("level")

local current_level = 1
local width = love.graphics.getWidth()
local height = love.graphics.getHeight()

function select_level:keyreleased(key)
    if key == "left" then
        current_level = current_level == 1 and #level.levels or current_level - 1
    elseif key == "right" then
        current_level = current_level == #level.levels and 1 or current_level + 1
    elseif key == "return" then
        gamestate.switch(select_speed, current_level)
    elseif key == "escape" then
        gamestate.switch(menu)
    end
end

function select_level:draw()
    love.graphics.setColor({255, 255, 255})

    helper.setFont("ThaleahFat", 100)
    love.graphics.printf("Select Level", 0, 0, width, "center")

    love.graphics.rectangle("line", (width-gc.field.width*20) / 2, (height-gc.field.height*20) / 2, gc.field.width*20, gc.field.height*20)
    level.draw(level.levels[current_level], (width-gc.field.width*20) / 2, (height-gc.field.height*20) / 2, 20)
end


return select_level