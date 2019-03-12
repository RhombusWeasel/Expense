local cp = engine.ui.base:extend()

function cp:setup()
  self.image = "none"
  self.hover_image = "none"
  self.canvas = love.graphics.newCanvas(256, 256)
  self.ignore_canvas = true
end

function cp:update_call(dt)
  local draw_canvas = false
  if self.window.mix_col_x == nil then
    self.window.mix_col_x = {1, 0, 0, 1}
    self.window.mix_col_y = {0, 0, 1, 1}
    draw_canvas = true
  end
  if self.window.mix_col_x ~= self.mix_col_x then
    self.mix_col_x = self.window.mix_col_x
    draw_canvas = true
  end
  if self.window.mix_col_y ~= self.mix_col_y then
    self.mix_col_y = self.window.mix_col_y
    draw_canvas = true
  end
  if draw_canvas then
    self:draw_canvas()
  end
end

function cp:left_mouse_pressed()
  local px, py = self:get_position()
  px = engine.mousex - px
  py = engine.mousey - py
  self.window.left_colour = {self.img_data:getPixel(px, py)}
end

function cp:right_mouse_pressed()
  local px, py = self:get_position()
  px = engine.mousex - px
  py = engine.mousey - py
  self.window.right_colour = {self.img_data:getPixel(px, py)}
end

function cp:draw_canvas()
  love.graphics.setCanvas(self.canvas)
  local colx = self.window.mix_col_x
  local coly = self.window.mix_col_y
  for py = 0, 255 do
    for px = 0, 255 do
      local x = px / 255
      local y = py / 255
      local col = {
        ((x * colx[1]) + (y * coly[1])),
        ((x * colx[2]) + (y * coly[2])),
        ((x * colx[3]) + (y * coly[3])),
        1,
      }
      love.graphics.setColor(col)
      love.graphics.points(px, 255 - py)
    end
  end
  love.graphics.setCanvas()
  self.img_data = self.canvas:newImageData()
end

function cp:extra_draw()
  local px, py = self:get_position()
  love.graphics.setColor(1,1,1,1)
  love.graphics.draw(self.canvas, px, py)
end

return cp