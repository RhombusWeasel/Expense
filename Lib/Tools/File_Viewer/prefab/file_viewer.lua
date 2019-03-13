local fv = engine.ui.base:extend()

function fv:setup(file)
  self.text = file
  self.text_align_y = "top"
  self.text_padding_y = 5
  self.is_moveable = true
  self.is_tiled = true
  local text = {}
  for v in love.filesystem.lines(file) do
    table.insert(text, v)
  end
  local tf = engine.ui.text_field:new("text", 0, 0, 800, 600, text)
        tf.image = "none"
        tf.colour = {0,0,0,1}
        tf.hover_colour = tf.colour
        tf.text_colour = {0,1,0,1}
        tf.is_tiled = false
        
  self:stack("r", "", tf)
  self:add(engine.ui.close_button:new("close", self.w - 23, 2, 19, 19, "debug_ui"))
  self:add_reference("window", self)
end

return fv