return function (args)
  local file = ""
  local path = ""
  if args == nil then
    engine.log("ERROR: No filename given.")
    engine.log("USAGE: view [STR: filename] [OPT:STR: path]")
  elseif #args < 2 then
    path = engine.current_path
    file = args[1]
  else
    path = args[2]
    file = args[1]
  end
  filepath = path.."/"..file
  engine.log("Opening "..filepath..".")
  if love.filesystem.getInfo(filepath) then
    engine.debug_ui:add(engine.prefab.file_viewer:new(file, 0, 0, 2, 2, filepath))
  else
    engine.log("ERROR: No file found.")
  end
end