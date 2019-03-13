local img = {}
      img.requirements = {"body", "image", "disabled"}

function img.draw(x, y, sc, ent, cam)
  sc = sc * ent.image.sc
  local r = ent.body.r + ent.image.r
  local hw = ent.body.w * .5
  local hh = ent.body.h * .5
  love.graphics.draw(engine.assets[ent.image.name], x, y, -r, sc, sc, hw, hh)
end

return img