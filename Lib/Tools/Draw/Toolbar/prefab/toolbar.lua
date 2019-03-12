local function line(win)
  win.fill_type = "line"
end

local function fill(win)
  win.fill_type = "fill"
end

local fill_select = {
  {
    label = "fill_select",
    text = "Fill",
    func = fill,
  },
  {
    label = "line_select",
    text = "Line",
    func = line,
  },
}

local save_btn = engine.ui.base:extend()
      function save_btn:setup()
        self.is_tiled = true
        self.text = "Save"
      end
      function save_btn:left_mouse_pressed()
        local info = love.filesystem.getInfo("/Mods")
        if not info then
          love.filesystem.createDirectory("/Mods")
        end
        info = love.filesystem.getInfo("/Mods/User")
        if not info then
          love.filesystem.createDirectory("/Mods/User")
          love.filesystem.createDirectory("/Mods/User/assets")
          love.filesystem.createDirectory("/Mods/User/ui_assets")
        end
        local path = "/Mods/User/assets/"..self.window.filename..".png"
        local can_obj = self.window:find_child("canvas")
        local target = love.graphics.newCanvas(self.window.image_w, self.window.image_h)
        love.graphics.setCanvas(target)
        love.graphics.setColor(255,255,255,255)
        for i = 1, #can_obj.layers do
          if can_obj.layers[i].draw then
            love.graphics.draw(can_obj.layers[i].canvas, 0, 0)
          end
        end
        love.graphics.setCanvas()
        target:newImageData():encode("png", path)
        engine.log("Image saved to "..path)
      end

local open_btn = engine.ui.base:extend()
      function open_btn:setup()
        self.is_tiled = true
        self.text = "Open"
      end
      function open_btn:left_mouse_pressed()
        local exp = engine.prefab.file_explorer:new("explorer", 0, 0, 10, 10)
        exp:add_reference("window", self.window)
        self.parent.parent:add(exp)
      end

local tb = engine.ui.base:extend()

function tb:setup()
  self.x = 0
  self.y = 0
  self.w = 8
  self.h = 8
  self.text = "Toolbar."
  self.text_align_y = "top"
  self.text_padding_y = 5
  self.border_padding_top = 20
  self.border_padding_bottom = 2
  self.border_padding_left = 2
  self.border_padding_right = 2
  self.object_padding_x = 2
  self.object_padding_y = 1
  self.is_tiled = true
  self.is_moveable = true
  self.is_scalable = false
  
  local x, y = 5, 30
  local last_name = engine.vars.toolbar.tool_list[1]
  for i = 1, #engine.vars.toolbar.tool_list do
    local x_off = last_name == engine.vars.toolbar.tool_list[1] and 2 or 0
    local name = engine.vars.toolbar.tool_list[i]
    self:stack("r", last_name, engine.draw_tools[name]:new(name, x, y, 32, 32), x_off)
    last_name = name
  end
  local fs = engine.ui.radio:new("fill_type", 4, 53, 100, 36, fill_select, "Fill Type")
  self:add(fs)
  self:stack("b", "fill_type", save_btn:new("save", 0, 0, 100, 25))
  self:stack("b", "save", open_btn:new("open", 0, 0, 100, 25))
end

return tb