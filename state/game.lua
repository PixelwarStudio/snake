local game = {}

-- lib
local gamestate = require("lib.gamestate")
local timer = require("lib.timer")
local direction = require("lib.direction")
local helper = require("lib.helper")

-- state 
local gameover = require("state.gameover")

-- entities
local field = {}
local snake = {}
local snack = {}
local score = {}

--- field
function field.init(width, height, cell_size)
    field.width = width
    field.height = height
    field.cell_size = cell_size
end

function field.get_free_cells()
    local free_cells = {}

    for x=1, field.width do
        for y=1, field.height do
            for _, val in ipairs(snake.body) do
                if val[1] ~= x or val[2] ~= y then
                    table.insert(free_cells, {x, y})
                end
            end
        end
    end

    return free_cells
end

--- snake
function snake.init(x, y, speed)
    snake.x = x
    snake.y = y
    snake.speed = speed

    snake.segments = {
        {dir = direction.right, length = 2}
    }

    snake.body = snake.render() 

    snake.timer = timer.new()
    snake.timer:every(0.1, snake.update)
end

function snake.change_dir(newDir)
    local dir = direction[newDir]
    local segments = snake.segments
    local head = segments[1]

    if not direction.is_same_axis(head.dir, dir) and head.length > 0 then
        table.insert(segments, 1, {dir = direction.turn(dir, 2), length = 0})
    end
end 

function snake.crawl()
    local segments = snake.segments

    -- increase head part by one
    segments[1].length = segments[1].length + 1

    -- decrease tail part by one 
    segments[#segments].length = segments[#segments].length - 1

    -- remove tail part if necessary
    if segments[#segments].length == 0 then
        table.remove(segments)
    end

    local dir = segments[1].dir
    local inc = direction.get_increment(dir)

    if dir == direction.left or dir == direction.right then
        snake.x = 1 + (snake.x - inc - 1) % field.width
    else
        snake.y = 1 + (snake.y - inc - 1) % field.height
    end
end

function snake.render()
    local x, y = snake.x, snake.y
    local w, h = field.width, field.height
    local segments = snake.segments
    local body = {}

    for _, segment in ipairs(segments) do
        local dir = segment.dir
        local inc = direction.get_increment(dir)

        for i=1, segment.length do
            if dir == direction.left or dir == direction.right then
                table.insert(body, {1 + (x + inc*i - 1) % field.width, y})
            else
                table.insert(body, {x, 1 + (y + inc*i - 1) % field.height})
            end
        end

        if dir == direction.left or dir == direction.right then
            x = 1 + (x + inc*segment.length - 1) % field.width
        else
            y = 1 + (y + inc*segment.length - 1) % field.height
        end
    end

    return body
end

function snake.is_biting()
    local body = snake.body

    for i=1, #body-1 do
        for j=i+1,#body do
            if body[i][1] == body[j][1] and body[i][2] == body[j][2] then
                return true
            end
        end
    end
    
    return false
end

function snake.found_snack()
    for _, coor in ipairs(snake.body)  do
        if coor[1] == snack.x and coor[2] == snack.y then
            return true
        end
    end

    return false
end

function snake.update()
    local segments = snake.segments

    snake.crawl()
    snake.body = snake.render()

    if snake.is_biting() then
        timer.cancel(snake.timer)
        gamestate.switch(gameover, score.value)
    end

    if snake.found_snack() then
        score.value = score.value + 1
        score.opacity = 255
        score.timer:tween(0.5, score, {opacity = 0}, "quart")

        snack.respawn()

        segments[#segments].length = segments[#segments].length + 1
    end
end

function snake.draw()
    local body = snake.body

    for i=1, #body do
        local x, y = body[i][1], body[i][2]

        love.graphics.setColor({255, 255, 255})
        love.graphics.rectangle("fill", (x-1)*field.cell_size, (y-1)*field.cell_size, field.cell_size, field.cell_size)
    end
end

--- snack
function snack.respawn()
    local free_cells = field.get_free_cells()

    snack.x, snack.y = unpack(free_cells[love.math.random(1, #free_cells)])
    snack.color = {love.math.random(), love.math.random(), love.math.random()}
end

function snack.draw()
    love.graphics.setColor({255, 255, 255})
    love.graphics.circle("fill", (snack.x-0.5)*field.cell_size, (snack.y-0.5)*field.cell_size, field.cell_size/2)
end

--- score
function score.init()
    score.value = 0
    score.opacity = 0

    score.timer = timer.new()
end

function score.draw()
    love.graphics.setColor({255, 255, 255, score.opacity})
    love.graphics.printf(score.value, 0, (love.graphics.getHeight() - love.graphics.getFont():getHeight()) / 2, love.graphics.getWidth(), "center")
end

-- game
function game:init()
    helper.setFont("ThaleahFat", 16*15)
    field.init(23, 15, 40)
end

function game:enter()
    score.init()
    snake.init(15, 7)
    snack.respawn()
end

function game:update(dt)
    for i, key in pairs({"left", "right", "up", "down"}) do
        if love.keyboard.isDown(key) then
            snake.change_dir(key)
        end
    end

    -- update timers
    snake.timer:update(dt)
    score.timer:update(dt)
end

function game:draw()
    for _, entity in pairs({snack, snake, score}) do
        entity.draw()
    end
end

return game