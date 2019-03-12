return function (args)
  if args[1] == ".." then
    engine.current_path = engine.path.back()
  else
    engine.current_path = engine.current_path.."/"..args[1]
  end
end