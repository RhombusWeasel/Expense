local col = engine.ui.base:extend()

function col:setup(header, tab, key, align, round, text_height)
  local h = text_height or 20
  local a = align or "center"
  local r = round or false
  self.text = header
  self.table = tab
  self.key = key
  self.text_align_list = a
  self.round = r
  self.border_padding_top = 20
  self.border_padding_bottom = 5
  self.text_align_y = "top"
  self.text_padding_x = 6
  self.text_height = h
  self.hue = {0,0,0,1}
  self.text_colour = {0,1,0,1}
  self.h = (#self.table * h) + self.border_padding_top + self.border_padding_bottom
end

function col:extra_draw(dt)
  self.h = (#self.table * self.text_height) + self.border_padding_top + self.border_padding_bottom
  local x, y = self:get_position()
  local w, h = self:get_size()
  local align = self.text_align_list
  for i = 1, #self.table do
    local t = tostring(self.table[i][self.key])
    if self.round then
      t = tostring(math.round(self.table[i][self.key], 2))
    end
    local tw = engine.font[engine.current_font]:getWidth(t)
    local px = (x + w) - (tw / 2)
    local py = y + self.border_padding_top + self.text_padding_y + ((i - 1) * self.text_height)
    if align == "left" then
      px = x + self.text_padding_x
    elseif align == "right" then
      px = (x + w) - (tw + self.text_padding_x)
    end
    love.graphics.print(t, px, py)
  end
  --self.window:assert_size()
end

return col