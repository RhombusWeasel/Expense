return function (args)
  local files = love.filesystem.getDirectoryItems(engine.current_path)
  local file_list = {}
  local folder_list = {}
  for i = 1, #files do
    local info = love.filesystem.getInfo(engine.current_path.."/"..files[i])
    if info.type == "directory" then
      table.insert(folder_list, files[i])
    else
      table.insert(file_list, files[i])
    end
  end
  local sort_func = function(a, b) return a<b end
  table.sort(folder_list, sort_func)
  table.sort(file_list, sort_func)
  if folder_list[1] ~= nil then
    for i = 1, #folder_list do
      if args[1] == "long" or args[1] == "-l" then
        local f_type = engine.string.l_pad("Dir", 10)
        local f_name = engine.string.l_pad(folder_list[i], 20)
        engine.log(f_type..f_name)
      else
        engine.log(folder_list[i])
      end
    end
  end
  if file_list[1] ~= nil then
    for i = 1, #file_list do
      if args[1] == "long" or args[1] == "-l" then
        local info = love.filesystem.getInfo(engine.current_path.."/"..file_list[i])
        if info.size ~= nil then
          local size = math.round(info.size / 1000, 2)
          local f_type = engine.string.l_pad("File", 10)
          local f_name = engine.string.l_pad(file_list[i], 20)
          local f_size = engine.string.r_pad(tostring(size).."kb", 10)
          engine.log(f_type..f_name..f_size)
        end
      else
        engine.log(file_list[i])
      end
    end
  end
end