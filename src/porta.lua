require("model/enums/directions")
require("model/enums/colors")
require("model/enums/difficulties")

-- Creo l'istanza della classe
Porta = {}

-- Creo il prototype (oggetto che contiene proprietà e metodi di una nuova istanza)
Porta.prototype = {
  direction = nil,
  color = Colors.WHITE
}

-- Creazione di una nuova istanza 'Porta'
function Porta:new(porta)
  porta = porta or {}
  setmetatable(
    porta,
    {
      __index = self.prototype
    }
  )
  Porta.initializeDimensions(porta)
  return porta
end

-- Dalla classe inizializza la width e height dell'oggetto 'porta'
function Porta.initializeDimensions(porta)
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()
  if porta.direction == Directions.UP or porta.direction == Directions.DOWN then
    porta.w = math.min(width, height) / 10
    porta.h = math.min(width, height) / 20
  else
    porta.w = math.min(width, height) / 20
    porta.h = math.min(width, height) / 10
  end
end

-- Disegno la porta nello schermo
function Porta.prototype.draw(self, centerDistance)
  local x = centerDistance * self.direction.x - self.w / 2
  local y = centerDistance * self.direction.y - self.h / 2
  love.graphics.setColor(self.color)
  love.graphics.rectangle("fill", x, y, self.w, self.h)
end