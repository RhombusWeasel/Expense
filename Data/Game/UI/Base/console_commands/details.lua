return function(args)
  if #args < 1 then
    engine.log("Error: Insufficient arguments given.")
    engine.log("Usage: details [INT entity_id]")
    return
  end
  if not tonumber(args[1]) then
    engine.log("Error: Incorrect arguments given.")
    engine.log("Usage: details [INT entity_id]")
    return
  end
  eid = tonumber(args[1])
  local win = engine.prefab.entity_ui:new("entity_"..args[1], 0, 0, 395, 355, eid)
  game.ui:add(win)
end