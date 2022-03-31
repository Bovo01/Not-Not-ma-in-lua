-- Creo l'istanza della classe
Game = {}

-- Creo il prototype (oggetto che contiene proprietà e metodi di una nuova istanza)
Game.prototype = {
  porte = {},
  solution = nil,
  difficulty = Difficulties.EASY
}

-- Creazione di una nuova istanza 'Game'
function Game:new(game)
  game = game or {}
  setmetatable(
    game,
    {
      __index = self.prototype
    }
  )
  Game.initialize(game)
  return game
end

-- Carica in modo statico gli assets (va chiamato in love.load)
function Game.load()
  -- Carico l'immagine del player
  Game.playerImage = love.graphics.newImage("assets/player.jpg")
  -- Carico l'audio
  Game.audio = {}
  for i = 1, 4 do
    Game.audio[i] = love.audio.newSource("assets/audio/player/" .. i .. ".wav", "static")
  end
end

-- Esegue un audio casuale tra quelli caricati
function Game.playAudio()
  local audio = Game.audio[math.random(1, #Game.audio)]
  audio:play()
end

-- Dalla classe inizializza l'oggetto 'game'
function Game.initialize(game)
  -- Imposto la posizione che occupera' nello schermo
  Game.setPosition(game)
  -- Creo le porte
  local i = 0
  for k, v in pairs(Directions) do
    game.porte[i] = Porta:new {direction = v}
    i = i + 1
  end
  -- Creo la soluzione iniziale
  game:getSolution()
  -- Inizializzo un font per il testo
  game.font = love.graphics.setNewFont(game.dim / 10)
  -- Inizializzo il punteggio a 0
  game.score = 0
  -- Inizializzo l'animazione (come ferma)
  game.animation = {animating = false, duration = 2, currentFrame = 0, direction = nil}
  game.animation.speed = game.dim / 2 / game.animation.duration
end

function Game.prototype.update(self, dt)
  if self.animation.animating then
    self.animation.currentFrame = self.animation.currentFrame + self.animation.speed * dt
    -- Controllo se l'animazione è finita
    if self.animation.currentFrame >= self.dim / 2 then
      -- Fine dell'animazione, controllo se la porta è corretta
      local porta = self:getPorta(self.animation.direction)
      if not self:checkSolution(porta) then
        self:gameOver()
      else
        self.score = self.score + 1
        self.solution = Solution.generateSolution(self.difficulty)
        -- Ripristino l'animazione
        self.animation.animating = false
        self.animation.currentFrame = 0
        self.animation.direction = nil
      end
    end
  end
end

-- Imposta la posizione che 'game' occupera' nello schermo'
function Game.setPosition(game)
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()
  local off = math.min(width, height) / 10
  game.dim = math.min(width, height) - off
end

-- Ottiene una soluzione casuale e la imposta come quella attuale
function Game.prototype.getSolution(self)
  self.solution = Solution.generateSolution(self.difficulty)
end

-- Disegna il gioco su schermo
function Game.prototype.draw(self)
  -- Sposto il pivot al centro dello schermo
  love.graphics.translate(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
  -- Disegno il campo di gioco
  love.graphics.setColor(Colors.BACKGROUND)
  love.graphics.rectangle("fill", -self.dim / 2, -self.dim / 2, self.dim, self.dim, self.dim / 10)
  -- Disegno il player
  self:drawPlayer()
  -- Disegno le porte
  for k, p in pairs(self.porte) do
    p:draw(self.dim / 2)
  end
  -- Disegno la soluzione al centro
  self:drawSolution()
  -- Disegno il punteggio da qualche parte
  self:drawScore()
end

-- Disegno il player al centro dello schermo
function Game.prototype.drawPlayer(self)
  local scaleX = self.dim / Game.playerImage:getWidth() / 10
  local scaleY = self.dim / Game.playerImage:getHeight() / 10
  local idleDirection = {x = 0, y = 0}
  local x =
    self.animation.currentFrame * (self.animation.direction or idleDirection).x
  local y =
    self.animation.currentFrame * (self.animation.direction or idleDirection).y
  love.graphics.draw(
    Game.playerImage,
    -Game.playerImage:getWidth() * scaleX / 2 + x,
    -Game.playerImage:getHeight() * scaleY / 2 + y,
    0,
    scaleX,
    scaleY
  )
end

-- Disegna il punteggio da qualche parte
function Game.prototype.drawScore(self)
  love.graphics.translate(love.graphics.getWidth() / 2 - 20, -love.graphics.getHeight() / 2 + 20)
  love.graphics.setColor(Colors.WHITE)
  love.graphics.printf(
    self.score,
    -self.font:getWidth(self.score) / 2,
    self.font:getHeight(self.score) / 2,
    self.font:getWidth(self.score),
    "center"
  )
end

-- Disegna il testo della soluzione al centro dello schermo
function Game.prototype.drawSolution(self)
  love.graphics.setColor(Colors.WHITE)
  local text = self.solution:toString()
  local wraps = self.solution.nots + 1
  local longerWord = getLongerWord(text)
  love.graphics.printf(
    text,
    -self.font:getWidth(longerWord) / 2,
    -self.font:getHeight(text) * wraps / 2,
    self.font:getWidth(longerWord),
    "center"
  )
end

-- Gestione del movimento in una direzione (in base al valore della soluzione)
function Game.prototype.move(self, direction)
  if self.animation.animating then return end
  self.animation.animating = true
  self.animation.direction = direction
  Game.playAudio()
end

-- Ottengo la porta data la direzione
function Game.prototype.getPorta(self, direction)
  for k, p in pairs(self.porte) do
    if p.direction == direction then
      return p
    end
  end
end

-- Controlla se la direzione e' valida in base alla soluzione
function Game.prototype.checkSolution(self, porta)
  -- Controllo se devo guardare la porta corretta o tutte le altre
  if self.solution.nots % 2 == 0 then
    return porta.direction == self.solution.direction
  else
    return porta.direction ~= self.solution.direction
  end
end

function Game.prototype.gameOver(self)
  print("Punteggio finale: " .. self.score)
  error("Game Over")
end

-- Ritorna la parola più lunga nella string 'str'
function getLongerWord(str)
  local longer = ""
  for w in string.gmatch(str, "%a+") do
    if #w > #longer then
      longer = w
    end
  end
  return longer
end
