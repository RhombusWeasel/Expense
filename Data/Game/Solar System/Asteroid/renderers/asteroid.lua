local ast = {
  requirements = {
    "body",
    "image",
    "resource",
  }
}

function ast.draw(x, y, sc, ent, cam)
  if cam.scale <= 1 then
    sc = sc * ent.image.sc
    local r = ent.body.r + ent.image.r
    local hw = ent.body.w * .5
    local hh = ent.body.h * .5
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(engine.assets[ent.image.name], x, y, -r, sc, sc, hw, hh)
  else
    love.graphics.setColor(.8,.3,0,.4)
    love.graphics.circle("fill", x, y, 4)
    love.graphics.setColor(1,1,1,1)
  end
end

return ast