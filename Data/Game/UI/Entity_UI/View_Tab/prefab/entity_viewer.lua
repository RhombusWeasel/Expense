local ev = engine.ui.base:extend()

function ev:setup(ent)
  self.w = 310
  self.h = 330
  self.is_tiled = true
  self:add(engine.ui.viewport:new("camera", 4, 4, 298, 300, 0, 0, ent.id))
  local track = engine.ui.base:extend()
        function track:setup()
          self.text = "Track"
          self.text_align_y = "center"
          self.text_colour = {1,1,1,1}
          self.is_tiled = true
          self.hue = {0,.8,.8,1}
        end
        function track:left_mouse_pressed()
          game.camera.track_target = self.parent.window.ent.id
        end
  self:add(track:new("track", 4, 308, 298, 25))
end

function ev:update_call(dt)
  local cam = self:find_child("camera")
  cam.track_target = self.window.ent.id
end

return ev