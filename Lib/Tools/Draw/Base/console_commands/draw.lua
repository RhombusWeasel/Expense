return function(args)
  local file
  local w, h = engine.vars.draw.default_width, engine.vars.draw.default_height
  if args[1] == nil then
    engine.log("ERROR: Insufficient arguments given.")
    engine.log("USAGE: draw [STR: filename] [OPT:INT: width] [OPT:INT height]")
    return
  end
  if #args == 2 then
    if tonumber(args[2]) then
      w = math.floor(tonumber(args[2]))
      h = math.floor(tonumber(args[2]))
    else
      engine.log("ERROR: Incorrect arguments given, optional arguments must be integers")
      engine.log("USAGE: draw [STR: filename] [OPT:INT: width] [OPT:INT height]")
      return
    end
  elseif #args == 3 then
    if tonumber(args[3]) then
      w = math.floor(tonumber(args[2]))
      h = math.floor(tonumber(args[3]))
    else
      engine.log("ERROR: Incorrect arguments given, optional arguments must be integers")
      engine.log("USAGE: draw [STR: filename] [OPT:INT: width] [OPT:INT height]")
      return
    end
  end
  engine.debug_ui:add(engine.prefab.draw_window:new(args[1], 0, 0, 800, 600, args[1], w, h), #engine.debug_ui.objects + 1)
end