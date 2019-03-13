local planet_choice = {
    {"rock", "magma"},
    {"rock", "magma"},
    {"rock", "earth", "water"},
    {"rock", "desert", "water"},
    {"rock", "ice"},
    {"rock", "ice"},
    {"rock", "ice", "gas"},
    {"rock", "ice", "gas"},
    {"rock", "ice"},
  }

local function random_name()
  local st_tab = {
    "KBX",
    "WDF",
    "RDF",
    "NST",
    "KBN"
  }
  local sel = love.math.random(1, #st_tab)
  local num = tostring(love.math.random(1, 9))
  return st_tab[sel]..num
end

return function(args)
  if #args < 2 then
    engine.log("Error: Insufficient arguments provided.")
    engine.log("Usage: star_system [INT x_pos] [INT y_pos]")
    return
  end
  if not tonumber(args[1]) or not tonumber(args[2]) then
    engine.log("Error: Incorrect arguments given.")
    engine.log("Usage: star_system [INT x_pos] [INT y_pos]")
    return
  end
  local x, y = tonumber(args[1]), tonumber(args[2])
  local spawn_chance = .5
  local current_star = game.ecs:add_entity(engine.entity["white_dwarf"], x, y, random_name())
  for i = 1, #planet_choice do
    local sc = love.math.random(0, 1)
    if sc <= spawn_chance then
      local rad = (i * 1000) + love.math.random(i * 100, i * 500)
      local selection = math.ceil(love.math.random(0, #planet_choice[i]))
      local class = planet_choice[i][selection]
      local current_planet = game.ecs:add_entity(engine.entity.test_planet, class, current_star, current_star, rad)
      if i > 2 then
        local moons = math.floor(love.math.random(0, 4))
        if moons > 0 then
          local moon_rad = 50
          for i = 1, moons do
            game.ecs:add_entity(engine.entity.test_moon, "rock", current_star, current_planet, moon_rad)
            moon_rad = moon_rad + love.math.random(25, 75)
          end
        end
      end
    end
  end
end