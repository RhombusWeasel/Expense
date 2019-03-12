local line = engine.ui.tool_button:extend()

function line:setup()
  self.image = "line_button"
  self.hover_image = "line_button"
  self.startx = 0
  self.starty = 0
  self.box_w = 0
  self.box_h = 0
  self.is_drawing = false
  self.use_tool_canvas = true
  self.is_tiled = false
end

function line:left_mouse_pressed()
  self.window.current_tool = "line"
end

function line:mouse_down(x, y, img, col)
  self.startx = x
  self.starty = y
  self.is_drawing = true
end

function line:tool_used(x, y, img, col, tc)
  if self.is_drawing then
    local sx = self.startx
    local sy = self.starty
    local ex = x + 1
    local ey = y + 1
    love.graphics.setCanvas(img)
    love.graphics.setColor(col)
    love.graphics.setLineStyle("rough")
    love.graphics.line(sx, sy, ex, ey)
    love.graphics.setCanvas()
  end
end

function line:mouse_up(x, y, img, col)
  self:tool_used(x, y, img, col)
  self.is_drawing = false
end

return line