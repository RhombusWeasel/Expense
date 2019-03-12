local tf = engine.ui.base:extend()

function tf:setup(text)
  self.current_line = 1
  self.text_align_x = "left"
  self.text_align_y = "top"
  self.text_padding_x = 5
  self.text_padding_y = 5
  self.is_tiled = true
  self.text = text or {}
  if type(self.text) == "string" then
    if love.filesystem.exists(self.text) then
      self:load_file(self.text)
    end
  end
end

function tf:load_file(path)
  self.text = {}
  for line in love.filesystem.lines(path) do
    self:add_text(tostring(line))
  end
end

function tf:add_text(t, line)
  if line == nil then
    if self.text[1] == nil then
      line = 1
    else
      line = #self.text + 1
    end
  end
  table.insert(self.text, line, t)
end

function tf:get_max_lines()
  local w, h = self:get_size()
  return math.floor(h / font:getHeight())
end

function tf:draw_text()
  if self.text[1] ~= nil then
    local h = engine.font_height
    local w = font:getWidth("a")
    local px, py = self:get_position()
    local pw, ph = self:get_size()
    local line_max = self:get_max_lines()
    local line_count = #self.text
    local char_w = engine.font[engine.current_font]:getWidth("a")
    local start_y = math.max(self.current_line, (#self.text + 2) - line_max)
    self:set_colour(self.text_colour)
    local x, y =  self:get_text_pos(self.text[1])
    for i = start_y, #self.text do
      if self.text[i] ~= nil then
        local str = self.text[i]
        local max_char = math.floor(pw / char_w)
        if #str > max_char then
          str = string.sub(str, 1, max_char - 1)
        end
        love.graphics.print(str, x, y)
        y = y + h
      end
    end
  end
end

return tf