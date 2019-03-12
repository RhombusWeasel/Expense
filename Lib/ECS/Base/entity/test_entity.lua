--[[ECS Test Entity:
  Return a table containing a function "new" that returns a table of components
]]

local ent = {}

function ent.new(x, y, vx, vy)
  return {
    body = engine.component.body.new(x, y, 10, 10),
    vel = engine.component.vector.new(vx, vy),
    acc = engine.component.vector.new(0, 0),
  }
end

return ent