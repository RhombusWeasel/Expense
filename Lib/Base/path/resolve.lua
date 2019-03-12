return function (path_str)
  local names = engine.string.split_code(path_str)
  local path = ""
  for i = 1, #names - 3 do
    path = path..names[i]
    if names[i] == "/" then
      if not love.filesystem.getInfo(path) then
        love.filesystem.createDirectory(path)
      end
    end
  end
  local file = love.filesystem.newFile(path_str, "w")
end