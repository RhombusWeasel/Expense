local fs = love.filesystem
local fb = engine.ui.base:extend()

function fb:setup(path, line_height)
  local w, h = self:get_size()
  line_height = line_height or 16
  self.is_tiled = true
  self.current_line = 1
  self.line_height = line_height
  self.max_lines = self:get_max_lines()
  self.selection = 0
  self.highlight_colour = {0,.5,1,1}
  self.root = path
  self.y_offset = 0
end

function fb:get_max_lines()
  local w, h = self:get_size()
  return math.floor((h - 10) / self.line_height)
end

function fb:get_file_list(tab, path, folder, str)
  if fs.getInfo(path) then
    folder = folder or ""
    str = str or ""
    local file_list = engine.path.list(path)
    for i = 1, #file_list do
      local file = file_list[i]
      local filepath = path.."/"..file
      local name = string.sub(file, 1, #file - 4)
      local ext = string.sub(file, #file - 3, #file)
      local info = fs.getInfo(filepath)
      if path == self.root then
        filepath = "/"..file
      end
      if info.type == "directory" then
        tab[file] = {
          name = file,
          ext = "",
          path = filepath,
          type = "folder",
          is_open = false,
          is_selected = false,
          contents = {}
        }
        tab[file].contents = self:get_file_list(tab[file].contents, filepath, file, str.."| ")
      else
        tab[name] = {
          name = name,
          ext = ext,
          path = filepath,
          type = "file",
          is_selected = false,
        }
      end
    end
  end
  return tab
end

function fb:deselect(tab)
  for k, v in pairs(tab) do
    tab[k].is_selected = false
    if tab[k].type == "folder" then
      self:deselect(tab[k].contents)
    end
  end
end

function fb:find_item_by_path(tab, path)
  for k, v in pairs(tab) do
    local p = tab[k].path
    if p == path then
      tab[k].is_selected = true
      return true
    end
    if tab[k].type == "folder" then
      self:find_item_by_path(tab[k].contents, path)
    end
  end
end

function fb:select_item_by_path(path)
  self:deselect(self.files)
  self:find_item_by_path(self.files, path)
end

function fb:left_mouse_pressed()
  local x, y = engine.mousex, engine.mousey
  local px, py = self:get_position()
  local mx = x - px
  local my = (y - py) + (self.y_offset * self.line_height)
  local line = math.ceil(my / self.line_height)
  if self.buttons[line] then
    if self.buttons[line].is_selected then
      if self.buttons[line].type == "folder" then
        self.buttons[line].is_open = not self.buttons[line].is_open
        self.buttons = self:get_button_list({}, self.files)
      else
        self:on_file_click(self.buttons[line])
      end
    else
      self:select_item_by_path(self.buttons[line].path)
    end
  end
end

function fb:on_file_click(btn) end

function fb:on_scroll(s)
  if s > 0 then
    self.y_offset = math.min(#self.buttons, self.y_offset + 1)
  else
    self.y_offset = math.max(0, self.y_offset - 1)
  end
end

function fb:update_call(dt)
  if self.files == nil then
    self.files = {}
    self.files.root = {
      name = self.root,
      ext = "",
      path = self.root,
      type = "folder",
      is_open = true,
      is_selected = false,
      contents = {}
    }
    self.files.root.contents = self:get_file_list(self.files.root.contents, self.root)
    self.buttons = self:get_button_list({}, self.files)
  end
end

function fb:get_button_list(list, tab, str)
  str = str or ""
  local sort = engine.table.sort_keys(tab)
  for i = 1, #sort do
    local k = sort[i]
    tab[k].str = str
    if tab[k].type == "folder" then
      if tab[k].is_open then
        tab[k].str = str.."v"
      else
        tab[k].str = str..">"
      end
      table.insert(list, tab[k])
      if tab[k].is_open then
        list = self:get_button_list(list, tab[k].contents, str.."|  ")
      end
    end
  end
  for i = 1, #sort do
    local k = sort[i]
    if tab[k].type == "file" then
      tab[k].str = string.sub(str, 1, #str - 2).."--"
      table.insert(list, tab[k])
    end
  end
  return list
end

function fb:extra_draw()
  local px, py = self:get_position()
  local pw, ph = self:get_size()
  local start = self.current_line + self.y_offset
  local finish = start + self:get_max_lines()
  local h_inc = self.line_height
  if #self.buttons < self.max_lines then
    start = 1
    finish = #self.buttons
  end
  for i = start, finish do
    if self.buttons[i] then
      local y = (py + 5) + (((i - self.y_offset) - 1) * h_inc)
      if y > py + 4 and y < ((py + 5) + (self.line_height * self:get_max_lines())) then
        local img = self.buttons[i].type.."_icon"
        local t_col = self.text_colour
        local b_col = self.hue
        local f_wid = engine.font[engine.current_font]:getWidth(self.buttons[i].str)
        local t_wid = engine.font[engine.current_font]:getWidth(self.buttons[i].name) + engine.font[engine.current_font]:getWidth(self.buttons[i].ext)
        if self.buttons[i].is_selected then
          t_col, b_col = b_col, t_col
          love.graphics.setColor(b_col)
          love.graphics.rectangle("fill", px + f_wid + 19, y, t_wid + 3, h_inc)
          love.graphics.print(self.buttons[i].str, px + 3, y + 2)
          love.graphics.setColor(t_col)
          love.graphics.print(self.buttons[i].name..self.buttons[i].ext, px + f_wid + 20, y + 2)
        else
          love.graphics.setColor(t_col)
          love.graphics.print(self.buttons[i].str, px + 3, y + 2)
          love.graphics.print(self.buttons[i].name..self.buttons[i].ext, px + f_wid + 20, y + 2)
        end
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(engine.ui_assets[img], px + 3 + f_wid, y)
      end
    end
  end
end

return fb