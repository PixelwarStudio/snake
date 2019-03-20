local game_conf = require("game_conf")

function love.conf(t)
    t.window.title = "Snake"
    t.window.icon = nil
    t.window.width = game_conf.field.width * game_conf.field.cell_size
    t.window.height = game_conf.field.height * game_conf.field.cell_size
    t.window.borderless = false
    t.window.resizable = false
    t.window.minwidth = 1
    t.window.minheight = 1
end