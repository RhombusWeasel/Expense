local star_name = engine.ui.base:extend()
      function star_name:setup(i)
        self.show_background = false
        self.is_tiled = false
        self.text = game.ecs:get_entity(i).name
        self:calculate_size()
      end
      function star_name:left_mouse_pressed()
        self.parent:set_value(self.text)
      end
      function star_name:calculate_size()
        self.w = engine.font[engine.current_font]:getWidth(self.text) + (self.border_padding_left + self.border_padding_right)
      end
local star_select = engine.ui.dropdown:extend()
      function star_select:on_value_change()
        --self.window.current_star = self.value
      end

local econ = engine.ui.window:extend()

function econ:setup()
  self.x = 0
  self.y = 0
  self.w = 20
  self.h = 20
  self.current_star = 1
  self.hue = {.8,.8,.8,1}
  self:stack("b", "", star_select:new("star_select", 0, 0, 50, 20, game.starmap, star_name))
end

return econ