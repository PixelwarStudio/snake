local helper = {}

function helper.setFont(name, size)
    love.graphics.setFont(love.graphics.newFont("font/" .. name .. ".ttf", size))
end

return helper