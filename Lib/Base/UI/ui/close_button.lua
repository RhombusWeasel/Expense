local cb = engine.ui.base:extend()

function cb:setup()
  self.image = "close_button"
  self.hover_image = "close_button_hover"
  self.display_image = "close_button"
  self:set_tile_dimensions(32, 32)
  self.x = 1
  self.y = 4
  self.w = 16
  self.h = 16
  self.trigger_move = true
  self.hue = {1,.2,.2,1}
end

function cb:left_mouse_released()
  self.window.parent:remove(self.window.label)
end

function cb:assert_size()
  self.trigger_move = true
end

function cb:update_call(dt)
  if self.trigger_move then
    local w, h = self.window:get_size()
    local bpr = self.window.border_padding_right
    local opx = self.window.object_padding_x
    self.x = w - (self.w + bpr + opx)
    self.y = 4
    self.trigger_move = false
  end
end

return cb