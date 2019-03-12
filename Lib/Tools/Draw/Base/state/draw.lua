local draw = {}

function draw.backgroundCanvas(w, h)
  local canvas = love.graphics.newCanvas(w, h)
  local lastCanvas = love.graphics.getCanvas()
  local flick = true
  local grey = {128,128,128,255}
  local darkGrey = {100,100,100,255}
  love.graphics.setCanvas(canvas)
  for x = 0, w do
    for y = 0, h do
      if flick then
        love.graphics.setColor(grey)
      else
        love.graphics.setColor(darkGrey)
      end
      love.graphics.points(x, y)
      flick = not flick
    end
  end
  love.graphics.setCanvas(lastCanvas)
  return canvas
end

function draw.new_canvas()
  local w, h = engine.vars.draw.canvas_width, engine.vars.draw.canvas_height
  draw.layers = {}
  draw.layers[-1] = draw.backgroundCanvas(w, h)
  draw.layers[0]  = love.graphics.newCanvas(w, h)
  draw.layers[1]  = love.graphics.newCanvas(w, h)
  draw.current_layer = 1
end

function draw.startup()
  local w, h = engine.vars.draw.canvas_width, engine.vars.draw.canvas_height
  draw.ui = engine.prefab.draw_ui:new("draw_ui", 0, 0, 1, 1)
  draw.enter()
  draw.new_canvas()
  
  draw.image_width = w
  draw.image_height = h
  draw.image_offset_x = -(w * .5)
  draw.image_offset_y = -(h * .5)
  draw.scale = 2
end

function draw.enter()
  draw.min, draw.max, draw.anisotropic = love.graphics.getDefaultFilter()
  love.graphics.setDefaultFilter("nearest", "nearest", 0)
end

function draw.exit()
  if draw.initialized then
    love.graphics.setDefaultFilter(draw.min, draw.max, draw.anisotropic)
  end
end

function draw.resize(w, h)
  
end

function draw.save_image()
  love.filesystem.createDirectory("/Mods/User Sprites/assets")
  local folder = "User Sprites"
  local filename = engine.vars.toolbar.current_filename
  local path = "/Mods/"..folder.."/assets/"..filename..".png"
  local output = love.graphics.newCanvas(draw.image_width, draw.image_height)
  love.graphics.setCanvas(output)
  for i = 1, #draw.layers do
    love.graphics.draw(draw.layers[i], 0, 0)
  end
  output:newImageData():encode("png", path)
  love.graphics.setCanvas(lastCanvas)
  engine.assets[filename] = love.graphics.newImage(path)
end

function draw.mouse_pressed(x, y, b)
  if draw.ui:mouse_pressed(b) then return end
  local p_check, px, py = draw.get_image_pixel()
  if p_check then
    engine.vars.toolbar.last_click = b
    local tool = engine.vars.toolbar.current_tool
    local layer = draw.get_layer()
    local col = draw.get_colour()
    if engine.draw_tools[tool].mouse_down ~= nil then
      engine.draw_tools[tool]:mouse_down(px, py, draw.layers[layer], col)
    else
      draw.image_click()
    end
  end
end

function draw.mouse_released(x, y, b)
  if draw.ui:mouse_released(b) then return end
  local p_check, px, py = draw.get_image_pixel()
  if p_check then
    local tool = engine.vars.toolbar.current_tool
    local layer = draw.current_layer
    local col = draw.get_colour()
    if engine.draw_tools[tool].mouse_up ~= nil then
      engine.draw_tools[tool]:mouse_up(px, py, draw.layers[layer], col)
    end
  end
end

function draw.wheel_moved(x, y, s)
  if draw.ui:wheel_moved(s) then return end
  if s > 0 then
    draw.scale = draw.scale + 1
  elseif s < 0 then
    draw.scale = math.max(draw.scale - 1, 1)
  end
end

function draw.text_input(t)
  if draw.ui:text_input(t) then return end
end

function draw.get_image_position()
  local x = (engine.screen_width * .5) + (draw.image_offset_x * draw.scale)
  local y = (engine.screen_height * .5) + (draw.image_offset_y * draw.scale)
  return x, y
end

function draw.get_image_size()
  return draw.image_width * draw.scale, draw.image_height * draw.scale
end

function draw.get_image_pixel()
  local sx, sy = draw.get_image_position()
  local w, h = draw.get_image_size()
  local px = math.floor((engine.mousex - sx) / draw.scale)
  local py = math.ceil((engine.mousey - sy) / draw.scale)
  if px >= 0 and px < draw.image_width then
    if py >= 0 and py <= draw.image_width then
      return true, px, py
    end
  end
  return false
end

function draw.get_colour()
  local l_col = engine.vars.toolbar.left_colour
  local r_col = engine.vars.toolbar.right_colour
  if engine.vars.toolbar.last_click == 1 then
    return l_col
  elseif engine.vars.toolbar.last_click == 2 then
    return r_col
  end
  return {0,0,0,0}
end

function draw.get_layer()
  local tool = engine.vars.toolbar.current_tool
  if engine.draw_tools[tool].use_tool_canvas then
    return 0
  end
  return engine.vars.toolbar.current_layer
end

function draw.tool_used(x, y)
  if x < 0 or x > draw.image_width - 1 or y < 1 or y > draw.image_height then
    return
  end
  local tool = engine.vars.toolbar.current_tool
  local layer = draw.get_layer()
  local col = draw.get_colour()
  engine.draw_tools[tool]:tool_used(x, y, draw.layers[layer], col, draw.layers[0])
end

function draw.image_click(p_check, px, py)
  if p_check then
    draw.tool_used(px, py)
  end
end

function draw.update(dt)
  love.graphics.setCanvas(draw.layers[0])
  love.graphics.clear(0,0,0,0)
  love.graphics.setCanvas()
  draw.ui:update(dt)
  local p_check, px, py = draw.get_image_pixel()
  if (engine.mouse_button > 0 and engine.mouse_button <= 2) or engine.draw_tools[engine.vars.toolbar.current_tool].use_update then
    if p_check then
      draw.tool_used(px, py)
    end
  end
end

function draw.draw()
  local x, y = draw.get_image_position()
  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(draw.layers[-1], x + .5, y - .5, 0, draw.scale, draw.scale)
  for i = 1, #draw.layers do
    love.graphics.draw(draw.layers[i], x + .5, y - .5, 0, draw.scale, draw.scale)
  end
  love.graphics.draw(draw.layers[0], x + .5, y - .5, 0, draw.scale, draw.scale)
  draw.ui:draw()
end

return draw