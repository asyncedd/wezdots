local mocha = require("theme").catppuccin.mocha

local list = {
  { "🌸", mocha.pink },
  { "🧀", mocha.yellow },
  { "🍉", mocha.red },
  { "🍓", mocha.red },
  { "🍌", mocha.yellow },
  { "🍍", mocha.yellow },
  { "🍇", mocha.mauve },
  { "🍊", mocha.peach },
  { "🍎", mocha.red },
  { "🍒", mocha.red },
  { "🍑", mocha.pink },
  { "🥝", mocha.green },
  { "🍐", mocha.green },
  { "🍈", mocha.green },
  { "🍏", mocha.green },
  { "🍋", mocha.yellow },
  { "🍅", mocha.red },
  { "🥥", mocha.peach },
  { "🥭", mocha.peach },
  { "🌰", mocha.peach },
}

math.randomseed(os.time() * os.time() * os.time() * 213128414 - 123213)

-- Create a copy of the list
local shuffledList = {}
for i = 1, #list do
  shuffledList[i] = list[i]
end

-- Perform Fisher-Yates shuffle
for i = #shuffledList, 2, -1 do
  local j = math.random(i)
  shuffledList[i], shuffledList[j] = shuffledList[j], shuffledList[i]
end

return shuffledList
