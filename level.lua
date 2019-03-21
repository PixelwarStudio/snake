-- conf
local gc = require("game_conf")

local level = {}

level.levels = {
    -- blank
    {},
    -- classic
    {
        {0, 0, gc.field.width, gc.field.height}
    }
}

function level.get_points(l)
end

function level.draw(l, start_x, start_y, cell_size)
    for _, obj in ipairs(l) do
        -- point
        if #obj == 2 then
            love.graphics.rectangle("fill", start_x + (obj[1]-1)*cell_size, start_y + (obj[2]-1)*cell_size, game_conf.field.cell_size, game_conf.field.cell_size)
        -- rectangle
        elseif #obj == 4 then
            local x, y, w, h = obj[1], obj[2], obj[3], obj[4]

            love.graphics.rectangle("fill", start_x + x*cell_size, start_y + y*cell_size, cell_size, cell_size*h)
            love.graphics.rectangle("fill", start_x + (x+w-1)*cell_size, start_y + y*cell_size, cell_size, cell_size*h)
            love.graphics.rectangle("fill", start_x + (x+1)*cell_size, start_y + y*cell_size, cell_size*(w-1), cell_size)
            love.graphics.rectangle("fill", start_x + (x+1)*cell_size, start_y + (y+h-1)*cell_size, cell_size*(w-1), cell_size)
        end
    end
end

return level