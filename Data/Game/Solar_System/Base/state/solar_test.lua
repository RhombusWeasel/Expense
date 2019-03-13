local stats = {
  {item = "kale_kelp", max = "2000", mine = false},
  {item = "kale_kelp", max = "2000", mine = false},
  {item = "work_rations", max = "2000", mine = false},
  {item = "iron_ore", max = "2000", mine = true},
  {item = "iron_ore", max = "2000", mine = true},
  {item = "carbon_ore", max = "2000", mine = true},
  {item = "carbon_ore", max = "2000", mine = true},
  {item = "silicon_ore", max = "2000", mine = true},
  {item = "silicon_ore", max = "2000", mine = true},
  {item = "graphene", max = "2000", mine = false},
  {item = "silicene", max = "2000", mine = false},
  {item = "steel_plates", max = "2000", mine = false},
  {item = "bio_plastics", max = "2000", mine = false},
  {item = "soc_chips", max = "2000", mine = false},
  {item = "nano_piduino_boards", max = "2000", mine = false},
  {item = "mining_equipment", max = "2000", mine = false},
}

local state = {}

function state.resize(w, h)
  game.camera:resize(w, h)
end

function compile_starmap()
  game.starmap = {}
  for i = 1, #game.ecs.entity_list do
    local ent = game.ecs:get_entity(i)
    if ent.class == "star" then
      table.insert(game.starmap, ent.id)
      ent.starmap_id = #game.starmap
      ent.planets = {}
      ent.moons = {}
      ent.debris = {}
      ent.ships = {}
      ent.stations = {}
    elseif ent.class == "planet" then
      local star = game.ecs:get_entity(ent.orbit.star)
      table.insert(star.planets, ent.id)
      ent.moons = {}
    elseif ent.class == "moon" then
      local star = game.ecs:get_entity(ent.orbit.star)
      table.insert(star.moons, ent.id)
      local planet = game.ecs:get_entity(ent.orbit.parent)
      table.insert(planet.moons, ent.id)
    elseif ent.class == "asteroid" then
      local star = game.ecs:get_entity(ent.orbit.star)
      table.insert(star.debris, ent.id)
    elseif ent.class == "station" then
      if ent.model ~= "mine" then
        local star = game.ecs:get_entity(ent.orbit.star)
        table.insert(star.stations, ent.id)
      else
        local asteroid = game.ecs:get_entity(ent.asteroid_id)
        local star = game.ecs:get_entity(asteroid.orbit.star)
        table.insert(star.stations, ent.id)
      end
    end
  end
end

function state.startup()
  game.ecs = engine.system.ecs:new()
  game.ecs:add_system(engine.behaviour.orbiter)
  game.ecs:add_system(engine.behaviour.planet)
  game.ecs:add_system(engine.behaviour.collide)
  game.ecs:add_system(engine.behaviour.damage)
  game.ecs:add_system(engine.behaviour.travel)
  game.ecs:add_system(engine.behaviour.asteroid)
  game.ecs:add_system(engine.behaviour.trade_ai)
  game.ecs:add_system(engine.behaviour.crafting)
  game.ecs:add_system(engine.behaviour.track)
  game.ui = engine.ui.ui_container:new("manager", 0, 0, 1, 1)
  game.camera = engine.ui.viewport:new("main_camera", 0, 0, 1, 1, 0, 0, 0)
  engine.console_commands.spawn_star({"0", "0", "sol"})
  game.players = {
    engine.player.new(1000000),
    engine.player.new(1000000),
  }
  local r_min = 10000
  local r_max = 50000
  for i = 1, #stats do
    if stats[i].mine then
      engine.console_commands.mine({stats[i].item, stats[i].max})
    else
      engine.console_commands.station({stats[i].item, "1", "1", stats[i].max})
    end
  end
  engine.console_commands.ship({"shuttle", "80", "1"})
  --engine.console_commands.details({"88"})
  compile_starmap()
end

function state.key_pressed(k)
  if k == "up" then
    engine.grid_size = engine.hash_grid_size * 2
    return
  elseif k == "down" then
    engine.hash_grid_size = engine.hash_grid_size / 2
    return
  end
  if game.ui:key_pressed(k) then return end
  if game.camera:key_pressed(k) then return end
end

function state.mouse_pressed(x, y, b)
  if game.ui:mouse_pressed(b) then return end
  if game.camera:mouse_pressed(b) then return end
end

function state.mouse_released(x, y, b)
  if game.ui:mouse_released(b) then return end
  if game.camera:mouse_released(b) then return end
end

function state.wheel_moved(s)
  if game.ui:wheel_moved(s) then return end
  if game.camera:wheel_moved(s) then return end
end

function state.update(dt)
  game.ui:update(dt)
  game.camera:update(dt)
  game.ecs:update(dt)
end

function state.draw()
  game.camera:draw()
  game.ui:draw()
  love.graphics.setColor(1,1,1,1)
  love.graphics.print("Entity Count: "..#game.ecs.entity_list, 1, 1)
  love.graphics.print("Zoom Level  : "..game.camera.scale, 1, 16)
end

return state