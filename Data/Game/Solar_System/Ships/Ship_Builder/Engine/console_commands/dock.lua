return function(args)
  if #args < 2 then
    engine.log("Error: Insufficient arguments provided.")
    engine.log("Usage: move [INT ent_id] [INT target_id]")
    return
  end
  if not tonumber(args[1]) or not tonumber(args[2]) then
    engine.log("Error: Arguments must be integers.")
    engine.log("Usage: move [INT ent_id] [INT target_id]")
    return
  end
  local ent = game.ecs:get_entity(tonumber(args[1]))
  local tgt = game.ecs:get_entity(tonumber(args[2]))
  engine.log("Docking Entity "..ent.id.." at "..tgt.id..".")
  engine.commands.set_target(ent, tgt.id)
end