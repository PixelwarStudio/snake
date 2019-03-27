-- conf
local gc = require("game_conf")

local level = {}

level.levels = {
    -- blank
    {},
    -- classic
    {
        {1, 1, gc.field.width, gc.field.height}
    }
}

function level.get_cells(l)
    local points = {}

    for _, obj in ipairs(l) do
        -- point
        if #obj == 2 then
            table.insert(points, obj)
        -- reactangle
        elseif #obj == 4 then
            local x, y, w, h = obj[1], obj[2], obj[3], obj[4]

            for i=0, h-1, 1 do
                table.insert(points, {x, y+i})
                table.insert(points, {x+w-1, y+i})

                print(x, y+i, x+w-1, y+i)
            end
            
            for i=1, w-2, 1 do
                table.insert(points, {x+i, y})
                table.insert(points, {x+i, y+h-1})

                print(x+i, y, x+i, y+h-1)
            end
        end
    end

    return points
end

function level.draw(l, start_x, start_y, cell_size)
    for _, obj in ipairs(l) do
        -- point
        if #obj == 2 then
            love.graphics.rectangle("fill", start_x + (obj[1]-1)*cell_size, start_y + (obj[2]-1)*cell_size, cell_size, cell_size)
        -- rectangle
        elseif #obj == 4 then
            local x, y, w, h = obj[1], obj[2], obj[3], obj[4]

            love.graphics.rectangle("fill", start_x + (x-1)*cell_size, start_y + (y-1)*cell_size, cell_size, cell_size*h)
            love.graphics.rectangle("fill", start_x + (x+w-2)*cell_size, start_y + (y-1)*cell_size, cell_size, cell_size*h)
            love.graphics.rectangle("fill", start_x + x*cell_size, start_y + (y-1)*cell_size, cell_size*(w-2), cell_size)
            love.graphics.rectangle("fill", start_x + x*cell_size, start_y + (y+h-2)*cell_size, cell_size*(w-2), cell_size)
        end
    end
end

return level