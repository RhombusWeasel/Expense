return function (args)
  if args[1] == nil then
    engine.log("ERROR: Insufficient arguments provided")
    engine.log("USAGE: mkdir [STR path]")
    return
  end
  local path = engine.current_path.."/"..args[1]
  local data = love.filesystem.getInfo(path)
  if data then
    engine.log("ERROR: Filepath already exists.")
    engine.log("USAGE: mkdir [STR path]")
    return
  else
    love.filesystem.createDirectory(path)
    engine.log(path.." created.")
  end
end