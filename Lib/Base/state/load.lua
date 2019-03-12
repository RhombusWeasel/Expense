local fs = love.filesystem
local function get_file_table(tab, path, folder)
  if fs.getInfo(path) then
    folder = folder or ""
    local file_list = fs.getDirectoryItems(path)
    for i = 1, #file_list do
      local file = file_list[i]
      local filepath = path.."/"..file
      local info = fs.getInfo(filepath)
      if info ~= nil then
        if info.type == "directory" then
          tab = get_file_table(tab, filepath, file)
        else
          local name = string.sub(file, 1, #file - 4)
          local ext = string.sub(file, #file - 3, #file)
          table.insert(tab, {path = filepath, folder = folder, file = name, ext = ext})
        end
      end
    end
  end
  return tab
end

--[[Load state:
  Loads all game and engine components and shows a pretty loading bar.
]]
local state = {}

--[[state.enter:
  This function if it exists will be called every time the game state is changed to this state.
]]
function state.enter()
  state.counter = 1
  state.file_list = get_file_table({}, "Lib")
  state.file_list = get_file_table(state.file_list, "Data")
  state.file_list = get_file_table(state.file_list, "Mods")
  state.canvas = love.graphics.newCanvas(engine.screen_width, engine.screen_height)
end

--[[state.exit:
  This function if it exists will be called once on state change before changing to the new state.
]]
function state.exit()
  love.graphics.setFont(engine.font[engine.current_font])
  engine.debug_ui = engine.prefab.debug_ui:new("debug_ui", 0, 0, .999, .999)
end

--[[state.resize:
  called on the all states when the window is resized, this function is passed the arguments [w] new window width and [h] new window height.
  This function is the only one that will be called for every state regardless of whether it is the current state or not.
]]
function state.resize(w, h)
  state.canvas = love.graphics.newCanvas(w, h)
end

--[[state.update:
  Update iterates through the file list one per update and loads the data.
  If the data is a lua library and has a function called library.on_load it will be called here.
]]
function state.update(dt)
  if state.file_list[state.counter] then
    local path = state.file_list[state.counter].path
    local folder = state.file_list[state.counter].folder
    local file = state.file_list[state.counter].file
    local ext = state.file_list[state.counter].ext
    if not engine[folder] then
      engine[folder] = {}
    end
    state.draw_screen("Loading: engine."..folder.."."..file)
    if ext == ".lua" then
      path = string.sub(path, 1, #path - 4)
      engine[folder][file] = require(path)
      if type(engine[folder][file]) == "table" and engine[folder][file]["on_load"] ~= nil then
        engine[folder][file].on_load(state.draw_screen)
      end
    elseif ext == ".png" then
      engine[folder][file] = love.graphics.newImage(path)
    elseif ext == ".sha" then
      engine[folder][file] = love.graphics.newShader(path)
    elseif ext == ".mp3" then
      engine[folder][file] = love.audio.newSource(path, "static")
    elseif ext == ".ttf" then
      engine[folder][file] = love.graphics.newFont(path, 10)
    end
    if engine[folder][file] ~= nil then
      engine.log("Loaded: engine."..folder.."."..file, "Load")
    end
    state.counter = state.counter + 1
  else
    engine.state.set(engine.open_state)
  end
end

function state.draw_screen(str)
  love.graphics.setCanvas(state.canvas)
  love.graphics.clear(0,0,0,1)
  local bw = 400
  local bh = 20
  local tw = font:getWidth(str)
  local fh = font:getHeight()
  local x = math.floor((engine.screen_width - tw) * .5)
  local y = math.floor((engine.screen_width / fh) * .5) * fh
  local bx = math.floor((engine.screen_width - bw) * .5)
  local by = y - 20
  local fill_wid = ((#state.file_list - (#state.file_list - state.counter)) / #state.file_list) * bw
  
  love.graphics.setColor(1,1,1,1)
  love.graphics.print(str, x, y)
  love.graphics.rectangle("line", bx, by, bw, bh)
  love.graphics.rectangle("fill", bx, by, fill_wid, bh)
  
  love.graphics.setCanvas()
  love.graphics.draw(state.canvas, 0, 0)
  love.graphics.present()
end

--[[state.draw:
  Called once per frame if it exists this function should handle all the state's draw calls.
]]
function state.draw(str)
  love.graphics.draw(state.canvas, 0, 0)
end

return state