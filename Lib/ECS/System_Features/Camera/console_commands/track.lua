return function (args)
  if args == nil then
    engine.log("Error: Insufficient arguments provided.")
    engine.log("Usage: track [INT id]")
    return
  end
  if not tonumber(args[1]) then
    engine.log("Error: Arguments must be integers.")
    engine.log("Usage: track [INT id]")
    return
  end
  local num = tonumber(args[1])
  if num ~= 0 then
    local tgt = game.ecs.entity_list[num]
    if tgt == nil or tgt == "none" then
      engine.log("Error: Entity does not exist.")
      engine.log("Usage: track [INT valid_id]")
      return
    end
  end
  local cam = game.ui:find_child("main_camera")
  game.camera.track_target = num
end