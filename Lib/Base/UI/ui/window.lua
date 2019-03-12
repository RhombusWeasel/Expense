local win = engine.ui.base:extend()

function win:init(label, x, y, w, h, ...)
  self.label = label
  self.x = x
  self.y = y
  self.w = w
  self.h = h
  
  self.is_hovered = false
  self.can_hover = true
  self.is_moveable = true
  self.is_grabbed = false
  self.is_visible = true
  self.is_scalable = true
  self.ignore_canvas = true
  self.show_text = true
  self.show_background = true
  
  self.object_padding_x = 2
  self.object_padding_y = 2
  self.border_padding_left = 2
  self.border_padding_right = 2
  self.border_padding_top = 20
  self.border_padding_bottom = 2
  
  self.text = ""
  self.text_align_x = "center"
  self.text_align_y = "center"
  self.text_padding_x = 0
  self.text_padding_y = 5
  self.text_colour = {0,0,0,1}
  
  self.image = engine.texture_pack.."_button_tiled"
  self.hover_image = engine.texture_pack.."_button_hover_tiled"
  self.display_image = self.image
  self.sprite_batch = {
    [self.image] = love.graphics.newSpriteBatch(engine.ui_assets[self.image], 1, "dynamic"),
    [self.hover_image] = love.graphics.newSpriteBatch(engine.ui_assets[self.hover_image], 1, "dynamic"),
  }
  self:set_tile_dimensions(16, 16)
  
  self.hue = {.8,.8,.8,1}
  self.colour = {0,0,0,0}
  self.hover_colour = {0,0,0,0}
  self.display_colour = self.colour
  
  self.objects = {}
  self.has_children = false
  
  self:base_init()
  self:setup(...)
  self:assert_size()
end

function win:add(obj, layer)
  layer = layer or 1
  obj.parent = self
  obj:add_reference("window", self)
  self.has_children = true
  table.insert(self.objects, layer, obj)
end

return win