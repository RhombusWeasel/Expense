return function()
  local version = 0.1
  local save_dir = love.filesystem.getSaveDirectory()
  local file = love.filesystem.newFile("/Debug/stdout.txt", "w")
  engine.log("Console version "..version)
end