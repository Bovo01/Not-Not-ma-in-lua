require("src/porta")
require("src/game")
require("src/solution")

function love.load()
  -- Setto un random skillato
  math.randomseed(os.time())
  -- Carico gli assets
  Game.load()

  -- Creo una istanza gioco
  g = Game:new {}
end

function love.update(dt) -- dt sta per delta time, ossia serve per non fare tutto basato sul framerate
  g:update(dt)
end

function love.draw()
  g:draw()
end

function love.keypressed(key, scancode, isrepeat)
  local dir = DirectionsKeyCode[key]
  g:move(dir)
end
