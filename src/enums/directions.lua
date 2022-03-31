Directions = {
  LEFT = {
    x = -1,
    y = 0,
    name = "Left"
  },
  RIGHT = {
    x = 1,
    y = 0,
    name = "Right"
  },
  UP = {
    x = 0,
    y = -1,
    name = "Up"
  },
  DOWN = {
    x = 0,
    y = 1,
    name = "Down"
  }
}

-- Array contenente le varie direzioni (non e' ordinato come quello sopra)
DirectionsArray = {}
for k, v in pairs(Directions) do
  table.insert(DirectionsArray, v)
end

-- Table contenente le varie direzioni aventi come chiave i tasti assegnati
DirectionsKeyCode = {
  w = Directions.UP,
  up = Directions.UP,
  s = Directions.DOWN,
  down = Directions.DOWN,
  d = Directions.RIGHT,
  right = Directions.RIGHT,
  a = Directions.LEFT,
  left = Directions.LEFT,
}