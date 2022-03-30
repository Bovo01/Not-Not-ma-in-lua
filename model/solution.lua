-- Creo l'istanza della classe
Solution = {}

-- Creo il prototype (oggetto che contiene proprietà e metodi di una nuova istanza)
Solution.prototype = {
  direction = nil,
  color = Colors.WHITE,
  nots = 0
}

-- Creazione di una nuova istanza 'Solution'
function Solution:new(solution)
  solution = solution or {}
  setmetatable(
    solution,
    {
      __index = self.prototype
    }
  )
  return solution
end

function Solution.generateSolution(difficulty)
  difficulty = difficulty or Difficulties.EASY -- Valore default se non viene inserito niente
  local direction = DirectionsArray[math.random(#DirectionsArray)]
  local nots = math.random(0, difficulty)
  print(direction.x, direction.y)

  return Solution:new {direction = direction, nots = nots}
end

function Solution.prototype.toString(self)
  return string.rep("Not ", self.nots) .. self.direction.name
end
