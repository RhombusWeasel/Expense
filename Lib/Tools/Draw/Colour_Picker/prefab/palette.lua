local cols = {
  {name = "black",    col = {0, 0, 0, 1}},
  {name = "white",    col = {1, 1, 1, 1}},
  {name = "red",      col = {1, 0, 0, 1}},
  {name = "orange",   col = {.5, .5, 0, 1}},
  {name = "yellow",   col = {1, 1, 0, 1}},
  {name = "green",    col = {0, 1, 0, 1}},
  {name = "cyan",     col = {0, 1, 1, 1}},
  {name = "blue",     col = {0, 0, 1, 1}},
}

local function new_button(label, col)
  return engine.ui.palette_button:new(label, 0, 0, 64, 32, col)
end

local palette = engine.ui.base:extend()

function palette:setup()
  self.is_tiled = true
  self.border_padding_top = 5
  self.border_padding_bottom = 5
  self.object_padding_x = 3
  local last = "black"
  for i = 1, #cols, 2 do
    self:stack("r", last, new_button(cols[i].name, cols[i].col))
    self:stack("b", cols[i].name, new_button(cols[i + 1].name, cols[i + 1].col))
    last = cols[i].name
  end
  self:assert_size()
end

return palette