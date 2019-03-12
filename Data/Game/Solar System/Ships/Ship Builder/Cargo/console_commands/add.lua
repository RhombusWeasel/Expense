return function (args)
  if #args < 4 then
    engine.log("Insufficient arguments provided:")
    engine.log("Usage: add [INT ent_id] [STR item] [INT amount] [INT price]")
    return
  end
  if not engine.recipes[args[2]] then
    engine.log("Incorrect item provided:")
    engine.log("Usage: add [INT ent_id] [STR item] [INT amount] [INT price]")
    return
  end
  if not tonumber(args[1]) or not tonumber(args[3]) or not tonumber(args[4]) then
    engine.log("Incorrect arguments provided:")
    engine.log("Usage: add [INT ent_id] [STR item] [INT amount] [INT price]")
    return
  end
  local ent = game.ecs:get_entity(tonumber(args[1]))
  if ent.class ~= "ship" then
    engine.log("Incorrect arguments provided:")
    engine.log("Usage: add [INT ship_id] [STR item] [INT amount] [INT price]")
  end
  engine.commands.add_item(ent, args[2], tonumber(args[3]), tonumber(args[4]))
end