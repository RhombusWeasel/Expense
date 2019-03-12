local load_btn = engine.ui.base:extend()
      function load_btn:setup()
        self.text = "Load"
        self.is_tiled = true
        self.w = 200
        self.h = 20
      end
      function load_btn:left_mouse_pressed()
        local canvas = self.window:find_child("canvas")
        local file = self.parent.current_file
        local name = string.sub(file, 1, #file - 3)
        local ext = string.sub(file, #file - 3, #file)
        engine.log("Loading "..self.window.current_path.."/"..file)
        if ext ~= ".png" then
          return
        end
        local img = love.graphics.newImage(self.window.current_path.."/"..file)
        self.window.filename = name
        self.window.text = name
        self.window.label = name
        canvas:setup(img:getDimensions())
        canvas.label = "canvas"
        love.graphics.setCanvas(canvas.layers[1].canvas)
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(img, 0, 0)
      end

local fe = engine.ui.base:extend()

function fe:setup()
  self.is_moveable = true
  self.is_tiled = true
  self.text = "File Explorer"
  self.text_align_y = "top"
  self.text_padding_y = 5
  self:stack("r", "", engine.ui.file_browser:new("file_view", 0, 0, 200, 200, 16))
  self:stack("b", "file_view", load_btn:new("load", 0, 0, 0, 0))
  
  self:add_reference("window", self.window)
end

function fe:update_call(dt)
  if self.window.current_path == nil then
    self.window.current_path = engine.current_path
  end
end

return fe