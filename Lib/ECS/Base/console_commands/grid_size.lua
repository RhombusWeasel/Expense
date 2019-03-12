return function (args)
  if args == nil then
    engine.log("Error: Insufficient arguments provided.")
    engine.log("Usage: grid_size [INT size] or [STR operator]")
    return
  end
  if not tonumber(args[1]) then
    local operator = args[1]
    if operator == "double" then
      engine.hash_grid_size = engine.hash_grid_size * 2
    elseif operator == "half" then
      engine.hash_grid_size = engine.hash_grid_size * .5
    end
  else
    engine.hash_grid_size = tonumber(args[1])
  end
  engine.min_checks = math.huge
  engine.max_checks = 0
end