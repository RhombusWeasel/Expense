return function (args)
  if args == nil then
    engine.log("Error: Insufficient arguments provided.")
    engine.log("Usage: get_mouse_coords [INT x] [INT y]")
    return
  end
  if not tonumber(args[1]) or not tonumber(args[2]) then
    engine.log("Error: Arguments must be integers.")
    engine.log("Usage: get_mouse_coords [INT x] [INT y]")
    return
  end
  local cam = engine.state[engine.current_state].ui:find_child("main_camera")
  local mx, my = cam:get_mouse_position(tonumber(args[1]), tonumber(args[2]))
  local mox = engine.string.r_pad(args[1], 5, " ")
  local moy = engine.string.r_pad(args[2], 5, " ")
  engine.log("X: "..mox.." Map X: "..mx)
  engine.log("Y: "..moy.." Map Y: "..my)
end