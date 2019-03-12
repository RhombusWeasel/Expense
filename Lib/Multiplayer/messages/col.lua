return function(args)
  if #args < 3 then
    engine.log("ERROR: Insufficient arguments provided to /col")
    return
  elseif not tonumber(args[1]) or not tonumber(args[2]) or not tonumber(args[3]) then
    engine.log("ERROR: Incorrect arguments provided to /col")
    return
  end
  local r = tonumber(args[1])
  local g = tonumber(args[2])
  local b = tonumber(args[3])
  if r > 1 then r = r / 255 end
  if g > 1 then g = g / 255 end
  if b > 1 then b = b / 255 end
  engine.token.auth.colour = {r, g, b, 1}
  engine.system.save(engine.token.auth, "/Mods/Base/MP/token", "auth")
end