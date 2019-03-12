local c = engine.ui.tool_button:extend()

function c:setup()
  self.image = "circle_button"
  self.hover_image = "circle_button"
  self.startx = 0
  self.starty = 0
  self.box_w = 0
  self.box_h = 0
  self.is_drawing = false
  self.use_tool_canvas = true
  self.is_tiled = false
end

function c:left_mouse_pressed()
  self.window.current_tool = "circle"
end

function c:get_box_dimensions(x, y)
  local f_type = self.window.fill_type
  local sx = math.min(self.startx, x) + .5
  local sy = math.min(self.starty, y) + .5
  local w = (math.max(self.startx, x) - sx) * .5
  local h = (math.max(self.starty, y) - sy) * .5
  return sx + w, sy + h, w, h
end

function c:mouse_down(x, y, img, col)
  self.startx = x
  self.starty = y
  self.is_drawing = true
end

function c:tool_used(x, y, img, col)
  if not self.is_drawing then return end
  local f_type = self.window.fill_type
  local sx, sy, w, h = self:get_box_dimensions(x, y)
  love.graphics.setCanvas(img)
  love.graphics.setColor(col)
  love.graphics.setLineStyle("rough")
  love.graphics.ellipse(f_type, sx, sy, w, h)
  love.graphics.setCanvas()
end

function c:mouse_up(x, y, img, col)
  self:tool_used(x, y, img, col)
  self.is_drawing = false
end

return c