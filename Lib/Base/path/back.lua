return function (path)
  path = path or engine.current_path
  local split_path = engine.path.split(path, '[\\/]+')
  local last_folder = split_path[#split_path]
  local p = ""
  for i = 1, #split_path - 1 do
    p = p.."/"..split_path[i]
  end
  return p
end