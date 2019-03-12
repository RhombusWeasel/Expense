local f = engine.ui.tool_button:extend()

function f:setup()
  self.path = {}
  self.use_update = true
  self.count = 0
  self.modulo = 1
  self.image = "fill_button"
  self.hover_image = "fill_button"
  self.is_tiled = false
end

function f:left_mouse_pressed()
  self.window.current_tool = "fill"
end

function f:pick_direction(x, y, n)
  if n == 1 then
    return x, y - 1
  elseif n == 2 then
    return x + 1, y
  elseif n == 3 then
    return x, y + 1
  end
  return x - 1, y
end

function f:check_target(x, y, img, col, dat)
  local w = img:getWidth()
  local h = img:getHeight()
  if x < 0 or x > w - 1 or y < 1 or y > h then
    return false
  end
  local r, g, b, a = dat:getPixel(x, y - 1)
  local border = self.window.edge_colour
  col_check = (r == self.col[1] and g == self.col[2] and b == self.col[3] and a == self.col[4])
  edge_check = (r == border[1] and g == border[1] and b == border[2] and a == border[4])
  if col_check then
    return false
  elseif edge_check then
    return false
  end
  return true
end

function f:blit(x, y, img, col)
  love.graphics.points(x, y)
end

function f:mouse_down(x, y, img, col)
  engine.log("Click at: "..x..", "..y..".")
  self.path = {
    {x = x, y = y,},
  }
  self.col = col
  self:blit(x, y, img, col)
end

function f:tool_used(x, y, img, col, t_canvas)
  self.count = self.count + 1
  local pos = #self.path
  if self.count % self.modulo ~= 0 then return end
  local dat = img:newImageData()
  love.graphics.setCanvas(img)
  love.graphics.setColor(col)
  for i = 1, img:getWidth() * 2 do
    pos = #self.path
    if self.path[pos] == nil then
      love.graphics.setCanvas()
      return
    end
    local px = self.path[pos].x
    local py = self.path[pos].y
    if self:check_target(px, py - 1, img, col, dat) then
      table.insert(self.path, {x = px, y = py - 1})
      love.graphics.points(px, py - 1)
      dat:setPixel(px, py - 2, col[1], col[2], col[3], col[4])
    elseif self:check_target(px + 1, py, img, col, dat) then
      table.insert(self.path, {x = px + 1, y = py})
      love.graphics.points(px + 1, py)
      dat:setPixel(px + 1, py - 1, col[1], col[2], col[3], col[4])
    elseif self:check_target(px, py + 1, img, col, dat) then
      table.insert(self.path, {x = px, y = py + 1})
      love.graphics.points(px, py + 1)
      dat:setPixel(px, py, col[1], col[2], col[3], col[4])
    elseif self:check_target(px - 1, py, img, col, dat) then
      table.insert(self.path, {x = px - 1, y = py})
      love.graphics.points(px - 1, py)
      dat:setPixel(px - 1, py - 1, col[1], col[2], col[3], col[4])
    else
      table.remove(self.path)
    end
  end
  love.graphics.setCanvas()
end

return f