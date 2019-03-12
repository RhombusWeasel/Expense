--[[Example System - Move Entity - By Pete Hunter
  This system takes a given entity with a position, a velocity and an acceleration module
  and moves it toward a target set at move.target.
  It moves the target point slowly, bouncing off the screen edges and occasionaly just reverses in one direction.
]]

local target_speed = 15
local max_speed = 50
local max_accel = .1


--Extend the base class:
local move = engine.class:extend()
      --All systems must have a list of required components
      move.requirements = {"body", "vel", "acc"}

--[[Init:
  system:init gets called once when the system is added to the ECS
]]
function move:init()
  self.counter = 0
  self.timeout = 10
  self.target = {
    x = math.random(0, engine.screen_width),
    y = math.random(0, engine.screen_height),
    vx = target_speed,
    vy = target_speed,
  }
end

--[[Pre Update:
  Pre update is called once at the start of each update cycle and is passed delta time as dt
]]
function move:pre_update(dt)
  self.counter = self.counter + dt
  if self.target.x <= 0 or self.target.x >= engine.screen_width then
    self.target.vx = self.target.vx * -1
  end
  if self.target.y <= 0 or self.target.y >= engine.screen_height then
    self.target.vy = self.target.vy * -1
  end
  if math.random(1, 10000) < 10 then
    if math.random(0, 1) == 1 then
      self.target.vx = self.target.vx * -1
    else
      self.target.vy = self.target.vy * -1
    end
  end
end

--[[Update:
  Update gets called once for each entity subscribed to this system per update cycle.
  The Update function is always passed delta time as dt and the current entity to update as ent
]]
function move:update(dt, ent)
  local spd = max_speed
  local acc = max_accel
  local mx, my = self.target.x, self.target.y
  
  local dx = mx - ent.body.x
  local dy = my - ent.body.y
  
  local dist = 1 / math.sqrt((dx * dx) + (dy * dy))
  ent.acc.x = ((dx / dist) * acc) * dt
  ent.acc.y = ((dy / dist) * acc) * dt
  
  ent.vel.x = ent.vel.x + ent.acc.x
  ent.vel.y = ent.vel.y + ent.acc.y
  
  local hyp = math.sqrt((ent.vel.x * ent.vel.x) + (ent.vel.y * ent.vel.y))
  ent.vel.x = (ent.vel.x / hyp) * spd
  ent.vel.y = (ent.vel.y / hyp) * spd
  
  ent.body.x = ent.body.x + (ent.vel.x * dt)
  ent.body.y = ent.body.y + (ent.vel.y * dt)
end

--[[Post Update:
  Post Update is called once at the end of the update cycle.
]]
function move:post_update(dt)
  self.target.x = self.target.x + (self.target.vx * dt)
  self.target.y = self.target.y + (self.target.vy * dt)
end

return move