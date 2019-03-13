local fb = engine.ui.base:extend()

function fb:setup(line_height)
  local w, h = self:get_size()
  self.is_tiled = true
  self.current_line = 1
  self.max_lines = (h - 10) / line_height
  self.line_height = line_height
  self.selection = 0
  self.highlight_colour = {0,.5,1,1}
end

function fb:get_file_list()
  self.files = {
    {
      name = "..",
      icon = "back",
    }
  }
  local cur_dir = love.filesystem.getDirectoryItems(self.window.current_path)
  local path = self.window.current_path.."/"
  for _, file in pairs(cur_dir) do
    local data = {}
    local info = love.filesystem.getInfo(path..file)
    data.name = file
    if info.type == "directory" then
      data.icon = "folder"
    else
      local ext = string.sub(file, #file - 3, #file)
      if ext == ".png" then
        data.icon = "image"
      else
        data.icon = "file"
      end
    end
    table.insert(self.files, data)
  end
end

function fb:left_mouse_pressed()
  local x, y = engine.mousex, engine.mousey
  local px, py = self:get_position()
  local mx = x - px
  local my = y - py
  local line = math.ceil(my / self.line_height)
  if self.files[line] ~= nil then
    if self.selection == line then
      if self.files[line].icon == "folder" then
        self.window.current_path = self.window.current_path.."/"..self.files[line].name
        self.parent.current_file = ""
        self:get_file_list()
      elseif self.files[line].icon == "back" then
        self.window.current_path = engine.path.back(self.window.current_path)
        self.parent.current_file = ""
        self:get_file_list()
      else
        self.parent.current_file = self.files[line].name
      end
    else
      self.selection = line
      self.parent.current_file = self.files[line].name
    end
  end
end

function fb:update_call(dt)
  if self.files == nil then
    self:get_file_list()
  end
end

function fb:extra_draw()
  local px, py = self:get_position()
  local pw, ph = self:get_size()
  local start = self.current_line
  local finish = start + self.max_lines
  local h_inc = self.line_height
  if #self.files < self.max_lines then
    start = 1
    finish = #self.files
  end
  for i = start, finish do
    local y = (py + 5) + ((i - 1) * h_inc)
    local img = self.files[i].icon.."_icon"
    if i == self.selection then
      love.graphics.setColor(self.highlight_colour)
      love.graphics.rectangle("fill", px + 5, y, pw - 10, h_inc)
    end
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(engine.ui_assets[img], px + 3, y)
    love.graphics.setColor(self.text_colour)
    love.graphics.print(self.files[i].name, px + 20, y + 2)
  end
end

return fb