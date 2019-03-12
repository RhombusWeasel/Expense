--[[In Game lua console:
  simple console system for in game editing.
  Print to this console by omitting the second argument to engine.log
  eg:
  engine.log("some text")
]]

local fh = font:getHeight()
local WIDTH = (fh * .5) * 100
local HEIGHT = (fh * 40) + 6

local function try(f)
  local status, exception = pcall(f)
  if not status then
    engine.log("ERROR: "..exception)
  end
end

local function load_code(code)
  try(loadstring(code))
end

local console = engine.ui.window:extend()

function console:setup()
  WIDTH = engine.font[engine.current_font]:getWidth("a") * 100
  self.w = WIDTH
  self.h = HEIGHT
  self.text = "Lua Console."
  self.text_align_y = "top"
  self.text_padding_y = 5
  self.border_padding_left = 5
  self.border_padding_right = 5
  self.border_padding_bottom = 5
  self.is_moveable = true
  self.is_tiled = true
  self.view_file = "stdout"
  love.filesystem.newFile("/Debug/stdout.txt", "w")
  
  local text_box = engine.ui.text_field:new("main_text", 7, 20, WIDTH, HEIGHT)
        text_box.hue = {0, 0, 0, 1}
        text_box.text_colour = {0, 1, 0, 1}
        text_box.text_padding_x = 5
        text_box.is_tiled = true
        function text_box:update_text()
          self.text = {}
          for line in love.filesystem.lines("/Debug/"..self.parent.view_file..".txt") do
            self:add_text(tostring(line))
          end
        end
        function text_box:left_mouse_released()
          self.parent:find_child("input").is_selected = true
        end

  local input_box = engine.ui.input_box:new("input", 7, 20, WIDTH, fh)
        input_box.colour = {0, 0, 0, 0}
        input_box.hover_colour = {0, 0, 0, 0}
        input_box.text_colour = {0, 1, 0, 1}
        input_box.text_padding_x = 5
        input_box.text_padding_y = 0
        input_box.history = {}
        input_box.text = ""
        input_box.cursor = #input_box.text
        input_box.history_count = 0
        input_box.history_max = 50
        input_box.image = "none"
        function input_box:split_text()
          return engine.string.split(self.text)
        end
        function input_box:update_pos()
          local tb = self.parent:find_child("main_text")
          local x, y = tb:get_position()
          local px, py = self.parent:get_position()
          local line_pos = (y - py) + tb.text_padding_y + (#tb.text * fh)
          local line_max = tb.h / fh
          local max_y = ((line_max) * fh) + tb.text_padding_y
          self.x = 7
          self.y = line_pos < max_y and line_pos or max_y
        end
        function input_box:draw_text()
          local px, py = self:get_text_pos()
          local pw, ph = self:get_size()
          local char_w = engine.font[engine.current_font]:getWidth("a")
          local pre, post = self:split_text_at_cursor()
          local carat = ""
          if self.is_selected then
            carat = "|"
          end
          local str = pre..carat..post
          local time = engine.log_time()
          local path = engine.current_path..">"
          local max_char = math.floor(pw / char_w) - 2
          if #str > max_char then
            str = string.sub(str, #str - max_char, #str)
          end
          self:set_colour(self.text_colour)
          love.graphics.print(time..path..str, px, py)
        end
        function input_box:update_memory(t)
          if t ~= self.history[1] then
            table.insert(self.history, 1, t)
            if #self.history > self.history_max then
              table.remove(self.history, 50)
            end
          end
        end
        function input_box:on_text_confirm()
          engine.log(self.text)
          local args = self:split_text()
          if string.find(self.text, "os.") then
            engine.log("ERROR: Sandboxed environment.")
          elseif engine.console_commands[args[1]] ~= nil then
            local command = args[1]
            table.remove(args, 1)
            engine.console_commands[command](args)
          else
            load_code(self.text)
          end
          self:update_memory(self.text)
          self.text = ""
          self.cursor = #self.text
          self.is_selected = true
          local tb = self.parent:find_child("main_text")
          tb:update_text()
          self:update_pos()
          self.history_count = 0
        end
        function input_box:memory_up()
          self.history_count = self.history_count + 1 <= #self.history and self.history_count + 1 or 0
          if self.history_count == 0 then
            self.text = ""
          else
            self.text = self.history[self.history_count]
          end
          self.cursor = #self.text
        end
        function input_box:memory_down()
          self.history_count = self.history_count - 1 > -1 and self.history_count - 1 or #self.history
          if self.history_count == 0 then
            self.text = ""
          else
            self.text = self.history[self.history_count]
          end
          self.cursor = #self.text
        end
        function input_box:draw_fallback() end
  
  self:add(text_box)
  self:add(input_box, 2)
  engine.console_commands.clear()
  self:find_child("main_text"):update_text()
  local ib = self:find_child("input")
  ib:update_pos()
  ib:add_hot_key("up", "memory_up")
  ib:add_hot_key("down", "memory_down")
end

function console:toggle_visible()
  self.is_visible = not self.is_visible
end

function console:update_call(dt)
  if engine.console_update then
    self:find_child("main_text"):update_text()
    self:find_child("input"):update_pos()
    engine.console_update = false
  end
end

return console