local gameover = {}

function gameover:enter(last, score)
    gameover.score = score
end

function gameover:draw()
    love.graphics.setColor({255, 255, 255})
    love.graphics.print(gameover.score)
end

return gameover