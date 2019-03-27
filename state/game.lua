game = {}

-- lib
local gamestate = require("lib.gamestate")
local timer = require("lib.timer")
local direction = require("lib.direction")
local helper = require("lib.helper")

-- level
local level = require("level")

-- game config
local gc = require("game_conf")

-- state
gameover = gameover or require("state.gameover")

-- entities
local field = {}
local snake = {}
local snack = {}
local score = {}

--- field
function field.init(width, height, cell_size, selected_level)
    field.width = width
    field.height = height
    field.cell_size = cell_size
    field.level = level.levels[selected_level]
    field.obstacles = level.get_cells(field.level)
end

function field.get_free_cells()
    local free_cells = {}
    local obstacles = field.obstacles

    for x=1, field.width do
        for y=1, field.height do
            local free = true

            -- check for snake
            for _, val in ipairs(snake.body) do
                if val[1] == x and val[2] == y then
                    free = false
                    break
                end
            end
            
            -- 
            for _, cell in ipairs(obstacles) do
                if cell[1] == x and cell[2] == y then
                    free = false
                    break
                end
            end

            if free then
                table.insert(free_cells, {x, y})
            end
        end
    end

    return free_cells
end

function field.draw()
    love.graphics.setColor({255, 255, 255})
    level.draw(field.level, 0, 0, field.cell_size)
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
    snake.timer:every(0.05 + 0.03*(5-speed), snake.update)
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
    local x, y, w, h = snake.x, snake.y, field.width, field.height
    local segments = snake.segments
    local body = {}

    for _, segment in ipairs(segments) do
        local dir = segment.dir
        local inc = direction.get_increment(dir)

        for i=0, segment.length-1 do
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

function snake.is_crashing()
    local body = snake.body
    local x, y = snake.x, snake.y

    -- snake bits itself?
    for i, cell in ipairs(body) do
        if i ~= 1 then 
            if x == cell[1] and y == cell[2] then
                return true
            end
        end
    end

    -- snake crashes into obstacle?
    for _, cell in ipairs(field.obstacles) do
        if x == cell[1] and y == cell[2] then
            return true
        end
    end

    return false
end

function snake.found_snack()
    for _, cell in ipairs(snake.body)  do
        if snack.x == cell[1] and snack.y == cell[2] then 
            return true
        end
    end

    return false
end

function snake.update()
    local segments = snake.segments

    snake.crawl()
    snake.body = snake.render()

    if snake.is_crashing() then
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

        love.graphics.setColor({255, 255, 255, 255 - 200*(i-1)/#body})
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
end

function game:enter(last, selected_level, selected_speed)
    field.init(gc.field.width, gc.field.height, gc.field.cell_size, selected_level)
    score.init()
    snake.init(math.floor(gc.field.width / 2), math.floor(gc.field.height / 2), selected_speed)
    snack.respawn()
end

function game:update(dt)
    for _, key in pairs({"left", "right", "up", "down"}) do
        if love.keyboard.isDown(key) then
            snake.change_dir(key)
        end
    end

    -- update timers
    snake.timer:update(dt)
    score.timer:update(dt)
end

function game:draw()
    for _, entity in pairs({field, snack, snake, score}) do
        entity.draw()
    end
end

return game