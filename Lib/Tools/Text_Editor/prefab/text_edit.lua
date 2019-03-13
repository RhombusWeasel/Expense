function on_resize(self)
  local w, h = self.window:get_size()
  local tree = self.window:find_child("tree")
  tree.x = self.window.border_padding_left + 1
  tree.y = self.window.border_padding_top + 1
  tree.h = h - (self.window.border_padding_top + self.window.border_padding_bottom + 3)
  local tabs = self.window:find_child("tabs")
  tabs.x = self.window.border_padding_left + 1 + tree.w + self.object_padding_x
  tabs.y = self.window.border_padding_top + 1
  tabs.w = (w - tree.w) - (self.window.object_padding_x + self.border_padding_left + self.border_padding_right + 3)
  tabs.h = tree.h
  tabs:on_resize()
  tabs:assert_buttons()
  local cls = self.window:find_child("close")
  cls.trigger_move = true
  local max = self.window:find_child("max")
  max.trigger_move = true
end

local fh = font:getHeight()
local WIDTH = (fh * .5) * 100
local HEIGHT = (fh * 38) + 6

local editor = engine.ui.window:extend()

function editor:setup(path)
  WIDTH = engine.font[engine.current_font]:getWidth("a") * 100
  self.text = "Edit "..path
  self.text_align_y = "top"
  self.text_padding_y = 5
  self.is_moveable = true
  self.is_tiled = true
  self.filepath = path
  self.current_path = ""
  local name = string.sub(path, 2, #path)
  name = string.sub(name, 1, #name - 4)
  local tabs = engine.ui.tab:new("tabs", 0, 0, 2, 2, {path}, "r", "b")
        tabs.hue = {.2, .2, .2, 1}
        tabs.text_colour = {0,1,0,1}
        tabs:add_tab(name, engine.ui.code_input:new(name.."_canvas", 0, 0, WIDTH, HEIGHT, path))
        tabs:assert_buttons()
  
  local tree = engine.ui.file_tree:new("tree", 0, 0, 250, HEIGHT + 15, "/", 16)
        tree.h = tabs.h
        tree.hue = tabs.hue
        tree.text_colour = {0,1,0,1}
        function tree:on_file_click(btn)
          local tabs = self.window:find_child("tabs")
          if not self.window:find_child(btn.name) then
            if btn.ext == ".lua" then
              tabs:add_tab(btn.name, engine.ui.code_input:new(btn.path.."_canvas", 0, 0, WIDTH, HEIGHT, btn.path))
            elseif btn.ext == ".txt" then
              tabs:add_tab(btn.name, engine.ui.input_field:new(btn.path.."_canvas", 0, 0, WIDTH, HEIGHT, btn.path))
            end
          else
            tabs:set_visible(btn.path)
          end
          self:assert_size()
        end
  
  self:stack("r", "", tree)
  self:stack("r", "tree", tabs)
  self:add(engine.ui.close_button:new("close"))
  self:add(engine.ui.minimise_button:new("max", 0, 0, 1, 1, on_resize))
  self:add_reference("window", self)
end

return editor