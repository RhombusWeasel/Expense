local function new_button(data, x, y, w, h)
  local trans = {0,0,0,0}
  local lab = data.label
  local btn = engine.ui.check_box:new(lab.."_cb", 0, 0, 16, 16)
        btn.is_tiled = false
        btn.can_hover = false
  local label = engine.ui.base:new(lab.."_lb", 0, 0, w - 18, h)
        label.text = data.text
        label.colour = trans
        label.hover_colour = trans
        label.image = "none"
        label.text_align_x = "left"
        label.text_align_y = "center"
        label.text_padding_x = 2
        label.text_padding_y = 2
        label.can_hover = false
  local box = engine.ui.base:extend()
        function box:setup()
          self.colour = trans
          self.hover_colour = trans
          self.border_padding_top = 2
          self.border_padding_bottom = 0
          self.border_padding_left = 2
          self.border_padding_right = 2
          self.is_tiled = true
          self:stack("r", "", btn)
          self:stack("r", btn.label, label)
          self.callback = data.func
        end
        function box:toggle(state)
          local cb = self:find_child(self.label.."_cb")
          cb:toggle(state)
        end
        function box:left_mouse_pressed()
          self.parent:clear_all()
          self.parent:set_value(self.label)
          self.callback(self.window)
        end
  return box:new(data.label, x, y, w, h + 6)
end

local rad = engine.ui.base:extend()

function rad:setup(buttons, text)
  self.image = engine.texture_pack.."_button_tiled"
  self.hover_image = engine.texture_pack.."_button_hover_tiled"
  if text == nil then
    self.border_padding_top = 4
    self.border_padding_bottom = 4
  else
    self.border_padding_top = 20
    self.text_padding_y = 6
    self.text_align_y = "top"
    self.text = text
  end
  self.is_tiled = true
  local x, y = 0, 5
  local w, h = self:get_size()
  h = 16
  self.h = (#buttons * h)
  local last_name = buttons[1].label
  for i = 1, #buttons do
    local name = buttons[i].label
    self:stack("b", last_name, new_button(buttons[i], 0, 0, w, h))
    last_name = name
  end
  self:set_value(buttons[1].label)
end

function rad:clear_all()
  for i = 1, #self.objects do
    self.objects[i]:toggle(false)
  end
end

function rad:set_value(label)
  local box = self:find_child(label)
  if box then
    box:toggle(true)
  end
end

return rad