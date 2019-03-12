local tool = engine.ui.base:extend()

function tool:mouse_down(x, y, img, col) end

function tool:tool_used(x, y, img, col) end

function tool:mouse_up(x, y, img, col) end

function tool:extra_draw()
  if self.window.current_tool == self.label then
    local x, y = self:get_position()
    local w, h = self:get_size()
    love.graphics.setColor(0, 0, 0, 128)
    love.graphics.rectangle("line", x - 1, y - 1, w + 1, h + 1)
  end
end

return tool