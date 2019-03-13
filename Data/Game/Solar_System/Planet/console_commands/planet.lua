return function(args)
  if #args < 5 then
    engine.log("Error: Insufficient arguments given.")
    engine.log("Usage: planet [STR type] [STR texture] [INT home_star] [INT parent_entity] [NUM radius]")
    return
  end
  if not tonumber(args[3]) or not tonumber(args[4]) or not tonumber(args[5]) then
    engine.log("Error: Incorrect arguments given.")
    engine.log("Usage: planet [STR type] [STR texture] [INT home_star] [INT parent_entity] [NUM radius]")
    return
  end
  local obj_type = args[1]
  local tex = args[2]
  local star = tonumber(args[3])
  local host = tonumber(args[4])
  local rad = tonumber(args[5])
  if obj_type == "moon" or obj_type == "-m" then
    game.ecs:add_entity(engine.entity.test_moon, tex, star, host, rad)
  else
    game.ecs:add_entity(engine.entity.test_planet, tex, star, host, rad)
  end
end