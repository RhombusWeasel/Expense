local spectrum = {
  {
    {1,0,0,1},
    {1,1,1,1}
  },
  {
    {1,1,0,1},
    {1,0,0,1}
  },
  {
    {0,1,0,1},
    {1,1,0,1}
  },
  {
    {0,1,1,1},
    {0,1,0,1}
  },
  {
    {0,0,1,1},
    {0,1,1,1}
  },
  {
    {1,0,1,1},
    {0,0,1,1}
  },
  {
    {1,0,0,1},
    {1,0,1,1}
  },
  {
    {0,0,0,1},
    {1,0,0,1}
  },
}

local cs = engine.ui.base:extend()

function cs:setup()
  self.image = "none"
  self.canvas = love.graphics.newCanvas(self.w, self.h)
  self.ignore_canvas = true
  self.start = 1
  self.finish = #spectrum
  self.inc = 1
  if self.w > self.h then
    self.start = #spectrum
    self.finish = 1
    self.inc = -1
  end
  self:draw_canvas()
  self.img_data = self.canvas:newImageData()
end

function cs:left_mouse_pressed()
  local px, py = self:get_position()
  px = engine.mousex - px
  py = engine.mousey - py
  if self.inc > 0 then
    self.window.mix_col_y = {self.img_data:getPixel(px, py)}
  else
    self.window.mix_col_x = {self.img_data:getPixel(px, py)}
  end
  local mixer = self.window:find_child("picker")
  mixer:draw_canvas()
end

function cs:draw_canvas()
  love.graphics.setCanvas(self.canvas)
  local w = self.w
  local h = self.h
  local x = 0
  local y = 0
  for s = self.start, self.finish, self.inc do
    local col1 = spectrum[s][1]
    local col2 = spectrum[s][2]
    if self.inc < 0 then
      col1, col2 = col2, col1
    end
    local line_length = math.min(w, h)
    for i = 0, 31 do
      local bias = (1 / 32) * i
      local col = engine.colour.blend(col1, col2, bias)
      love.graphics.setColor(engine.colour.set_alpha(col, 1))
      if w < h then
        for px = 0, line_length - 1 do
          love.graphics.points(px, y + i)
        end
      else
        for py = 0, line_length - 1 do
          love.graphics.points(x + i, py)
        end
      end
    end
    if w < h then
      y = y + 32
    else
      x = x + 32
    end
  end
  love.graphics.setCanvas()
end

function cs:extra_draw()
  local px, py = self:get_position()
  love.graphics.setColor(1,1,1,1)
  love.graphics.draw(self.canvas, px, py)
end

return cs