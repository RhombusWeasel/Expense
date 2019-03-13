--[[Spawn and Asteroid Belt:
  Pass star_id as the target system.
  Pass radius as the distance from the star.
  Pass max_entities as the max asteroids in this belt.
]]
return function(args)
  if #args < 3 then
    engine.log("Error: Insufficient arguments provided.")
    engine.log("Usage: asteroids [INT star_id] [INT radius] [INT max_entities]")
    return
  end
  if not tonumber(args[1]) or not tonumber(args[2]) or not tonumber(args[3]) then
    engine.log("Error: Incorrect arguments given.")
    engine.log("Usage: asteroids [INT star_id] [INT radius] [INT max_entities]")
    return
  end
  
  local ores = {}
  for k, v in pairs(engine.ores) do
    table.insert(ores, k)
  end
  
  local star = tonumber(args[1])
  local rad = tonumber(args[2])
  local max = tonumber(args[3])
  for i = 1, max do
    local r = math.floor(love.math.random(1, #ores))
    local amt = love.math.random(5, 50) * 1000
    local flux = rad * 0.05
    local r_mod = love.math.random(-flux, flux)
    local id = game.ecs:add_entity(engine.entity.asteroid, star, rad + r_mod, ores[r], amt)
  end
end