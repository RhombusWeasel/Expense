--[[Ship Builder State:
  Ship building is how we construct ship classes in Expense, each ship is built up from various components which
  the player can use to construct their own class of ship.
  This gamestate will run seperately from the main gamestate to allow us to access this state from in game or from the game menu.
  
  Things we'll need:
    X A canvas to draw the new ship onto.
    A UI panel showing all the components available.
    A mouse object to allow the player to have a component "in hand".
    X A starry backdrop to look cool.
    A rendering system to draw any particle effects for engines etc.
]]

local state = {}

local function new_ship_canvas(scale, w, h)
  state.block_scale = scale
  state.block_width = w
  state.block_height = h
  state.ship_canvas = love.graphics.newCanvas(scale * w, scale * h)
end

--[[state.startup:
  Initialize the UI.
  Prepare the mouse object
]]
function state.startup(...)
  state.y_pos = 0
  state.star_canvas = love.graphics.newCanvas(engine.screen_width, engine.screen_height)
  state.ui = engine.ui.ui_container:new("main_ui", 0, 0, 0.999, 0.999)
  state.ui:add(engine.prefab.part_select:new("ship_builder", 0, 0, 0, 0))
  new_ship_canvas(32, 15, 21)
  state.cursor = {
    in_hand = ""
  }
  state.current_ship = {}
end

--[[state.enter:
  This function if it exists will be called every time the game state is changed to this state.
]]
function state.enter()
  
end

--[[state.exit:
  This function if it exists will be called once on state change before changing to the new state.
]]
function state.exit()
  
end

--[[state.resize:
  called on the all states when the window is resized, this function is passed the arguments [w] new window width and [h] new window height.
  This function is the only one that will be called for every state regardless of whether it is the current state or not.
]]
function state.resize(w, h)
  state.star_canvas = love.graphics.newCanvas(w, h)
  state.ui:normalize()
end

--[[state.key_pressed:
  This function if it exists will capture which key was pressed and pass it on as the argument [k], the unicode character is passed also as [c]
  and the final argument [r] will be true if the key has been held down, false on the first press
]]
function state.key_pressed(k, c, r)
  
end

--[[state.key_released:
  This function if it exists will capture which key was released and pass it on as the argument [k].
]]
function state.key_released(k)
  
end

--[[state.text_input:
  This function deals with actual text input as opposed to individual key presses, it is passed a single argument [t]
  a string of the text that was input
]]
function state.text_input(t)
  
end

--[[state.mouse_pressed:
  This function if it exists will pass the details of a mouse down event,
  [x] and [y] the screen coordinates of the click and [b] the number of the button pressed.
]]
function state.mouse_pressed(x, y, b)
  
end

--[[state.mouse_released:
  This function if it exists will pass the details of a mouse up event,
  [x] and [y] the screen coordinates of the click and [b] the number of the button pressed.
]]
function state.mouse_released(x, y, b)
  
end

--[[state.wheel_moved:
  This function if it exists will pass the details of a mouse scroll event,
  [x] and [y] the screen coordinates of the mouse and s the value of the scroll (negative is down and positive is up)
]]
function state.wheel_moved(x, y, s)
  
end

--[[state.update:
  This function is the main update call for the current state, it is called every frame if it exists and passed [dt] delta time.
]]
function state.update(dt)
  state.y_pos = state.y_pos - 10000
  engine.shaders.starfield:send("iMapPosX", 0)
  engine.shaders.starfield:send("iMapPosY", state.y_pos)
  engine.shaders.starfield:send("iResolutionX", engine.screen_width)
  engine.shaders.starfield:send("iResolutionY", engine.screen_height)
  engine.shaders.starfield:send("iScale", 1)
  state.ui:update(dt)
end

--[[state.draw:
  Called once per frame if it exists this function should handle all the state's draw calls.
]]
function state.draw()
  love.graphics.clear(0,0,0,.5)
  love.graphics.setColor(255,255,255,255)
  love.graphics.setShader(engine.shaders.starfield)
  love.graphics.draw(state.star_canvas, 0, 0)
  love.graphics.setShader()
  
  local third_wid = engine.screen_width / 3
  local x = (((third_wid * 2) - (state.block_width * state.block_scale)) / 2) + third_wid
  local y = (engine.screen_height - (state.block_height * state.block_scale)) / 2
  local wid = state.block_width * state.block_scale
  local hig = state.block_height * state.block_scale
  local sc = state.block_scale
  love.graphics.draw(state.ship_canvas, x, y)
  
  love.graphics.setColor(0,1,0,1)
  for w = 1, state.block_width do
    local v_x = x + ((w - 1) * sc)
    for h = 1, state.block_height do
      local st_y = y + ((h - 1) * sc)
      love.graphics.line(x, st_y, x + wid, st_y)
      love.graphics.line(v_x, y, v_x, y + hig)
    end
  end
  love.graphics.line(x, y + hig, x + wid, y + hig)
  love.graphics.line(x + wid, y, x + wid, y + hig)
  
  state.ui:draw()
end

return state