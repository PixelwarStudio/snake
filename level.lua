-- conf
local gc = require("game_conf")

local level = {}

level.levels = {
    -- blank
    {},
    -- classic
    {
        {1, 1, gc.field.width, gc.field.height}
    },
    -- pong
    {
        {math.floor(gc.field.width / 2), math.floor(2*gc.field.height / 3)},
        {1, 1, 1, math.floor(gc.field.height / 3)},
        {gc.field.width, math.floor(2*gc.field.height / 3), 1, math.floor(gc.field.height / 3)}
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
            end
            
            for i=1, w-2, 1 do
                table.insert(points, {x+i, y})
                table.insert(points, {x+i, y+h-1})
            end
        end
    end

    return points
end

function level.draw(l, start_x, start_y, cell_size)
    for _, obj in ipairs(l) do
        -- point
        if #obj == 2 then
            local x, y = obj[1], obj[2]

            love.graphics.rectangle("fill", start_x + (x-1)*cell_size, start_y + (y-1)*cell_size, cell_size, cell_size)
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