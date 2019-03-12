return function(args)
  if args[1] == nil then
    engine.log("ERROR: Insufficient arguments provided.")
    engine.log("USAGE: rm [STR filepath]")
    return
  end
  local path = engine.current_path.."/"..args[1]
  local data = love.filesystem.getInfo(path)
  if data then
    love.filesystem.remove(path)
  else
    engine.log("ERROR: Incorrect arguments provided.  The filepath does not exist.")
    engine.log("USAGE: rm [STR filepath]")
    return
  end
end