return function(args)
  if #args < 3 then
    engine.log("Error: Insufficient arguments provided.")
    engine.log("Usage: spawn_star [type] [x_pos] [y_pos]")
    return
  end
  if not tonumber(args[2]) or not tonumber(args[3]) then
    engine.log("Error: Positional arguments must be numbers.")
    engine.log("Usage: spawn_star [type] [x_pos] [y_pos]")
    return
  end
  local star = args[1]
  local x = tonumber(args[2])
  local y = tonumber(args[3])
  game.ecs:add_entity(engine.entity[star], x, y)
end