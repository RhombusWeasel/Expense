local cont = engine.ui.base:extend()

function cont:init(label, x, y, w, h, ...)
  self.label = label
  self.x = x
  self.y = y
  self.w = w
  self.h = h
  
  self.is_hovered = false
  self.is_moveable = false
  self.is_grabbed = false
  self.is_tiled = false
  self.is_visible = true
  self.is_scalable = true
  self.can_hover = false
  self.ignore_canvas = true
  self.show_text = true
  self.show_background = false
  
  self.image = "none"
  self.hover_image = "none"
  self.display_image = self.image
  self.is_tiled = false
  
  self.hue = {1,1,1,1}
  self.colour = {0,0,0,0}
  self.hover_colour = {0,0,0,0}
  self.display_colour = self.colour
  self.text_colour = {0,0,0,1}
  
  self.objects = {}
  self.draw_order = {}
  self.has_children = false
  self:setup(...)
  --self:assert_size()
end

function cont:assert_size()
  if self.has_children then
    for i = 1, #self.objects do
      self.objects[i]:assert_size()
    end
  end
end

function cont:add(obj, layer)
  layer = layer or 1
  obj.parent = self
  obj:add_reference("manager", self)
  table.insert(self.objects, layer, obj)
  table.insert(self.draw_order, 1, #self.objects)
  self.has_children = true
end

function cont:remove(label)
  local id = 0
  for i = 1, #self.objects do
    if self.objects[i].label == label then
      table.remove(self.objects, i)
      self:cull_draw_list()
      return true
    end
  end
  return false
end

function cont:check_hovered(mx, my)
  self.is_hovered = false
  return true
end

function cont:cull_draw_list()
  for i = #self.draw_order, 1, -1 do
    if self.objects[self.draw_order[i]] == nil then
      table.remove(self.draw_order, i)
    end
  end
end

function cont:normalize()
  if self.has_children then
    for i = 1, #self.objects do
      self.objects[i]:normalize()
    end
  end
end

function cont:update(dt)
  self:check_hovered(engine.mousex, engine.mousey)
  self:update_call(dt)
  if self.has_children then
    for i = 1, #self.objects do
      self.objects[i]:update(dt)
    end
  end
end

function cont:mouse_pressed(b)
  if not self.is_visible then return false end
  if self.has_children then
    for i = 1, #self.draw_order do
      local id = self.draw_order[i]
      if self.objects[id] ~= nil then
        if self.objects[id]:mouse_pressed(b) then
          if #self.objects > 1 then
            table.remove(self.draw_order, i)
            table.insert(self.draw_order, 1, id)
          end
          return true
        end
      end
    end
  end
  return false
end

function cont:mouse_released(b)
  if not self.is_visible then return false end
  self:reset_selection()
  if self.has_children then
    for i = 1, #self.draw_order do
      if self.objects[self.draw_order[i]]:mouse_released(b) then
        return true
      end
    end
  end
  return false
end

function cont:wheel_moved(y)
  if self.is_hovered then
    self:on_scroll(y)
    return true
  end
  if self.has_children then
    for i = 1, #self.draw_order do
      if self.objects[self.draw_order[i]]:wheel_moved(y) then
        return true
      end
    end
  end
  return false
end

function cont:text_input(t)
  if not self.is_visible then return false end
  if self.has_children then
    for i = 1, #self.draw_order do
      if self.objects[self.draw_order[i]]:text_input(t) then
        return true
      end
    end
  end
  return false
end

function cont:draw()
  if self.is_visible then
    self:draw_text()
    if self.has_children then
      for i = #self.draw_order, 1, -1 do
        local id = self.draw_order[i]
        if self.objects[id] ~= nil then
          self.objects[id]:draw()
        end
      end
    end
  end
end

return cont