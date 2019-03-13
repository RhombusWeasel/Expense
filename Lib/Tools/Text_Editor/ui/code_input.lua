local i_field = engine.ui.input_field:extend()

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
  local font_w = self.font:getWidth(" ")
  local max_chars = math.floor(self.w / font_w)
  local y_start = self.y_start
  local x, y = 5, 3
  local lang = engine.code_templates[self.language]
  local block_execute = false
  for i = 1, #self.text do
    local line = i
    local line_num = self:get_line_number(#self.text, line)
    local x_offset = self.cursor.x < max_chars and 0 or ((self.cursor.x - max_chars) + (#line_num + 3)) * (font_w * -1)
    if self.text[line] then
      local str = line_num
      if line == self.cursor.y then
        local pre, post = self:split_text_at_cursor()
        str = str.." "..pre..self.carat..post
      else
        str = str.." "..self.text[line]
      end
      if string.sub(self.text[line], 1, 4) == "--[[" then
        block_execute = true
      elseif string.sub(self.text[line], #self.text[line] - 1, #self.text[line]) == "]]" then
        block_execute = false
      end
      if block_execute or string.sub(self.text[line], 1, 2) == "--" or string.sub(self.text[line], 1, 2) == "]]" then
        if line >= y_start and line <= y_start + max_lines then
          self:print_word(str, x + x_offset, y + ((line - y_start) * self.font:getHeight()), {.4,.4,.4,1})
        end
      else
        local words = engine.string.split_code(str)
        for j = 1, #words do
          if words[j] then
            local col = {1,1,1,1}
            local suffix = ""
            if lang[words[j]] ~= nil then
              col = lang[words[j]].col
            end
            if tonumber(words[j]) then
              col = {0,1,0,1}
              suffix = ""
            end
            
            local str_check = string.sub(words[j], 1, 1)
            if str_check == "'" or str_check == '"' then
              col = {1, 1, 0, 1}
              suffix = ""
              local count = 0
              for k = j + 1, #words do
                count = count + 1
                suffix = suffix..words[k]
                if words[k] == str_check then
                  break
                end
              end
              for k = count, 1, -1 do
                table.remove(words, j + k)
              end
            end
            if j == 2 then
              x_offset = #line_num * self.font:getWidth(" ")
            end
            if line >= y_start and line <= y_start + max_lines then
              self:print_word(words[j]..suffix, x + x_offset, y + ((line - y_start) * self.font:getHeight()), col)
            end
            x_offset = x_offset + self.font:getWidth(words[j]..suffix)
          end
        end
      end
    end
  end
  love.graphics.setColor({1,1,1,1})
  love.graphics.setFont(old_font)
  love.graphics.setCanvas()
end

return i_field