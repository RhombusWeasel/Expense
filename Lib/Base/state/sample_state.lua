--[[Sample state example:
  This file is a template for the state management system,
  any inputs / update calls will be called from the main state and sent to the current state [engine.current_state].
  Below is a full list of all the supported functon calls that are available.
]]
local state = {}

--[[state.startup:
  Called only once on the first change to this state, state.startup is a good place to initialize your state.
  Anything that only needs to be setup once should be called here.
]]
function state.startup(...)
  
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
  
end

--[[state.draw:
  Called once per frame if it exists this function should handle all the state's draw calls.
]]
function state.draw()
  
end

return state