local li = engine.ui.base:extend()

function li:setup(text, start_text, func)
  local t = engine.ui.base:new("label", 0, 0, self.w * .5, 1)
        t.text = text
        t.text_align_x = "left"
        t.text_padding_x = 3
        t.image = "none"
        t.is_tiled = false
        t.colour = {0,0,0,0}
        t.hover_colour = {0,0,0,0}
  local input = engine.ui.input_box:new("input", 0, 0, self.w * .5, 1, start_text)
        input.on_text_confirm = func
        input.is_selected = false
        input.colour = {0,0,0,0}
        input.hover_colour = {0,0,0,0}
        input.text_align_x = "center"
        input.image = "none"
        input.is_tiled = false
  self.is_tiled = true
  self:add(t)
  self:stack("r", "label", input)
end

return li