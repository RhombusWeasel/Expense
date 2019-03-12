local p = engine.ui.tool_button:extend()

function p:setup()
  self.image = "pencil_button"
  self.hover_image = "pencil_button"
  self.is_tiled = false
end

function p:left_mouse_pressed()
  engine.log(self.window.label)
  self.window.current_tool = "pencil"
end

function p:tool_used(x, y, img, col)
  love.graphics.setCanvas(img)
  love.graphics.setColor(col)
  love.graphics.points(x, y + 1)
  love.graphics.setCanvas()
end

return p