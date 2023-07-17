local mocha = require("theme").catppuccin.mocha

local list = {
  { "🌸", bg = mocha.pink },
  { "🧀", bg = mocha.yellow },
  { "🍉", bg = mocha.red },
  { "🍓", bg = mocha.red },
  -- { "🍌", bg = mocha.yellow },
  { "🍍", bg = mocha.yellow },
  { "🍇", bg = mocha.mauve },
  { "🍊", bg = mocha.peach },
  { "🍎", bg = mocha.red },
  { "🍒", bg = mocha.red },
  -- { "🍑", bg = mocha.pink },
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

local shuffledList = {}
table.move(list, 1, #list, 1, shuffledList)

math.randomseed(os.time())

for i = #shuffledList, 2, -1 do
  local j = math.random(i)
  shuffledList[i], shuffledList[j] = shuffledList[j], shuffledList[i]
end

return shuffledList
