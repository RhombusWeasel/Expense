--[[UI Base class: - Pete Hunter
  
  The UI base class is a container capable of holding other UI objects.
  All objects are sized and positioned using relative or cartesian coordinates.
  Any x, y position or w, h size less than 1 are treated as a percentage of their parents size.
  Any x, y position or w, h size greater than 1 are treated as specific pixel sizes.
  
  The parent UI object must be updated using obj:update(dt) in the current state but each object will then update their children.
  This means that a fullscreen UI object can be made with all other UI objects inside it and only the parent needs to have
  it's update function called.  The same applies to clicks and other inputs.
  
]]

engine.ui_transparency = .6

local image_w, image_h = 16, 16
local quad_w = math.ceil(image_w * .25)
local quad_h = math.ceil(image_h * .25)

--CLASS INIT:
local cont = engine.class:extend()

cont.quads = {
  --Top row:
  top_left = love.graphics.newQuad(0, 0, quad_w, quad_h, image_w, image_h),
  top_middle = love.graphics.newQuad(quad_w, 0, quad_w * 2, quad_h, image_w, image_h),
  top_right = love.graphics.newQuad(image_w - quad_w, 0, quad_w, quad_h, image_w, image_h),
  --Middle row:
  mid_left = love.graphics.newQuad(0, quad_h, quad_w, quad_h * 2, image_w, image_h),
  mid_middle = love.graphics.newQuad(quad_w, quad_h, quad_w * 2, quad_h * 2, image_w, image_h),
  mid_right = love.graphics.newQuad(image_w - quad_w, quad_h, quad_w, quad_h * 2, image_w, image_h),
  --Bottom row:
  low_left = love.graphics.newQuad(0, image_h - quad_h, quad_w, quad_h, image_w, image_h),
  low_middle = love.graphics.newQuad(quad_w, image_h - quad_h, quad_w * 2, quad_h, image_w, image_h),
  low_right = love.graphics.newQuad(image_w - quad_w, image_h - quad_h, quad_w, quad_h, image_w, image_h),
}
cont.quad_w = quad_w
cont.quad_h = quad_h
cont.image_w = image_w
cont.image_h = image_h

function cont:init(label, x, y, w, h, ...)
  self.label = label
  self.x = x
  self.y = y
  self.w = w
  self.h = h
  
  self.is_hovered = false
  self.can_hover = true
  self.is_moveable = false
  self.is_grabbed = false
  self.is_visible = true
  self.is_scalable = true
  self.ignore_canvas = true
  self.show_text = true
  self.show_background = true
  self.fixed_size = false
  
  self.object_padding_x = 2
  self.object_padding_y = 2
  self.border_padding_left = 2
  self.border_padding_right = 2
  self.border_padding_top = 2
  self.border_padding_bottom = 2
  
  self.text = ""
  self.text_align_x = "center"
  self.text_align_y = "center"
  self.text_padding_x = 0
  self.text_padding_y = 5
  self.text_colour = {0,0,0,1}
  
  self.image = engine.texture_pack.."_button_tiled"
  self.hover_image = engine.texture_pack.."_button_hover_tiled"
  self.display_image = self.image
  self.sprite_batch = {
    [self.image] = love.graphics.newSpriteBatch(engine.ui_assets[self.image], 1, "dynamic"),
    [self.hover_image] = love.graphics.newSpriteBatch(engine.ui_assets[self.hover_image], 1, "dynamic"),
  }
  self:set_tile_dimensions(16, 16)
  
  self.hue = {1,1,1,1}
  self.colour = {0,0,0,0}
  self.hover_colour = {0,0,0,0}
  self.display_colour = self.colour
  
  self.objects = {}
  self.has_children = false
  
  self:base_init(...)
  self:setup(...)
  self:assert_size()
end

function cont:base_init(...) end

function cont:setup(...) end

function cont:set_tile_dimensions(image_w, image_h)
  if image_w ~= self.image_w or image_h ~= self.image_h then
    self.sprite_batch = {
      [self.image] = love.graphics.newSpriteBatch(engine.ui_assets[self.image], 1, "dynamic"),
      [self.hover_image] = love.graphics.newSpriteBatch(engine.ui_assets[self.hover_image], 1, "dynamic"),
    }
    local quad_w = math.ceil(image_w * .25)
    local quad_h = math.ceil(image_h * .25)
    self.quads = {
      --Top row:
      top_left = love.graphics.newQuad(0, 0, quad_w, quad_h, image_w, image_h),
      top_middle = love.graphics.newQuad(quad_w, 0, quad_w * 2, quad_h, image_w, image_h),
      top_right = love.graphics.newQuad(image_w - quad_w, 0, quad_w, quad_h, image_w, image_h),
      --Middle row:
      mid_left = love.graphics.newQuad(0, quad_h, quad_w, quad_h * 2, image_w, image_h),
      mid_middle = love.graphics.newQuad(quad_w, quad_h, quad_w * 2, quad_h * 2, image_w, image_h),
      mid_right = love.graphics.newQuad(image_w - quad_w, quad_h, quad_w, quad_h * 2, image_w, image_h),
      --Bottom row:
      low_left = love.graphics.newQuad(0, image_h - quad_h, quad_w, quad_h, image_w, image_h),
      low_middle = love.graphics.newQuad(quad_w, image_h - quad_h, quad_w * 2, quad_h, image_w, image_h),
      low_right = love.graphics.newQuad(image_w - quad_w, image_h - quad_h, quad_w, quad_h, image_w, image_h),
    }
    self.quad_w = quad_w
    self.quad_h = quad_h
    self.image_w = image_w
    self.image_h = image_h
  end
  self.is_tiled = true
end

--UTILITY FUNCTIONS:
function cont:add(obj, layer)
  layer = layer ~= nil and layer or 1
  table.insert(self.objects, layer, obj)
  self.objects[layer].parent = self
  self.objects[layer]:add_reference("manager", self.manager)
  self.objects[layer]:add_reference("window", self.window)
  self.has_children = true
  self:assert_size()
end

function cont:remove(id)
  table.remove(self.objects, id)
end

function cont:add_reference(label, obj)
  if self.has_children then
    for i = 1, #self.objects do
      self.objects[i]:add_reference(label, obj)
    end
  end
  self[label] = obj
end

function cont:get_target_dimensions(label)
  local tgt = self:find_child(label)
  local tx, ty = tgt:get_coordinates()
  local tw, th = tgt:get_size()
  return tx, ty, tw, th
end

function cont:stack(pos, target, obj, x_pad, y_pad, list_pos)
  x_pad = x_pad or 0
  y_pad = y_pad or 0
  local existing_id = self:find_child_id(obj.label)
  if not self:find_child(target) then
    obj.x = self.border_padding_left + self.object_padding_x + x_pad
    obj.y = self.border_padding_top + self.object_padding_y + y_pad
    if not existing_id then
      self:add(obj, list_pos)
    end
    return
  end
  local tx, ty, tw, th = self:get_target_dimensions(target)
  local ow, oh = obj:get_size()
  obj.x = tx
  obj.y = ty
  pos = string.lower(pos)
  if pos == "top" or pos == "up" or pos == "above" or pos == "t" or pos == "u" or pos == "a" then
    obj.y = ty - th - self.object_padding_y - y_pad
  elseif pos == "right" or pos == "r" then
    obj.x = tx + tw + self.object_padding_x + x_pad
  elseif pos == "bottom" or pos == "down" or pos == "below" or pos == "b" or pos == "d" then
    obj.y = ty + th + self.object_padding_y + y_pad
  elseif pos == "left" or pos == "l" then
    obj.x = tx - tw - self.object_padding_x - x_pad
  end
  if not existing_id then
    self:add(obj, list_pos)
  else
    self.objects[existing_id] = obj
  end
  self:stretch()
end

function cont:find_child_id(label)
  if self.has_children then
    for i = 1, #self.objects do
      if self.objects[i].label == label then
        return i
      end
    end
  end
  return false
end

function cont:find_child(label)
  if self.label == label then return self end
  if self.has_children then
    for i = 1, #self.objects do
      local child = self.objects[i]:find_child(label)
      if child ~= nil then
        return child
      end
    end
  end
end

function cont:find_parent(label)
  if self.parent == nil then
    return self
  elseif self.label == label then
    return self
  end
  return self.parent:find_parent(label)
end

function cont:normalize()
  if self.has_children then
    for i = 1, #self.objects do
      self.objects[i]:normalize()
    end
  end
  local pw, ph = self:get_parent_size()
  local w, h = self:get_size()
  local px, py = self:get_parent_position()
  local x, y = self:get_position()
  self.x = (x - px) / pw
  self.y = (y - py) / ph
  self.w = w / pw
  self.h = h / ph
end

--POSITIONAL FUNCTIONS
function cont:get_parent_position()
  local px, py = 0, 0
  if self.parent ~= nil then
    px, py = self.parent:get_position()
  end
  return px, py
end

function cont:get_parent_size()
  local pw, ph = engine.screen_width, engine.screen_height
  if self.parent ~= nil then
    pw, ph = self.parent:get_size()
  end
  return pw, ph
end

function cont:get_position()
  local pw, ph = self:get_parent_size()
  local px, py = self:get_parent_position()
  if self.x < 1 then
    local x = px + (pw * self.x)
    local y = py + (ph * self.y)
    return x, y
  end
  return px + self.x, py + self.y
end

function cont:get_coordinates()
  local pw, ph = self:get_parent_size()
  if self.x < 1 then
    return (pw * self.x), (ph * self.y)
  end
  return self.x, self.y
end

function cont:get_size()
  local pw, ph = self:get_parent_size()
  local px, py = self:get_parent_position()
  local w, h = self.w, self.h
  if self.w <= 1 then
    w = pw * self.w
  end
  if self.h <= 1 then
    h = ph * self.h
  end
  return w, h
end

function cont:stretch()
  if not self.has_children then return end
  if self.fixed_size then return end
  self.w = 0
  self.h = 0
  for i = 1, #self.objects do
    if self.objects[i].is_visible then
      local bpb = self.border_padding_bottom or 0
      local bpl = self.border_padding_left or 0
      local bpr = self.border_padding_right or 0
      local opx = self.object_padding_x or 0
      local opy = self.object_padding_y or 0
      local tx, ty, tw, th = self:get_target_dimensions(self.objects[i].label)
      local w = (tx + tw) + bpr + opx
      local h = (ty + th) + bpb + opy
      self.w = math.max(w, self.w)
      self.h = math.max(h, self.h)
    end
  end
end

function cont:assert_size()
  if self.has_children then
    for i = 1, #self.objects do
      self.objects[i]:assert_size()
    end
  end
  self:stretch()
end

function cont:get_text_pos(t)
  t = t or self.text
  local w, h = self:get_size()
  local x, y = self:get_position()
  local tw = engine.font[engine.current_font]:getWidth(t)
  local th = font:getHeight()
  local px = x + ((w - tw) * .5)
  local py = y + ((h - th) * .5)
  if self.text_align_x == "left" then
    px = x + self.text_padding_x
    py = y + self.text_padding_y
  elseif self.text_align_x == "right" then
    px = (x + w) - (tw + self.text_padding_x)
    py = y + self.text_padding_y
  end
  if self.text_align_y == "top" then
    py = y + self.text_padding_y
  elseif self.text_align_y == "bottom" then
    py = (y + h) - (th + self.text_padding_y)
  end
  return math.floor(px + .5), py
end

function cont:normalize()
  if self.has_children then
    for i = 1, #self.objects do
      self.objects[i]:normalize()
    end
  else
    local pw, ph = self:get_parent_size()
    local w, h = self:get_size()
    self.w = w / pw
    self.h = h / ph
    engine.log("Normalizing "..self.label..": "..self.w..", "..self.h)
  end
end

--KEY PRESS FUNCTIONS
function cont:key_pressed(k)
  if not self.is_visible then return false end
  if not self:check_hot_keys(k) then
    if self.has_children then
      for i = 1, #self.objects do
        if self.objects[i]:key_pressed(k) then
          return true
        end
      end
    elseif self:check_key_pressed(k) then
      return true
    end
  end
  return false
end

function cont:key_released(k)
  if not self.is_visible then return false end
  if self.has_children then
    for i = 1, #self.objects do
      if self.objects[i]:key_released(k) then
        return true
      end
    end
  elseif self:check_key_released(k) then
    return true
  end
  return false
end

function cont:add_hot_key(k, func_name)
  if self.hot_keys == nil then self.hot_keys = {} end
  self.hot_keys[k] = func_name
end

function cont:check_hot_keys(k)
  if self.hot_keys ~= nil then
    if self.hot_keys[k] ~= nil then
      self[self.hot_keys[k]](self)
      return true
    end
  end
  return false
end

function cont:check_key_pressed(k) end

function cont:check_key_released(k) end

--LOVE CALLBACK FUNCTIONS:
function cont:check_hovered(mx, my)
  if self.can_hover then
    local w, h = self:get_size()
    local x, y = self:get_position()
    self.is_hovered = false
    self.display_colour = self.colour
    self.display_image = self.image
    if mx >= x and mx <= x + w then
      if my >= y and my <= y + h then
        if self.parent ~= nil then
          self.parent.is_hovered = false
          self.parent.display_colour = self.parent.colour
          self.parent.display_image = self.parent.image
        end
        self.is_hovered = true
        self.display_colour = self.hover_colour
        self.display_image = self.hover_image
        return true
      end
    end
  end
  return false
end

function cont:grab_move()
  if self.is_grabbed and self.is_moveable then
    local mx, my = self:get_parent_position()
    local x = (engine.mousex - (mx + self.grab_x))
    local y = (engine.mousey - (my + self.grab_y))
    self.x = x
    self.y = y
  end
end

function cont:rectify_position()
  if self.is_moveable and not self.is_maximized then
    local mw, mh = self.parent:get_size()
    local x, y = self.x, self.y
    local w, h = self:get_size()
    if x > mw - w then
      self.x = mw - w
    end
    if x < 1 then
      self.x = 1.1
    end
    if y > mh - h then
      self.y = mh - h
    end
    if y < 1 then
      self.y = 1.1
    end
  end
end

function cont:update(dt)
  self:check_hovered(engine.mousex, engine.mousey)
  self:base_update(dt)
  self:update_call(dt)
  self:grab_move()
  self:rectify_position()
  if self.has_children then
    for i = 1, #self.objects do
      self.objects[i]:update(dt)
    end
  end
  self:draw_tiled_image()
  self:extra_update(dt)
end

function cont:base_update(dt) end

function cont:update_call(dt) end

function cont:extra_update(dt) end

function cont:get_relative_mouse_position()
  local mx, my = love.mouse.getPosition()
  local px, py = self:get_position()
  return mx - px, my - py
end

function cont:mouse_pressed(b)
  self:assert_mouse_pressed()
  if not self.is_visible then return false end
  self:reset_selection()
  if self.is_hovered then
    if b == 1 then
      self:left_mouse_pressed()
    elseif b == 2 then
      self:right_mouse_pressed()
    end
    local x, y = self:get_position()
    self.is_grabbed = true
    self.grab_x = engine.mousex - x
    self.grab_y = engine.mousey - y
    return true
  end
  if self.has_children then
    for i = #self.objects, 1, -1 do
      if self.objects[i]:mouse_pressed(b) then
        return true
      end
    end
  end
  return false
end

function cont:left_mouse_pressed() end

function cont:right_mouse_pressed() end

function cont:assert_mouse_pressed() end

function cont:mouse_released(b)
  if not self.is_visible then return false end
  self:reset_selection()
  if self.is_hovered then
    if b == 1 then
      self:left_mouse_released()
    else
      self:right_mouse_released()
    end
    self.is_selected = true
    return true
  end
  if self.has_children then
    for i = #self.objects, 1, -1 do
      if self.objects[i]:mouse_released(b) then
        return true
      end
    end
  end
  self:assert_mouse_released()
  return false
end

function cont:left_mouse_released() end

function cont:right_mouse_released() end

function cont:assert_mouse_released() end

function cont:wheel_moved(s)
  if self.is_hovered then
    self:on_scroll(s)
    return true
  end
  if self.has_children then
    for i = 1, #self.objects do
      if self.objects[i].is_visible then
        if self.objects[i]:wheel_moved(s) then
          return true
        end
      end
    end
  end
  return false
end

function cont:on_scroll(s) end

function cont:reset_selection()
  self.is_selected = false
  self.is_grabbed = false
  if self.has_children then
    for i = 1, #self.objects do
      self.objects[i]:reset_selection()
    end
  end
end

function cont:text_input(t)
  if not self.is_visible then return false end
  if not self:check_text_input(t) then
    if self.has_children then
      for i = 1, #self.objects do
        if self.objects[i]:text_input(t) then
          return true
        end
      end
    end
  else
    return true
  end
  return false
end

function cont:check_text_input() end

--DRAW FUNCTIONS:

function cont:set_colour(c)
  love.graphics.setColor(c[1], c[2], c[3], engine.ui_transparency)
end

function cont:draw_text()
  if self.show_text then
    self:set_colour(self.text_colour)
    if type(self.text) == "string" then
      love.graphics.print(self.text, self:get_text_pos())
    elseif type(self.text) == "table" then
      local h = engine.font[engine.current_font]:getHeight()
      local x, y = self:get_text_pos(self.text[1])
      for i = 1, #self.text do
        love.graphics.print(self.text[i], x, y)
        y = y + h
      end
    end
  end
end

function cont:draw_fallback()
  self:set_colour(self.display_colour)
  local x, y = self:get_position()
  love.graphics.rectangle("fill", x, y, self:get_size())
end

function cont:draw_tiled_image()
  if self.is_visible and self.is_tiled then
    if self.display_image == "none" then
      return
    end
    local x, y = self:get_position()
    local w, h = self:get_size()
    if self.draw_to_canvas then
      x, y = 0, 0
    end
    local qw, qh = self.quad_w, self.quad_h
    local leftx = x
    local midx = x + qw
    local rightx = x + (w - qw)
    local midy = y + qh
    local lowy = y + (h - qh)
    local sizex = (w - (qw * 2)) / (qw * 2)
    local sizey = (h - (qh * 2)) / (qh * 2)
    self.sprite_batch[self.display_image]:clear()
    self.sprite_batch[self.display_image]:add(self.quads.top_left,   leftx,  y,    0, 1,     1)
    self.sprite_batch[self.display_image]:add(self.quads.top_middle, midx,   y,    0, sizex, 1)
    self.sprite_batch[self.display_image]:add(self.quads.top_right,  rightx, y,    0, 1,     1)
    self.sprite_batch[self.display_image]:add(self.quads.mid_left,   leftx,  midy, 0, 1,     sizey)
    self.sprite_batch[self.display_image]:add(self.quads.mid_middle, midx,   midy, 0, sizex, sizey)
    self.sprite_batch[self.display_image]:add(self.quads.mid_right,  rightx, midy, 0, 1,     sizey)
    self.sprite_batch[self.display_image]:add(self.quads.low_left,   leftx,  lowy, 0, 1,     1)
    self.sprite_batch[self.display_image]:add(self.quads.low_middle, midx,   lowy, 0, sizex, 1)
    self.sprite_batch[self.display_image]:add(self.quads.low_right,  rightx, lowy, 0, 1,     1)
    self.sprite_batch[self.display_image]:flush()
  end
end

function cont:draw_image()
  
end

function cont:draw()
  if self.is_visible then
    if self.show_background then
      if self.canvas and not self.ignore_canvas then
        love.graphics.setCanvas(self.canvas)
        self.draw_to_canvas = true
      end
      self:set_colour(self.hue)
      if self.image == "none" then
        self:draw_fallback()
      elseif self.is_tiled then
        love.graphics.draw(self.sprite_batch[self.display_image])
      else
        love.graphics.draw(engine.ui_assets[self.display_image], self:get_position())
      end
    end
    self:draw_text()
    self:extra_draw()
    if self.has_children then
      for i = 1, #self.objects do
        self.objects[i]:draw()
      end
    end
    if self.canvas and not self.ignore_canvas then
      love.graphics.setCanvas()
      love.graphics.draw(self.canvas, self:get_position())
    end
  end
end

function cont:extra_draw() end

return cont