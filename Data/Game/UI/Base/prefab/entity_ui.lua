local entity_ui = engine.ui.window:extend()

function entity_ui:setup(ent_id)
  self.ent = game.ecs:get_entity(ent_id)
  self.text = self.ent.class.." "..self.ent.id
  self.text_align_x = "left"
  self.text_align_y = "top"
  self.text_padding_x = 5
  self.text_padding_y = 5
  self.is_tiled = true
  self.is_visible = true
  self.is_moveable = true
  self.hue = {0, .8, .8, 1}
  self.text_colour = {1,1,1,1}
  
  local list = engine.vars.entity_view.tabs[self.ent.class]
  self:add(engine.ui.vtab:new("tabs", 3, 21, 385, 330, list))
  local tabs = self:find_child("tabs")
  tabs.is_tiled = true
  for i = 1, #list do
    tabs:add_tab(list[i].label, engine.prefab[list[i].object]:new(list[i].label, 0, 0, 50, 50, self.ent))
  end
  self:stretch()
  self:add(engine.ui.close_button:new("close", 0, 0, 16, 16))
end

return entity_ui