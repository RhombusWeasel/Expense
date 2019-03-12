local col_test = {}

function col_test.spawn_random()
  for i = 1, 50 do
    local hw = engine.screen_width * .5
    local hh = engine.screen_height * .5
    local x = love.math.random(-hw + 20, hw - 20)
    local y = love.math.random(-hh + 20, hh - 20)
    local vx = love.math.random(-1, 1) > 0 and 1 or -1
    local vy = love.math.random(-1, 1) > 0 and 1 or -1
    game.ecs:add_entity(engine.entity.collision_test_entity, x, y, vx, vy)
    engine.log("Entity "..i.." spawned at "..x..", "..y)
  end
end

function col_test.spawn_collision()
  game.ecs:add_entity(engine.entity.collision_test_entity, -100, 0, 1, 0)
  game.ecs:add_entity(engine.entity.collision_test_entity, 100, 0, -1, 0)
end

function col_test.enter()
  game.ecs = nil
  game.ecs = engine.system.ecs:new()
  game.ecs:add_system(engine.behaviour.screen_bounce)
  game.ecs:add_system(engine.behaviour.collide)
  game.ecs:add_system(engine.behaviour.damage)
  engine.behaviour.screen_bounce.w = engine.screen_width
  engine.behaviour.screen_bounce.h = engine.screen_height
  col_test.spawn_random()
  col_test.ui = engine.ui.viewport:new("main_camera", 0, 0, 1, 1, 0, 0, 0)
end

function col_test.resize(w, h)
  col_test.ui = nil
  col_test.ui = engine.ui.viewport:new("main_camera", 0, 0, 1, 1, 0, 0, 0)
  engine.behaviour.screen_bounce.w = engine.screen_width
  engine.behaviour.screen_bounce.h = engine.screen_height
end

function col_test.keyPressed(k)
  col_test.ui:key_pressed(k)
end

function col_test.update(dt)
  game.ecs:update(dt)
  col_test.ui:update(dt)
end

function col_test.draw()
  col_test.ui:draw()
  love.graphics.print("Entity Count: "..#game.ecs.entity_list, 1, 1)
  love.graphics.print("Zoom Level  : "..(1 / col_test.ui.scale), 1, 16)
end

return col_test