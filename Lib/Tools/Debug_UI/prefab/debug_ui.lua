local dbg = engine.ui.ui_container:extend()

function dbg:setup()
  self.current_line = 1
  self.text = {}
  self.text_align_x = "right"
  self.text_align_y = "top"
  self.text_padding_x = 40
  self.text_padding_y = 5
  self.is_visible = false
  self.text_colour = {0,1,0,1}
  local console = engine.prefab.console:new("console", 0, 0, 1, 1)
  local fps_chart = engine.ui.chart:new("fps_chart", 0.7, 0.9, 0.3, 0.1)
        fps_chart.counter = 0
        fps_chart.hover_colour = {0,0,0,0}
        fps_chart.image = "none"
        function fps_chart:update_call(dt)
          self.counter = self.counter + dt
          if self.counter > .3 then
            self:add_point(love.timer.getFPS())
            self.counter = dt
          end
        end
  self:add(console)
  self:add(fps_chart)
end

return dbg