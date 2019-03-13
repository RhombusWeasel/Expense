local planet = {}
      planet.requirements = {"body", "planet"}
      planet.init = false
      planet.tx_size = 256
      planet.canvas = love.graphics.newCanvas(planet.tx_size, planet.tx_size)
      planet.light_canvas = love.graphics.newCanvas(planet.tx_size, planet.tx_size)

function planet.on_load(update_screen)
  local tex_variety = engine.texture_variation
  engine.ground_textures = {}
  engine.light_textures = {}
  for k, t in pairs(engine.planet_textures) do
    engine.ground_textures[k] = {}
    engine.light_textures[k] = {}
    for i = 1, tex_variety do
      update_screen("Loading "..k.." textures.. "..i.."/"..tex_variety)
      local map = engine.system.mapgen.generate(planet.tx_size, planet.tx_size)
      table.insert(engine.ground_textures[k], engine.system.mapgen.draw_canvas(map, t))
      if engine.light_maps[k] ~= nil then
        table.insert(engine.light_textures[k], engine.system.mapgen.draw_canvas(map, engine.light_maps[k]))
      end
    end
  end
  engine.cloud_textures = {}
  for k, t in pairs(engine.system.mapgen.clouds) do
    engine.cloud_textures[k] = {}
    for i = 1, tex_variety do
      update_screen("Loading "..k.." clouds.. "..i.."/"..tex_variety)
      local map = engine.system.mapgen.generate(planet.tx_size, planet.tx_size)
      table.insert(engine.cloud_textures[k], engine.system.mapgen.draw_canvas(map, t))
    end
  end
  engine.shade_textures = {}
  for i = 1, tex_variety do
    update_screen("Calculating shade... "..i.."/"..tex_variety)
    table.insert(engine.shade_textures, engine.system.mapgen.make_shade_layer(planet.tx_size, planet.tx_size))
  end
end

function planet.draw(x, y, sc, ent, cam)
  local r = ent.body.r
  local cr = ent.planet.cloud_angle
  local hw = ent.body.w * .5
  local ho = planet.tx_size * .5
  local px, py = cam:get_screen_position(ent.orbit.parent)
  local sx, sy = cam:get_screen_position(ent.orbit.star)
  local dx, dy = x - sx, y - sy
  local rad = ent.orbit.radius * sc
  local star_angle = math.atan2(dy, dx)
  local scale = (sc * ent.planet.size)
  love.graphics.setColor(1, 1, 1, .4)
  love.graphics.circle("line", px, py, rad, 144)
  love.graphics.circle("line", x, y, ent.body.w * sc)
  if cam.scale >= 1 then
    love.graphics.setColor(1, 1, 1, .5)
    love.graphics.circle("fill", x, y, 4)
  else
    local last_can = love.graphics.getCanvas()
    love.graphics.setCanvas(planet.canvas)
    love.graphics.clear(0, 0, 0, 0)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(engine.ground_textures[ent.planet.ground][ent.planet.ground_id], ho, ho, r, 1, 1, ho, ho)
    love.graphics.draw(engine.cloud_textures[ent.planet.clouds][ent.planet.clouds_id], ho, ho, cr, 1, 1, ho, ho)
    love.graphics.draw(engine.shade_textures[ent.planet.shade_id], ho, ho, star_angle, 1, 1, ho, ho)
    if engine.light_textures[ent.planet.ground][ent.planet.ground_id] ~= nil then
      love.graphics.setCanvas(planet.light_canvas)
      love.graphics.clear(0, 0, 0, 0)
      love.graphics.draw(engine.light_textures[ent.planet.ground][ent.planet.ground_id], ho, ho, r, 1, 1, ho, ho)
      love.graphics.setCanvas(planet.canvas)
      engine.shaders.light:send("shade", planet.canvas)
      love.graphics.setShader(engine.shaders.light)
      love.graphics.draw(planet.light_canvas, ho, ho, 0, 1, 1, ho, ho)
      love.graphics.setShader()
    end
    love.graphics.setCanvas(last_can)
    love.graphics.setShader(engine.shaders.fisheye)
    love.graphics.draw(planet.canvas, x, y, 0, scale, scale, ho, ho)
    love.graphics.setShader()
  end
end

return planet