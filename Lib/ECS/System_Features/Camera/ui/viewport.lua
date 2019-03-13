local cam = engine.ui.base:extend()

function cam:setup(x, y, target)
  self.x_pos = x
  self.y_pos = y
  self.scale = 2
  self.speed = 10
  self.start_x = -1
  self.start_y = -1
  self.end_x = -1
  self.end_y = -1
  self.draw_box = false
  self.colour = {0,0,0,0}
  self.hover_colour = {0,0,0,0}
  self.image = "none"
  self.is_tiled = false
  self.hue = {0,0,0,0}
  self.track_target = target or 0
  self.scroll = {
    active = false,
    start = {x = 0, y = 0,},
    change = {x = 0, y = 0,},
    time = 1,
    elapsed = 0,
  }
  self.zoom = {
    start = {x = 0, y = 0,},
    change = {x = 0, y = 0,},
    time = 1,
    elapsed = 0,
  }
  self.active_canvas = love.graphics.newCanvas(self:get_size())
  self.star_canvas = love.graphics.newCanvas(self:get_size())
  self.renderers = {}
  local count = 1
  for k, v in pairs(engine.renderers) do
    self.renderers[count] = k
    if engine.renderers[k].setup ~= nil then
      engine.renderers[k].setup()
    end
    count = count + 1
  end
  self:add_hot_key(".", "zoom_in")
  self:add_hot_key(",", "zoom_out")
end

function cam:resize(w, h)
  self.active_canvas = love.graphics.newCanvas(w, h)
  self.star_canvas = love.graphics.newCanvas(w, h)
end

--CAMERA FUNCTIONS
function cam:get_world_bounds()
  local w, h = self:get_size()
  local scale_w = (w * self.scale) * 0.5
  local scale_h = (h * self.scale) * 0.5
  local minx = self.x_pos - scale_w
  local miny = self.y_pos - scale_h
  local maxx = self.x_pos + scale_w
  local maxy = self.y_pos + scale_h
  return minx, miny, maxx, maxy
end

function cam:get_world_size()
  local minx, miny, maxx, maxy = self:get_world_bounds()
  return maxx - minx, maxy - miny
end

function cam:check_renderer_requirements(obj)
  obj.render_list = {}
  for i = 1, #self.renderers do
    local pass = true
    for r = 1, #engine.renderers[self.renderers[i]].requirements do
      if obj[engine.renderers[self.renderers[i]].requirements[r]] == nil then
        pass = false
        break
      end
    end
    if pass then
      table.insert(obj.render_list, self.renderers[i])
    end
  end
end

function cam:zoom_out()
  local mx, my = self:get_mouse_position(engine.mousex, engine.mousey)
  self.scroll.start = {
    x = self.x_pos,
    y = self.y_pos,
  }
  self.scroll.change = {
    x = mx - self.x_pos,
    y = my - self.y_pos,
  }
  self.zoom.start = {
    x = self.scale,
    y = 0,
  }
  self.zoom.change = {
    x = self.scale * 2 < 2048 and self.scale * 2 or 0,
    y = 0,
  }
  self.scroll.active = true
end

function cam:zoom_in()
  local mx, my = self:get_mouse_position(engine.mousex, engine.mousey)
  self.scroll.start = {
    x = self.x_pos,
    y = self.y_pos,
  }
  self.scroll.change = {
    x = mx - self.x_pos,
    y = my - self.y_pos,
  }
  self.zoom.start = {
    x = self.scale,
    y = 0,
  }
  self.zoom.change = {
    x = self.scale * .5 > 0.0078125 and -self.scale * .5 or 0,
    y = 0,
  }
  self.scroll.active = true
end

function cam:get_screen_position(x, y)
  if y == nil then
    local ent = game.ecs:get_entity(x)
    x = ent.body.x
    y = ent.body.y
  end
  local minx, miny, maxx, maxy = self:get_world_bounds()
  local w, h = self:get_size()
  local px = engine.math.map(x, minx, maxx, 0, w)
  local py = engine.math.map(y, miny, maxy, h, 0)
  return px, py
end

function cam:get_mouse_position(x, y)
  local minx, miny, maxx, maxy = self:get_world_bounds()
  local w, h = self:get_size()
  local px = engine.math.map(x, 0, w, minx, maxx)
  local py = engine.math.map(y, h, 0, miny, maxy)
  return px, py
end

function cam:handle_controls()
  if engine.debug_ui.is_visible then return end
  if engine.keys[engine.hotkeys.camera.up] then
    self.y_pos = self.y_pos + (self.speed * self.scale)
    self.track_target = 0
  end
  if engine.keys[engine.hotkeys.camera.down] then
    self.y_pos = self.y_pos - (self.speed * self.scale)
    self.track_target = 0
  end
  if engine.keys[engine.hotkeys.camera.left] then
    self.x_pos = self.x_pos - (self.speed * self.scale)
    self.track_target = 0
  end
  if engine.keys[engine.hotkeys.camera.right] then
    self.x_pos = self.x_pos + (self.speed * self.scale)
    self.track_target = 0
  end
end

--UI FUNCTIONS
function cam:left_mouse_pressed()
  local mx, my = self:get_mouse_position(engine.mousex, engine.mousey)
  if self.label == "main_camera" then
    self.start_x = engine.mousex
    self.start_y = engine.mousey
  end
  
  game.ecs:clear_selection()
  if self.render_list then
    for i = 1, #self.render_list do
      local ent = game.ecs:get_entity(self.render_list[i])
      if ent.class == "ship" or ent.class == "station" then
        local hw = ent.body.w / 2
        local hh = ent.body.h / 2
        if mx > ent.body.x - hw and mx < ent.body.x + hw and my > ent.body.y - hh and my < ent.body.y + hh then
          game.ecs:select_entity(self.render_list[i])
          engine.log("Selecting "..self.render_list[i])
          return
        end
      end
    end
  end
  self.draw_box = true
end

function cam:left_mouse_released()
  if self.draw_box then
    local sx, sy = self:get_mouse_position(self.start_x, self.start_y)
    local ex, ey = self:get_mouse_position(engine.mousex, engine.mousey)
    local min_x = math.min(sx, ex)
    local min_y = math.min(sy, ey)
    local max_x = math.max(sx, ex)
    local max_y = math.max(sy, ey)
    game.ecs:clear_selection()
    if self.render_list then
      for i = 1, #self.render_list do
        local ent = game.ecs:get_entity(self.render_list[i])
        if ent.class == "ship" then
          if ent.body.x > min_x and ent.body.x < max_x and ent.body.y > min_y and ent.body.y < max_y then
            game.ecs:select_entity(self.render_list[i])
          end
        end
      end
    end
  end
  self.draw_box = false
end

function cam:right_mouse_released()
  game.ecs:clear_selection()
end

function cam:on_scroll(s)
  if s > 0 then
    self:zoom_in()
  else
    self:zoom_out()
  end
end

function cam:update_call(dt)
  if self.is_visible then
    if self.label == "main_camera" then
      self:handle_controls()
      for k, v in pairs(engine.renderers) do
        if engine.renderers[k].update ~= nil then
          engine.renderers[k].update(dt)
        end
      end
      if self.draw_box then
        self.end_x, self.end_y = engine.mousex, engine.mousey
      end
    end
    if self.scroll.active then
      if self.scroll.elapsed > self.scroll.time then
        self.scroll.active = false
        self.scroll.elapsed = 0
        self.zoom.elapsed   = 0
      else
        self.x_pos = engine.tween.ease_in_out(self.scroll.elapsed, self.scroll.start.x, self.scroll.change.x, self.scroll.time)
        self.y_pos = engine.tween.ease_in_out(self.scroll.elapsed, self.scroll.start.y, self.scroll.change.y, self.scroll.time)
        self.scale = engine.tween.ease_in_out(self.zoom.elapsed, self.zoom.start.x, self.zoom.change.x, self.zoom.time)
        self.scroll.elapsed = self.scroll.elapsed + dt
        self.zoom.elapsed   = self.zoom.elapsed   + dt
      end
    end
    if self.track_target ~= 0 then
      local ent = game.ecs:get_entity(self.track_target)
      self.x_pos = ent.body.x
      self.y_pos = ent.body.y
    end
    self:draw_canvas()
  end
end

function cam:draw_canvas()
  local minx, miny, maxx, maxy = self:get_world_bounds()
  local w, h = self.active_canvas:getDimensions()
  local render_wid, render_hig = self:get_world_size()
  self.render_list = game.entity_grid:get_entity_list(self.x_pos, self.y_pos, render_wid * 5, render_hig * 5)
  if self.render_list then
    love.graphics.setCanvas({self.active_canvas, stencil = true})
    love.graphics.clear(0,0,0,1)
    engine.shaders.starfield:send("iMapPosX", self.x_pos * (1 /(self.scale / 10)))
    engine.shaders.starfield:send("iMapPosY", -self.y_pos * (1 /(self.scale / 10)))
    engine.shaders.starfield:send("iResolutionX", w)
    engine.shaders.starfield:send("iResolutionY", h)
    engine.shaders.starfield:send("iScale", math.min(self.scale / 500, 4))
    love.graphics.setColor(1,1,1,1)
    love.graphics.setShader(engine.shaders.starfield)
    love.graphics.draw(self.star_canvas, 0, 0)
    love.graphics.setShader()
    if self.render_list[1] ~= nil then
      for i = 1, #self.render_list do
        local ent = game.ecs:get_entity(self.render_list[i])
        if ent ~= "none" then
          local x = engine.math.map(ent.body.x, minx, maxx, 0, w)
          local y = engine.math.map(ent.body.y, miny, maxy, h, 0)
          if ent.render_list == nil then
            self:check_renderer_requirements(ent)
          end
          for i = 1, #ent.render_list do
            local current = ent.render_list[i]
            engine.renderers[current].draw(x, y, 1 / self.scale, ent, self)
          end
        end
      end
    end
    love.graphics.setCanvas()
  end
end

function cam:draw_selection_box(sx, sy, ex, ey)
  local min_x = math.min(sx, ex)
  local min_y = math.min(sy, ey)
  local max_x = math.max(sx, ex)
  local max_y = math.max(sy, ey)
  local w = max_x - min_x
  local h = max_y - min_y
  local x = min_x
  local y = min_y
  love.graphics.setColor(0,1,0,1)
  love.graphics.rectangle("line", x, y, w, h)
end

function cam:extra_draw()
  local x, y = self:get_position()
  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(self.active_canvas, x, y)
  if self.label == "main_camera" then
    if self.draw_box then
      self:draw_selection_box(self.start_x, self.start_y, self.end_x, self.end_y)
    end
  end
end

return cam