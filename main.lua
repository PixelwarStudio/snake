-- lib
local gamestate = require("lib.gamestate")

-- states
local menu = require("state.menu")
local game = require("state.game")
local gameover = require("state.gameover")

function love.load()
    gamestate.registerEvents()
    gamestate.switch(menu)
end