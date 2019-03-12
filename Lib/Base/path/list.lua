return function (path)
  path = path or engine.current_path
  local sort_func = function(a, b) return a<b end
  local files = love.filesystem.getDirectoryItems(path)
  local return_list = {}
  local file_list = {}
  local folder_list = {}
  for i = 1, #files do
    local info = love.filesystem.getInfo(path.."/"..files[i])
    if info.type == "directory" then
      table.insert(folder_list, files[i])
    else
      table.insert(file_list, files[i])
    end
  end
  table.sort(folder_list, sort_func)
  if folder_list[1] ~= nil then
    for i = 1, #folder_list do
      table.insert(return_list, folder_list[i])
    end
  end
  table.sort(file_list, sort_func)
  if file_list[1] ~= nil then
    for i = 1, #file_list do
      table.insert(return_list, file_list[i])
    end
  end
  return return_list
end