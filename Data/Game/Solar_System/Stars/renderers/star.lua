local star = {}
      star.requirements = {"body", "star"}

function star.draw(x, y, sc, ent)
  local r = ent.body.r
  local hw = ent.body.w * .5
  local hh = ent.body.h * .5
  local star_scale = 10
  love.graphics.setColor(1, 1, 1, 1)
  engine.shaders.star:send("iGlobalTime", engine.star_step)
  love.graphics.setShader(engine.shaders.star)
  love.graphics.draw(engine.assets.star, x, y, r, sc * star_scale, sc * star_scale, hw, hh)
  love.graphics.setShader()
end

return star