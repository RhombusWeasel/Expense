local e = engine.ui.tool_button:extend()

function e:setup()
  self.image = "erase_button"
  self.hover_image = "erase_button"
  self.is_tiled = false
end

function e:left_mouse_pressed()
  self.window.current_tool = "erase"
end

function e:tool_used(x, y, img, col)
  col = {0,0,0,0}
  love.graphics.setCanvas(img)
  love.graphics.setBlendMode("replace")
  love.graphics.setColor(col)
  local size = self.window.erase_brush
  if size == 1 then
    love.graphics.points(x, y)
  else
    love.graphics.circle("fill", x, y, size)
  end
  love.graphics.setBlendMode("alpha")
  love.graphics.setCanvas()
end

return e