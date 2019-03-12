local state = {}

function state.add_random_ship()
  local x = love.math.random(-500, 300)
  local y = love.math.random(-500, 300)
  local vx = love.math.random(-1, 1) > 0 and 1 or -1
  local vy = love.math.random(-1, 1) > 0 and 1 or -1
  game.ecs:add_entity(engine.entity.collision_test_entity, x, y, vx, vy)
end

function state.resize(w, h)
  state.ui = nil
  state.ui = engine.ui.base:new("main_ui", 0, 0, engine.screen_width, engine.screen_height)
  state.ui:add(engine.ui.viewport:new("main_camera", 0, 0, 1, 1, 0, 0, 0), 1)
end

function state.enter()
  game.ecs = engine.system.ecs:new()
  game.ecs:add_system(engine.behaviour.screen_bounce)
  game.ecs:add_system(engine.behaviour.collide)
  game.ecs:add_system(engine.behaviour.damage)
  engine.behaviour.screen_bounce.w = 1000000
  engine.behaviour.screen_bounce.h = 1000000
  state.ui = engine.ui.base:new("main_ui", 0, 0, engine.screen_width, engine.screen_height)
  state.ui:add(engine.ui.viewport:new("main_camera", 0, 0, 1, 1, 0, 0, 0), 1)
  game.ecs:add_entity(engine.entity.white_dwarf, 0, 0)
end

function state.update(dt)
  state.ui:update(dt)
  if love.timer.getFPS() > 59 then
    for i = 1, 10 do
      state.add_random_ship()
    end
  end
  game.ecs:update(dt)
end

function state.draw()
  state.ui:draw()
  love.graphics.print("Entity Count: "..#game.ecs.entity_list, 1, 1)
end

return state