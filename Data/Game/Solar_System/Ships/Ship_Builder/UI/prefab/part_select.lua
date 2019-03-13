local ps = engine.ui.window:extend()

function ps:setup()
  self.is_moveable = false
  self.is_tiled = true
  self.text = "Ship Builder."
  self.text_align_y = "top"
  self.text_padding_y = 5
  self.hue = {0, .8, .8, 1}
  self.window = self
  self.x = 0.003
  self.y = 0.005
  self.w = 0.3
  self.h = 0.99
end

return ps