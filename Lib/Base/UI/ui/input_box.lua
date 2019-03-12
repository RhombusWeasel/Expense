--[[Input Box
  A definable space for user input.
]]

local ib = engine.ui.base:extend()
      ib.key_commands = {}

function ib:setup(start_text)
  self.is_selected = true
  self.text_align_x = "left"
  self.text_padding_x = 5
  self.default_text = start_text and start_text or ""
  self.text = start_text and start_text or ""
  self.cursor = #self.text
  self.repeat_count = 0
  self.repeat_timeout = 3
end

function ib:split_text_at_cursor()
  if self.cursor == 0 then
    return "", self.text
  elseif self.cursor > #self.text then
    return self.text, ""
  else
    local str = self.text
    local pre_cursor = string.sub(str, 1, self.cursor)
    local post_cursor = string.sub(str, self.cursor + 1, #str)
    return pre_cursor, post_cursor
  end
end

function ib:check_text_input(t)
  if self.is_selected then
    local pre, post = self:split_text_at_cursor()
    self.text = pre..t..post
    self.cursor = self.cursor + #t < #self.text and self.cursor + #t or #self.text
    self:on_text_changed()
    return true
  end
  return false
end

function ib.key_commands.delete(self)
  if self.cursor == #self.text then return end
  local pre, post = self:split_text_at_cursor()
  post = string.sub(post, 2, #post)
  self.text = pre..post
end

function ib.key_commands.backspace(self)
  if self.cursor == 0 then return end
  local pre, post = self:split_text_at_cursor()
  pre = string.sub(pre, 1, #pre - 1)
  self.text = pre..post
  self.cursor = self.cursor - 1
end

function ib.key_commands.left(self)
  self.cursor = self.cursor - 1 > 0 and self.cursor - 1 or 0
end

function ib.key_commands.right(self)
  self.cursor = self.cursor + 1 < #self.text and self.cursor + 1 or #self.text
end

function ib:check_key_pressed(k)
  if self.is_selected then
    if k == "return" then
      self:on_text_confirm()
    elseif k == "home" then
      self.cursor = 0
    elseif k == "end" then
      self.cursor = #self.text
    end
    return true
  end
  return false
end

function ib:update_call(dt)
  if self.is_selected then
    for k, v in pairs(self.key_commands) do
      if engine.keys[k] then
        if self.repeat_count >= self.repeat_timeout then
          self.key_commands[k](self)
          self.repeat_count = 0
          return true
        end
        self.repeat_count = self.repeat_count + 1
      end
    end
  end
end

function ib:left_mouse_released()
  self.cursor = #self.text
end

function ib:on_text_confirm() end

function ib:on_text_changed() end

function ib:draw_text()
  local px, py = self:get_text_pos()
  local pw, ph = self:get_size()
  local char_w = engine.font[engine.current_font]:getWidth("a")
  local pre, post = self:split_text_at_cursor()
  local carat = ""
  if self.is_selected then
    carat = "|"
  end
  local str = pre..carat..post
  local max_char = math.floor(pw / char_w) - 2
  if #str > max_char then
    str = string.sub(str, #str - max_char, #str)
  end
  --love.graphics.print(str, x, y)
  love.graphics.setColor(self.text_colour)
  love.graphics.print(str, px, py)
end

return ib