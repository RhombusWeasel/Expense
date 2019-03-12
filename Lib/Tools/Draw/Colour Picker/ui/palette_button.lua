local pb = engine.ui.base:extend()

function pb:setup(col)
  self.image = "none"
  self.colour = col
  self.hover_colour = col
end

function pb:left_mouse_pressed()
  if love.keyboard.isDown("lshift") then
    self.colour = self.window.left_colour
    self.hover_colour = self.window.left_colour
  else
    self.window.left_colour = self.colour
  end
end

function pb:right_mouse_pressed()
  if love.keyboard.isDown("lshift") then
    self.colour = self.window.right_colour
    self.hover_colour = self.window.right_colour
  else
    self.window.right_colour = self.colour
  end
end

return pb