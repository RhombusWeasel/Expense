local l_col = engine.ui.base:extend()
      function l_col:setup()
        self.image = "none"
      end
      function l_col:update_call(dt)
        self.colour = self.window.left_colour
        self.hover_colour = self.window.left_colour
      end

local r_col = engine.ui.base:extend()
      function r_col:setup()
        self.image = "none"
      end
      function r_col:update_call(dt)
        self.colour = self.window.right_colour
        self.hover_colour = self.window.right_colour
      end

local spacer = engine.ui.base:extend()
      function spacer:setup()
        self.image = "none"
      end

local cp = engine.ui.base:extend()

function cp:setup()
  self.text = "Palette"
  self.text_align_y = "top"
  self.text_padding_y = 5
  self.is_tiled = true
  self.is_moveable = true
  self.object_padding_x = 2
  self.object_padding_y = 2
  self.border_padding_top = 20
  self:stack("r", "", engine.ui.colour_ribbon:new("l_ribbon", 0, 0, 16, 256))
  self:stack("r", "l_ribbon", engine.ui.colour_palette:new("picker", 0, 0, 256, 256))
  self:stack("b", "picker", engine.ui.colour_ribbon:new("b_ribbon", 0, 0, 256, 16))
  self:stack("b", "l_ribbon", spacer:new("spacer", 0, 0, 16, 16))
  self:stack("b", "spacer", l_col:new("left_colour", 0, 0, 135, 20))
  self:stack("r", "left_colour", r_col:new("right_colour", 0, 0, 135, 20), 2)
  self:stack("b", "left_colour", engine.prefab.palette:new("palette", 0, 0, 1, 1))
end

function cp:update_call(dt)
  self.h = 405
  --local w, h = self:get_size()
  --local pw, ph = self.parent:get_size()
  --self.x = (pw - w) - 1
end

return cp