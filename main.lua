--[[MAIN FILE:
  This file serves as a state manager.
  Initializes two global tables, [game] and [engine].
  Initializes the load state which will recursively load all the assets/data in the game folders then setup the debug ui.
  
  The game table is where any game data like the map, the ui or the ECS data is stored.
  The engine table is where any file inside the project folder will be loaded to,
  files are loaded and labeled whatever the file was called in a table labled whatever the folder the file was in was called.
  For example ./Data/Game/state/game_main.lua would be loaded and stored in engine.state.game_main
  
  Images in .png format will be loaded as images in the same format that files are loaded (usually engine.assets.image_name.)
  Shaders can be defined with the extension ".sha" and will then be loaded in the same way as shader code.
  
  The state management aspect simply passes any inputs from the user to the current state engine.current_state.
  It will also call any update and draw functions you add to that state.
  A sample state file can be found in "/Lib/Base/state/sample_state.lua".
]]

utf8 = require("utf8")
font = love.graphics.newFont()
enet = require("enet")
local fs = love.filesystem

--[[Basic class library:
  This simple class lib is added to engine.class, you can create a new class by calling:-
  
  local new_class = engine.class:extend()
  
  Extend does support multiclassing so you can pass another class as an argument to extend.
]]
local class = {}

function class:extend(subClass)
  return setmetatable(subClass or {}, {__index = self})
end

function class:new(...)
  local inst = setmetatable({}, {__index = self})
  return inst, inst:init(...)
end

function class:init(...) end

--Create Log Folder:
if not love.filesystem.getInfo("/Debug") then
  fs.createDirectory("/Debug")
end

local log_data = fs.getDirectoryItems("/Debug")
for _, file in pairs(log_data) do
  fs.newFile("/Debug/"..file, "w")
end


game = {}
engine = {
  version = "0.3.1",
  current_state = "blank",
  open_state = "mp_state",
  draw_debug = false,
  current_path = "",
  running = true,
  game_speed = 1,
  mousex = 1,
  mousey = 1,
  mouse_button = 0,
  screen_width = 1280,
  screen_height = 720,
  hash_grid_size = 512,
  min_checks = math.huge,
  max_checks = 0,
  tile_width = 80,
  texture_pack = "dev",
  texture_variation = 5,
  current_font = "unispace rg",
  font_height = font:getHeight(),
  state = {
    load_state = require("/Lib/Base/state/load"),
  },
  ui = {},
  keys = {},
  particle_systems = {},
  class = class,
}

--[[math.round:
  Pass a number [n] and an amount of decimal places to round to [deci].
]]
function math.round(n, deci)
  deci = 10^(deci or 0)
  return math.floor(n*deci+.5)/deci
end

function engine.log_time()
  local date = os.date("!*t")
  for k, v in pairs(date) do
    if #tostring(v) < 2 then
      date[k] = "0"..v
    end
  end
  return "["..date.day.."/"..date.month.."/"..string.sub(date.year, 3, 4).."] "..date.hour..":"..date.min..":"..date.sec..": "
end

function engine.log(text, file, time_flag)
  if text then
    text = tostring(text)
  else
    text = ""
  end
  file = file or "stdout"
  local time = ""
  if not time_flag then
    time = engine.log_time()
  end
  text = time..text
  print(text)
  love.filesystem.append("/Debug/"..file..".txt", text.."\n")
  engine.console_update = true
end

--[[engine.state.set:
  This function is the only way a state change should be called,
  you can change the state by simply setting engine.current_state to some other string but using this method will
  ensure that the previous state exits gracefully and the new state definitely gets initialized properly.
]]
function engine.state.set(label, ...)
  engine.last_state = engine.current_state
  engine.current_state = label
  if engine.state[engine.last_state] then
    if engine.state[engine.last_state].exit ~= nil then
      engine.state[engine.last_state].exit()
    end
  end
  if not engine.state[label].initialized then
    if engine.state[label].startup ~= nil then
      engine.state[label].startup(...)
    end
    engine.state[label].initialized = true
  end
  
  if engine.state[label].enter ~= nil then
    engine.state[label].enter(...)
  end
end

function love.load(arg)
  love.window.setMode(engine.screen_width, engine.screen_height, {resizable=true,})
  --love.window.setFullscreen(true)
  local seed = os.time()
  math.randomseed(seed)
  love.math.setRandomSeed(seed)
  fs.createDirectory("/Mods")
  fs.createDirectory("/System")
  engine.save_directory = love.filesystem.getSaveDirectory()
  engine.state.set("load_state")
end

function love.resize(w, h)
  engine.screen_width, engine.screen_height = w, h
  for k, v in pairs(engine.state) do
    if engine.state[engine.current_state].resize ~= nil then
      engine.state[engine.current_state].resize(w, h)
    end
  end
end

function love.keypressed(k, c, r)
  if engine.current_state == "load_state" then return end
  engine.keys[k] = true
  if k == "tab" and (engine.keys["rctrl"] or engine.keys["lctrl"]) then
    engine.debug_ui.is_visible = not engine.debug_ui.is_visible
    return
  end
  if engine.debug_ui.is_visible then
    if engine.debug_ui:key_pressed(k) then return end
  end
  if engine.state[engine.current_state].key_pressed ~= nil then
    engine.state[engine.current_state].key_pressed(k, c, r)
  end
end

function love.keyreleased(k)
  if engine.current_state == "load_state" then return end
  engine.keys[k] = nil
  if engine.debug_ui.is_visible then
    if engine.debug_ui:key_released(k) then return end
  end
  if engine.state[engine.current_state].key_released ~= nil then
    engine.state[engine.current_state].key_released(k)
  end
end

function love.textinput(t)
  if engine.current_state == "load_state" then return end
  if engine.debug_ui.is_visible then
    if engine.debug_ui:text_input(t) then return end
  end
  if engine.state[engine.current_state].text_input ~= nil then
    engine.state[engine.current_state].text_input(t)
  end
end

function love.mousepressed(x, y, b)
  if engine.current_state == "load_state" then return end
  engine.mouse_button = b
  if engine.debug_ui.is_visible then
    if engine.debug_ui:mouse_pressed(b) then return end
  end
  if engine.state[engine.current_state].mouse_pressed ~= nil then
    engine.state[engine.current_state].mouse_pressed(x, y, b)
  end
end

function love.mousereleased(x, y, b)
  if engine.current_state == "load_state" then return end
  if engine.debug_ui.is_visible then
    if engine.debug_ui:mouse_released(b) then return end
  end
  if engine.state[engine.current_state].mouse_released ~= nil then
    engine.state[engine.current_state].mouse_released(x, y, b)
    engine.mouseButton = 0
  end
end

function love.wheelmoved(x, y)
  if engine.current_state == "load_state" then return end
  if engine.debug_ui.is_visible then
    if engine.debug_ui:wheel_moved(y) then return end
  end
  if engine.state[engine.current_state].wheel_moved ~= nil then
    engine.state[engine.current_state].wheel_moved(y)
  end
end

function love.update(dt)
  if engine.debug_ui and engine.debug_ui.is_visible then
    engine.debug_ui:update(dt)
  end
  if engine.state[engine.current_state].update ~= nil then
    engine.mouse_button = 0
    if love.mouse.isDown(1) then
      engine.mouse_button = 1
    elseif love.mouse.isDown(2) then
      engine.mouse_button = 2
    end
    engine.mousex, engine.mousey = love.mouse.getPosition()
    local w, h = love.graphics.getDimensions()
    if w ~= engine.screen_width or h ~= engine.screen_height then
      engine.screen_width, engine.screen_height = w, h
      love.resize(w, h)
    end
    engine.state[engine.current_state].update(dt)
  end
end

function love.draw()
  if engine.state[engine.current_state].draw ~= nil then
    engine.state[engine.current_state].draw()
  end
  if engine.debug_ui and engine.debug_ui.is_visible then
    local stats = love.graphics.getStats()
    stats.entity_count = 0
    if game.ecs ~= nil then
      stats.entity_count = game.ecs.max_entities
    end
    engine.debug_ui.text = {
      "FPS            : "..love.timer.getFPS(),
      "Draw calls     : "..stats.drawcalls,
      "Canvas Switches: "..stats.canvasswitches,
      "Texture Memory : "..math.round(stats.texturememory / 1024 / 1024, 3).."Mb.",
      "Images         : "..stats.images,
      "Canvases       : "..stats.canvases,
      "Entities       : "..stats.entity_count,
      "Hash grid size : "..engine.hash_grid_size,
      "Min Checks     : "..engine.min_checks,
      "Max Checks     : "..engine.max_checks,
    }
    engine.debug_ui:draw()
  end
end

function love.quit()
  game = nil
  engine = nil
  collectgarbage()
end
