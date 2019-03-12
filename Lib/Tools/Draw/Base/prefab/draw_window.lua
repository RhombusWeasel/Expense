local function on_resize(self)
  local ui = self.window:find_child("ui")
  ui.x = 4
  ui.y = 21
  ui.w = self.window.w - 8
  ui.h = self.window.h - 26
  local can = self.window:find_child("canvas")
  can.x = 4
  can.y = 21
  can.w = self.window.w - 8
  can.h = self.window.h - 26
  local cls = self.window:find_child("close")
  cls.trigger_move = true
  local max = self.window:find_child("max")
  max.trigger_move = true
end

local win = engine.ui.window:extend()

function win:setup(name, w, h)
  self.is_moveable = true
  self.is_tiled = true
  self.text = name
  self.filename = name
  self.text_align_y = "top"
  self.text_padding_y = 5
  self.hue = {0, .8, .8, 1}
  
  for k, v in pairs(engine.vars.toolbar) do
    self[k] = v
  end
  
  self.image_w = w
  self.image_h = h
  
  local wid, hig = self:get_size()
  self:add(engine.prefab.draw_ui:new("ui", 4, 21, wid - 8, hig - 26))
  self:add(engine.ui.canvas:new("canvas", 4, 21, wid - 8, hig - 26, w, h))
  self:add(engine.ui.close_button:new("close", self.w - 23, 5, 10, 10))
  self:add(engine.ui.minimise_button:new("max", self.w - 40, 2, 18, 18, on_resize))
end

return win