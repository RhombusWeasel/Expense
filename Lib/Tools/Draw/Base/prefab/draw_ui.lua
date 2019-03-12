local draw_ui = engine.ui.ui_container:extend()

function draw_ui:setup()
  self:add(engine.prefab.toolbar:new("toolbar", 0, 0, 1, 1))
  self:add(engine.prefab.colour_picker:new("palette", 0, 0, 1, 1))
end

return draw_ui