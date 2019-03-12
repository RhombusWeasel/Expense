local i_field = engine.ui.base:extend()
      i_field.key_commands = {}

function i_field:base_init()
  self.show_text = false
  self.ignore_canvas = true
end

function i_field:setup(path)
  self.filepath = path
  self.is_tiled = true
  self.text_colour = {0,1,0,1}
  self.text_align_y = "top"
  self.text_align_x = "left"
  self.cursor = {
    x = 0,
    y = 1,
  }
  if love.filesystem.getInfo(path) then
    self:load_file(path)
  else
    self.text = {""}
  end
  self.y_start = 1
  self.carat = "_"
  self.carat_blink = 1
  self.blink_timer = 30
  self.highlight_start_x = -1
  self.highlight_start_y = -1
  self.highlight_end_x = -1
  self.highlight_end_y = -1
  self.repeat_count = 0
  self.repeat_max = 8
  self.font_size = 12
  self.font_path = "/Lib/Base/font/unispace rg.ttf"
  self.font = love.graphics.newFont(self.font_path, self.font_size)
  self.repeat_timeout = self.repeat_max
  self.language = "lua"
  self.canvas = love.graphics.newCanvas(self.w - 6, self.h - 6)
  self.ignore_canvas = true
  self.memory = {}
end

function i_field:add_text(t, line)
  if line == nil then
    if self.text[1] == nil then
      line = 1
    else
      line = #self.text + 1
    end
  end
  table.insert(self.text, line, t)
end

function i_field:backup()
  local t = {}
  for i = 1, #self.text do
    t[i] = tostring(self.text[i])
  end
  table.insert(self.memory, 1, t)
end

function i_field:revert()
  if #self.memory > 0 then
    self.text = self.memory[1]
    table.remove(self.memory, 1)
  end
end

function i_field:load_file(path)
  self.text = {""}
  for line in love.filesystem.lines(path) do
    self:add_text(tostring(line))
  end
end

function i_field:save_file(path)
  path = path or self.filepath
  local file = love.filesystem.newFile(path, "w")
  for i = 1, #self.text do
    file:write(self.text[i].."\n")
  end
  file:close()
end

function i_field:split_text_at_cursor()
  if self.cursor.x == 0 then
    return "", self.text[self.cursor.y]
  elseif self.cursor.x > #self.text[self.cursor.y] then
    return self.text[self.cursor.y], ""
  else
    local str = self.text[self.cursor.y]
    local pre_cursor = string.sub(str, 1, self.cursor.x) or ""
    local post_cursor = string.sub(str, self.cursor.x + 1, #str) or ""
    return pre_cursor, post_cursor
  end
end

function i_field:check_text_input(t)
  if self.is_selected then
    self.window.text = "Edit "..self.filepath.." *"
    local pre, post = self:split_text_at_cursor()
    pre = pre or ""
    post = post or ""
    self.text[self.cursor.y] = pre..t..post
    self.cursor.x = self.cursor.x + #t < #self.text and self.cursor.x + #t or #self.text[self.cursor.y]
    self:render_text()
    return true
  end
  return false
end

function i_field:reload_font()
  self.font = love.graphics.newFont(self.font_path, self.font_size)
end

function i_field:get_max_lines()
  local w, h = self:get_size()
  return math.floor(h / self.font:getHeight()) - 1
end

function i_field.key_commands.delete(self)
  self:backup()
  if self.cursor.x == #self.text[self.cursor.y] then
    if self.cursor.y < #self.text then
      self.text[self.cursor.y] = self.text[self.cursor.y]..self.text[self.cursor.y + 1]
      table.remove(self.text, self.cursor.y + 1)
      self:render_text()
    end
    return
  end
  local pre, post = self:split_text_at_cursor()
  post = string.sub(post, 2, #post)
  self.text[self.cursor.y] = pre..post
end

function i_field.key_commands.backspace(self)
  if self.cursor.x == 0 then
    if self.cursor.y > 1 then
      self.cursor.x = #self.text[self.cursor.y - 1]
      self.text[self.cursor.y - 1] = self.text[self.cursor.y - 1]..self.text[self.cursor.y]
      table.remove(self.text, self.cursor.y)
      self.cursor.y = self.cursor.y - 1
      self:render_text()
    end
    return
  end
  local pre, post = self:split_text_at_cursor()
  pre = string.sub(pre, 1, #pre - 1)
  self.text[self.cursor.y] = pre..post
  self.cursor.x = self.cursor.x - 1
  self:render_text()
end

function i_field.key_commands.enter(self)
  if self.text[self.cursor.y] == "" or self.cursor.x == #self.text[self.cursor.y] then
    self.cursor.y = self.cursor.y + 1
    self.cursor.x = 0
    table.insert(self.text, self.cursor.y, "")
  else
    local pre, post = self:split_text_at_cursor()
    self.text[self.cursor.y] = pre
    self.cursor.y = self.cursor.y + 1
    self.cursor.x = 0
    table.insert(self.text, self.cursor.y, post)
  end
  self:render_text()
end

function i_field.key_commands.left(self)
  self.cursor.x = self.cursor.x - 1
  if self.cursor.x < 0 then
    if self.cursor.y > 1 then
      self.cursor.y = self.cursor.y - 1
      self.cursor.x = #self.text[self.cursor.y]
    else
      self.cursor.x = 0
    end
  end
  self:render_text()
end

function i_field.key_commands.right(self)
  self.cursor.x = self.cursor.x + 1
  if self.cursor.x > #self.text[self.cursor.y] then
    if self.cursor.y < #self.text then
      self.cursor.y = self.cursor.y + 1
      self.cursor.x = 0
    else
      self.cursor.x = #self.text[self.cursor.y]
    end
  end
  self:render_text()
end

function i_field.key_commands.up(self)
  if self.cursor.y > 1 then
    self.cursor.y = self.cursor.y - 1
    local ml = self:get_max_lines()
    if self.cursor.y < self.y_start then
      self.y_start = self.cursor.y
    end
    self:render_text()
  end
end

function i_field.key_commands.down(self)
  if self.cursor.y < #self.text then
    self.cursor.y = self.cursor.y + 1
    local ml = self:get_max_lines()
    if self.cursor.y > self.y_start + ml - 1 then
      self.y_start = self.y_start + 1
    end
    self:render_text()
  end
end

function i_field:check_key_pressed(k)
  if self.is_selected then
    self:backup()
    if engine.keys["lctrl"] or engine.keys["rctrl"] then
      if k == "z" then
        self:revert()
      elseif k == "s" then
        self:save_file()
        self.window.text = "Edit "..self.filepath
      elseif k == "=" then
        self.font_size = math.min(self.font_size + 2, 32)
        self:reload_font()
      elseif k == "-" then
        self.font_size = math.max(self.font_size - 2, 10)
        self:reload_font()
      end
    else
      if k == "return" then
        self.key_commands.enter(self)
        self:render_text()
      elseif k == "home" then
        self.cursor.x = 0
        self:render_text()
      elseif k == "end" then
        self.cursor.x = #self.text[self.cursor.y]
        self:render_text()
      end
      self.window.text = "Edit "..self.filepath.." *"
    end
    return true
  end
  return false
end

function i_field:key_released(k)
  self.repeat_timeout = self.repeat_max
end

function i_field:left_mouse_pressed()
  local mx, my = self:get_relative_mouse_position()
  local fw = self.font:getWidth(" ")
  local cx = math.floor(mx / fw)
  local cy = math.ceil(my / self.font:getHeight())
  local line_num = self:get_line_number(#self.text, cy)
  self.cursor.x = cx - (#line_num + 1)
  self.cursor.y = cy + (self.y_start - 1)
end

function i_field:on_scroll(s)
  if s > 0 then
    self.y_start = self.y_start > 1 and self.y_start - 1 or 1
  else
    self.y_start = self.y_start < #self.text and self.y_start + 1 or #self.text
  end
end

function i_field:update_call(dt)
  self.carat = "|"
  self.carat_blink = self.carat_blink + 1
  if not self.show_carat then
    self.carat = "_"
  end
  if self.carat_blink % self.blink_timer == 0 then
    self.show_carat = not self.show_carat
    self:render_text()
  end
  if self.is_selected then
    for k, v in pairs(self.key_commands) do
      if engine.keys[k] then
        if self.repeat_count >= self.repeat_timeout then
          self.key_commands[k](self)
          self.repeat_timeout = math.max(self.repeat_timeout - (dt * 20), dt)
          self.repeat_count = 0
          self:render_text()
          return true
        end
        self.repeat_count = self.repeat_count + 1
      end
    end
  end
end

function i_field:get_line_number(max, int)
  if max < 99 then
    return string.format("%02d", int)
  elseif max < 999 then
    return string.format("%03d", int)
  elseif max < 9999 then
    return string.format("%04d", int)
  elseif max < 99999 then
    return string.format("%05d", int)
  end
  return tostring(int).." "
end

function i_field:print_word(word, x, y, col)
  love.graphics.setColor(col)
  love.graphics.print(word, x, y)
end

function i_field:render_text()
  love.graphics.setCanvas(self.canvas)
  love.graphics.setBlendMode("replace")
  love.graphics.clear(0,0,0,0)
  love.graphics.setBlendMode("alpha")
  love.graphics.setColor(self.text_colour)
  local old_font = love.graphics.getFont()
  love.graphics.setFont(self.font)
  local total_lines = #self.text
  local max_lines = self:get_max_lines()
  local half_lines = math.floor(max_lines * .5)
  local y_start = self.y_start
  local x, y = 0, 0
  local lang = engine.code_templates[self.language]
  local block_execute = false
  for i = 0, max_lines - 1 do
    local line = y_start + i
    local x_offset = 0
    if self.text[line] then
      self:print_word(self.text[line], x + x_offset, y + ((i) * self.font:getHeight()), self.text_colour)
    end
  end
  love.graphics.setColor({1,1,1,1})
  love.graphics.setFont(old_font)
  love.graphics.setCanvas()
end

function i_field:extra_draw()
  self:set_colour({1,1,1,1})
  love.graphics.draw(self.canvas, self:get_position())
end

return i_field