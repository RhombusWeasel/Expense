local b = engine.ui.tool_button:extend()

function b:setup()
  self.image = "brush_button"
  self.hover_image = "brush_button"
  self.is_tiled = false
end

function b:left_mouse_pressed()
  self.window.current_tool = "brush"
end

function b:tool_used(x, y, img, col)
  love.graphics.setCanvas(img)
  love.graphics.setColor(col)
  love.graphics.circle(self.window.fill_type, x, y, self.window.brush_size)
  love.graphics.setCanvas()
end

return b