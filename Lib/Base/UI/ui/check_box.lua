local cb = engine.ui.base:extend()

function cb:setup(start_state)
  self.is_checked = start_state ~= nil and start_state or false
  if start_state then
    self.image = "check_box_on"
    self.hover_image = "check_box_on"
    self.display_image = "check_box_on"
  else
    self.image = "check_box_off"
    self.hover_image = "check_box_off"
    self.display_image = "check_box_off"
  end
  self.checked_image = "check_box_on"
  self.unchecked_image = "check_box_off"
end

function cb:toggle(bool)
  self.is_checked = bool
  if self.is_checked then
    self.display_image = self.checked_image
    self.image = self.checked_image
    self.hover_image = self.checked_image
    self:on_activate()
  else
    self.display_image = self.unchecked_image
    self.image = self.unchecked_image
    self.hover_image = self.unchecked_image
    self:on_deactivate()
  end
end

function cb:left_mouse_pressed()
  cb:toggle(not self.is_checked)
end

function cb:on_activate() end

function cb:on_deactivate() end

return cb