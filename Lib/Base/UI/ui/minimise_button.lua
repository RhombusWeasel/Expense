local max = engine.ui.base:extend()

function max:setup(func)
  self.image = "minimise_button"
  self.hover_image = "minimise_button_hover"
  self.display_image = "minimise_button"
  self:set_tile_dimensions(32, 32)
  self.x = 1
  self.y = 1
  self.w = 16
  self.h = 16
  self.win_button = true
  self.hue = {255,255,0,255}
  self.maxed = false
  self.trigger_move = true
  self.on_resize = func or function() engine.log(self.window.label.." no resize event set.") end
end

function max:left_mouse_released()
  if not self.maxed then
    local mw, mh = self.window.manager:get_size()
    self.lastx, self.lasty = self.window:get_position()
    self.lastw, self.lasth = self.window:get_size()
    self.window.x = 0
    self.window.y = 0
    self.window.w = mw
    self.window.h = mh
    self.window.is_maximized = true
    self.window.is_moveable = false
  else
    self.window.x = self.lastx
    self.window.y = self.lasty
    self.window.w = self.lastw
    self.window.h = self.lasth
    self.window.is_maximized = false
    self.window.is_moveable = true
  end
  self.maxed = not self.maxed
  self:on_resize()
end

function max:assert_size()
  self.trigger_move = true
end

function max:update_call(dt)
  if self.trigger_move then
    local w, h = self.window:get_size()
    self.x = w - (self.w + self.window.border_padding_right + 18)
    self.y = 4
    self.trigger_move = false
  end
end

return max