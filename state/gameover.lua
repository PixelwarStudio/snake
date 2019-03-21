gameover = {}

local final_score
function gameover:enter(last, score)
    final_score = score
end

function gameover:draw()
    love.graphics.setColor({255, 255, 255})
    love.graphics.print(final_score)
end

return gameover