local mocha = require("theme").catppuccin.mocha

local list = {
  { "🌸", bg = mocha.pink },
  { "🧀", bg = mocha.yellow },
  { "🍉", bg = mocha.red },
  { "🍓", bg = mocha.red },
  { "🍌", bg = mocha.yellow },
  { "🍍", bg = mocha.yellow },
  { "🍇", bg = mocha.mauve },
  { "🍊", bg = mocha.peach },
  { "🍎", bg = mocha.red },
  { "🍒", bg = mocha.red },
  { "🍑", bg = mocha.pink },
  { "🥝", bg = mocha.green },
  { "🍐", bg = mocha.green },
  { "🍈", bg = mocha.green },
  { "🍏", bg = mocha.green },
  { "🍋", bg = mocha.yellow },
  { "🍅", bg = mocha.red },
  { "🥥", bg = mocha.peach },
  { "🥭", bg = mocha.peach },
  { "🌰", bg = mocha.peach },
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
