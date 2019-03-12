local can = engine.ui.base:extend()

function can:background_canvas(w, h)
  local canvas = self:get_canvas(w, h)
  local lastCanvas = love.graphics.getCanvas()
  local flick = true
  local grey = {.5,.5,.5,1}
  local darkGrey = {.4,.4,.4,1}
  love.graphics.setCanvas(canvas)
  for x = 0, w do
    for y = 0, h do
      if flick then
        love.graphics.setColor(grey)
      else
        love.graphics.setColor(darkGrey)
      end
      love.graphics.points(x, y)
      flick = not flick
    end
  end
  love.graphics.setCanvas(lastCanvas)
  return canvas
end

function can:get_canvas(w, h)
  local c = love.graphics.newCanvas(w, h)
  c:setFilter("nearest", "nearest", 0)
  return c
end

function can:new_canvas(w, h)
  self.layers = {}
  self.layers[-1] = {draw = true, canvas = self:background_canvas(w, h)}
  self.layers[0]  = {draw = true, canvas = self:get_canvas(w, h)}
  self.layers[1]  = {draw = true, canvas = self:get_canvas(w, h)}
  self.current_layer = 1
end

function can:setup(w, h)
  self.colour = {0,0,0,1}
  self.hover_colour = self.colour
  self.image = "none"
  self.image_width = w
  self.image_height = h
  self.image_offset_x = -(w * .5)
  self.image_offset_y = -(h * .5)
  self.mirror_x = false
  self.mirror_y = false
  self.scale = 2
  self:new_canvas(w, h)
end

function can:get_image_position()
  local px, py = self:get_position()
  local w, h = self:get_size()
  local x = (w * .5) + (self.image_offset_x * self.scale)
  local y = (h * .5) + (self.image_offset_y * self.scale)
  return x, y
end

function can:get_image_size()
  return self.image_width * self.scale, self.image_height * self.scale
end

function can:get_image_pixel()
  local x, y = self:get_position()
  local sx, sy = self:get_image_position()
  local w, h = self:get_image_size()
  local px = math.floor((engine.mousex - sx - x) / self.scale)
  local py = math.floor((engine.mousey - sy - y) / self.scale)
  if px >= 0 and px < self.image_width then
    if py >= 0 and py <= self.image_width then
      return true, px, py
    end
  end
  return false
end

function can:get_colour()
  local l_col = self.window.left_colour
  local r_col = self.window.right_colour
  if self.window.last_click == 1 then
    return l_col
  elseif self.window.last_click == 2 then
    return r_col
  end
  return {0,0,0,0}
end

function can:get_layer()
  local tool = self.window:find_child(self.window.current_tool)
  if tool.use_tool_canvas then
    return 0
  end
  return self.window.current_layer
end

function can:get_mirror_pixel(x, y)
  if self.mirror_x then
    x = (self.image_width - 1) - x
  end
  if self.mirror_y then
    y = (self.image_height - 1) - y
  end
  return x, y
end

function can:tool_used(x, y)
  local tool = self.window:find_child(self.window.current_tool)
  local layer = self:get_layer()
  local col = self:get_colour()
  tool:tool_used(x, y, self.layers[layer].canvas, col, self.layers[0])
  if self.mirror_x or self.mirror_y then
    x, y = self:get_mirror_pixel(x, y)
    tool:tool_used(x, y, self.layers[layer].canvas, col, self.layers[0])
  end
end

function can:image_click(col, p_check, px, py)
  if p_check then
    self:tool_used(px, py, col)
  end
end

function can:left_mouse_pressed()
  local p_check, px, py = self:get_image_pixel()
  if p_check then
    self.window.last_click = 1
    local tool = self.window:find_child(self.window.current_tool)
    local layer = self:get_layer()
    local col = self.window.left_colour
    tool:mouse_down(px, py, self.layers[layer].canvas, col)
    if self.mirror_x or self.mirror_y then
      px, py = self:get_mirror_pixel(px, py)
      tool:mouse_down(x, y, self.layers[layer].canvas, col, self.layers[0])
    end
  end
end

function can:right_mouse_pressed()
  local p_check, px, py = self:get_image_pixel()
  if p_check then
    self.window.last_click = 2
    local tool = self.window:find_child(self.window.current_tool)
    local layer = self:get_layer()
    local col = self.window.right_colour
    tool:mouse_down(px, py, self.layers[layer].canvas, col)
    if self.mirror_x or self.mirror_y then
      px, py = self:get_mirror_pixel(px, py)
      tool:mouse_down(x, y, self.layers[layer].canvas, col, self.layers[0])
    end
  end
end

function can:left_mouse_released()
  local p_check, px, py = self:get_image_pixel()
  if p_check then
    self.window.last_click = 1
    local tool = self.window:find_child(self.window.current_tool)
    local layer = self.window.current_layer
    local col = self.window.left_colour
    tool:mouse_up(px, py, self.layers[layer].canvas, col)
    if self.mirror_x or self.mirror_y then
      px, py = self:get_mirror_pixel(px, py)
      tool:mouse_up(x, y, self.layers[layer].canvas, col, self.layers[0])
    end
  end
end

function can:right_mouse_released()
  local p_check, px, py = self:get_image_pixel()
  if p_check then
    self.window.last_click = 2
    local tool = self.window:find_child(self.window.current_tool)
    local layer = self.window.current_layer
    local col = self.window.right_colour
    tool:mouse_up(px, py, self.layers[layer].canvas, col)
    if self.mirror_x or self.mirror_y then
      px, py = self:get_mirror_pixel(px, py)
      tool:mouse_up(x, y, self.layers[layer].canvas, col, self.layers[0])
    end
  end
end

function can:on_scroll(s)
  if s > 0 then
    local w, h = self:get_size()
    self.scale = math.min(self.scale + 1, math.floor(h / self.image_height) - 1)
  elseif s < 0 then
    self.scale = math.max(self.scale - 1, 1)
  end
end

function can:update_call(dt)
  love.graphics.setCanvas(self.layers[0].canvas)
  love.graphics.clear(0,0,0,0)
  love.graphics.setCanvas()
  local p_check, px, py = self:get_image_pixel()
  local tool = self.window:find_child(self.window.current_tool)
  local w, h = self:get_size()
  self.scale = math.min(self.scale, math.floor(h / self.image_height) - 1)
  self.scale = math.min(self.scale, math.floor(w / self.image_width) - 1)
  if (engine.mouse_button > 0 and engine.mouse_button <= 2) or tool.use_update then
    if p_check then
      self:tool_used(px, py)
    end
  end
end

function can:extra_draw()
  local x, y = self:get_image_position()
  local mx, my = self:get_position()
  love.graphics.setColor(1,1,1,1)
  if self.layers[-1].draw then
    love.graphics.draw(self.layers[-1].canvas, mx + x +.5, my + y - .5, 0, self.scale, self.scale)
  end
  for i = 1, #self.layers do
    if self.layers[i].draw then
      love.graphics.draw(self.layers[i].canvas, mx + x +.5, my + y - .5, 0, self.scale, self.scale)
    end
  end
  love.graphics.draw(self.layers[0].canvas, mx + x +.5, my + y - .5, 0, self.scale, self.scale)
end

return can