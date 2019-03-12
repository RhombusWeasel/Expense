local rad_offset = math.rad(-90)

local ship = {
  requirements = {"body", "image", "engine"},
  render_order = {},
}

function ship.setup()
  ship.particle = love.graphics.newParticleSystem(engine.assets.thruster_particle, 150)
  ship.particle:setParticleLifetime(1, 1.5)
	ship.particle:setEmissionRate(500)
	ship.particle:setSizeVariation(.1)
	ship.particle:setLinearAcceleration(0, -20)
  ship.particle:setSizes(1, .1)
	ship.particle:setColors(1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0) -- Fade to transparency.
end

function ship.update(dt)
  ship.particle:update(dt)
end

function ship.draw(x, y, sc, ent, cam)
  sc = sc * ent.image.sc
  local r = ent.body.r + ent.image.r
  local hw = ent.body.w * .5
  local hh = ent.body.h * .5
  
  if cam.scale >= 0.03 then
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(120)
    love.graphics.setColor(ent.colour)
    love.graphics.circle("fill", 0, 0, 5, 3)
    love.graphics.pop()
  else  
    love.graphics.setColor(1,1,1,1)
    if ent.engine.target_id ~= -1 then
      love.graphics.push()
      love.graphics.translate(x, y)
      love.graphics.rotate(-ent.body.r + rad_offset)
      for i = 1, #ent.engine.particles do
        local offset = ent.engine.particles[i]
        love.graphics.draw(ship.particle, offset.x * sc, offset.y * sc, 0, sc, sc)
      end
      love.graphics.pop()
    end
    
    love.graphics.draw(engine.assets[ent.image.name], x, y, -r, sc, sc, ent.body.w / 2, ent.body.h / 2)
  end
  local is_selected = game.ecs.selected_list[ent.id]
  if is_selected and ent.engine.target_id ~= -1 then
    local tx, ty = cam:get_screen_position(ent.engine.target_id)
    love.graphics.setColor(ent.colour)
    love.graphics.line(x, y, tx, ty)
    love.graphics.circle("line", x, y, (ent.body.w / 2) * sc, 6)
    local remaining_time = engine.time.to_string(ent.engine.travel_time - ent.engine.time)
    love.graphics.print("ETA: "..remaining_time, x + ent.body.w, y)
  end
end

return ship