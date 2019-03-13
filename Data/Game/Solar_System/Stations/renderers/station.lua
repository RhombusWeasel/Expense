local station = {
  requirements = {"body", "image", "crafting"},
  debug = true,
}

function station.draw(x, y, sc, ent, cam)
  love.graphics.setColor(engine.recipes[ent.crafting.product].colour)
  love.graphics.circle("fill", x, y, 3, 8)
  if game.ecs.selected_list[ent.id] then
    love.graphics.circle("line", x, y, ent.body.w * (1 / cam.scale), 8)
  end
  love.graphics.setColor(1,1,1,1)
  local asset = engine.assets[ent.image.name] ~= nil and ent.image.name or ent.model
  love.graphics.draw(engine.assets[asset], x, y, 0, sc, sc, ent.body.w / 2, ent.body.h / 2)
  local str = engine.recipes[ent.product].label
  local w = engine.font[engine.current_font]:getWidth(str)
  if engine.draw_debug then
    local recipe = engine.recipes[ent.product]
    local y_offset = 2
    love.graphics.setColor(engine.recipes[ent.crafting.product].colour)
    for k, v in pairs(ent.crafting.inventory) do
      str = engine.string.l_pad(k, 20, " ")
      str = str..engine.string.r_pad(tostring(math.floor(v.amount)), 5, " ")
      str = str..engine.string.r_pad(tostring(math.floor(v.price)), 6, " ").."Cr."
      w = engine.font[engine.current_font]:getWidth(str)
      love.graphics.print(str, x - (w / 2), y + y_offset)
      y_offset = y_offset + 16
    end
    for k, v in pairs(ent.crafting.output) do
      str = engine.string.l_pad(k, 20, " ")
      str = str..engine.string.r_pad(tostring(math.floor(v.amount)), 5, " ")
      str = str..engine.string.r_pad(tostring(math.floor(v.price)), 6, " ").."Cr."
      w = engine.font[engine.current_font]:getWidth(str)
      love.graphics.print(str, x - (w / 2), y + y_offset)
      y_offset = y_offset + 16
    end
    str = "Cr"..engine.string.r_pad(tostring(ent.cash), 15, " ")
    w = engine.font[engine.current_font]:getWidth(str)
    love.graphics.print(str, x - (w / 2), y + y_offset)
  else
    love.graphics.print(str, x - (w / 2), y + 17)
  end
end

return station