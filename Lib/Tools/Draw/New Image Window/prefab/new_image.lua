local function wid_func()
  engine.vars.draw.canvas_width = tonumber(self.text)
end

local function hig_func()
  engine.vars.draw.canvas_height = tonumber(self.text)
end

local ni = engine.ui.base:extend()

function ni:setup()
  self.w = 150
  self.h = 10
  self.is_tiled = true
  self.is_moveable = true
  self.text = "New Image"
  self.text_align_y = "top"
  self.text_padding_y = 5
  self:stack("b", "", engine.ui.labelled_input:new("width", 0, 0, 150, 20, "Width", "32", wid_func))
  self:stack("b", "width", engine.ui.labelled_input:new("height", 0, 0, 150, 20, "Height", "32", hig_func))
end

return ni