--[[ECS Test Entity:
  Return a table containing a function "new" that returns a table of components
]]

local ent = {}

function ent.new(x, y, vx, vy)
  return {
    body     = engine.component.body.new(x, y, 16, 16),
    vel      = engine.component.vector.new(vx, vy),
    acc      = engine.component.vector.new(0, 0),
    collider = engine.component.collider.new("ship", 10),
    health   = engine.component.health.new(1, 0, 0, 1),
    image    = engine.component.image.new("shuttle", 16, 16, -90, .1),
  }
end

return ent