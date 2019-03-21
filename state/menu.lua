menu = {}

-- lib
local gamestate = require("lib.gamestate")
local helper = require("lib.helper")

-- states
game = game or require("state.game")
select_level = select_level or require("state.select_level")

local current_entry = 1
local entries = {
    {"Start", function() gamestate.switch(select_level) end},
    {"Options", function() gamestate.switch(options) end},
    {"Exit", function() love.event.quit() end}
}

-- menu
function menu:init()
    helper.setFont("ThaleahFat", 40)
end

function menu:keyreleased(key)
    if key == "up" then
        current_entry = current_entry == 1 and #entries or current_entry - 1
    elseif key == "down" then
        current_entry = current_entry == #entries and 1 or current_entry + 1
    elseif key == "return" then
        entries[current_entry][2]()
    end
end

function menu:draw()
    -- draw title
    helper.setFont("ThaleahFat", 100)
    love.graphics.setColor({255, 255, 255})
    love.graphics.printf("Snake", 0, 0, love.graphics.getWidth(), "center")

    -- draw entries
    helper.setFont("ThaleahFat", 80)
    for i, entry in ipairs(entries) do
        love.graphics.setColor(current_entry == i and {255, 255, 255} or  {255, 255, 255, 100})
        love.graphics.printf(entry[1], 0, 100+i*40, love.graphics.getWidth(), "center")
    end
end

return menu