-- conf
local game_conf = require("game_conf")

local level = {}

level.levels = {
    blank = {},
    rectangle = {
        {1, 1, game_conf.field.width, game_conf.field.height}
    }
}

function level.get_points(l)
end

function level.draw(l, x, y, cell_size)
    for _, obj in ipairs(l) do
        -- point
        if #obj == 2 then
            local x, y = obj[1], obj[2]
            love.graphics.rectangle("fill", (x-1)*game_conf.field.cell_size, (y-1)*game_conf.field.cell_size, game_conf.field.cell_size, game_conf.field.cell_size)

        -- rectangle
        elseif #obj == 4 then
        end

    end
end