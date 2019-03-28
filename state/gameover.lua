gameover = {}

-- lib
local gamestate = require("lib.gamestate")
local helper = require("lib.helper")

-- state
menu = menu or require("state.menu")
game = game or require("state.game")

local current_entry = 1
local entries = {
    {"Retry", function() gamestate.switch(game, selected_level, selected_speed) end},
    {"Menu", function() gamestate.switch(menu) end}
}

local final_score
function gameover:enter(last, score, level, speed)
    final_score = score
    selected_level = level
    selected_speed = speed
end

function gameover:keyreleased(key)
    if key == "up" then
        current_entry = current_entry == 1 and #entries or current_entry - 1
    elseif key == "down" then
        current_entry = current_entry == #entries and 1 or current_entry + 1
    elseif key == "return" then
        entries[current_entry][2]()
    end
end

function gameover:draw()
    helper.setFont("ThaleahFat", 150)
    love.graphics.setColor({255, 255, 255})
    love.graphics.printf("Score: " .. final_score, 0, 0, love.graphics.getWidth(), "center")

    helper.setFont("ThaleahFat", 80)
    for i, entry in ipairs(entries) do
        love.graphics.setColor(current_entry == i and {255, 255, 255} or  {255, 255, 255, 100})
        love.graphics.printf(entry[1], 0, 100+i*40, love.graphics.getWidth(), "center")
    end
end

return gameover