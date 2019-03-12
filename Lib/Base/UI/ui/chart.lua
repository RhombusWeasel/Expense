local chart = engine.ui.base:extend()

function chart:setup(max_points)
  max_points = max_points ~= nil and max_points or 20
  self.points = {}
  self.max_points = max_points
  self.lowest = math.huge
  self.highest = 0
  self.colour = {0,0,0,0}
  self.line_colour = {0,1,0,1}
end

function chart:add_point(val)
  self.lowest = val < self.lowest and val or self.lowest
  self.highest = val > self.highest and val or self.highest
  table.insert(self.points, val)
  if #self.points > self.max_points then
    table.remove(self.points, 1)
  end
end

function chart:extra_draw()
  local x, y = self:get_position()
  local w, h = self:get_size()
  local max_points = #self.points
  local point_spacing = math.floor(w / max_points)
  local max_height = self.highest
  if self.points[2] ~= nil then
    love.graphics.setColor(self.line_colour)
    for i = 2, #self.points do
      local sx = x + ((i - 1) * point_spacing)
      local ex = x + (i * point_spacing)
      local sy = engine.math.map(self.points[i - 1], self.lowest, self.highest, 0, h)
      local ey = engine.math.map(self.points[i], self.lowest, self.highest, 0, h)
      love.graphics.line(sx + .5, (y + h) - sy, ex + .5, (y + h) - ey)
    end
  end
end

return chart