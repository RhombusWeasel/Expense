local tab = engine.ui.tab:extend()

function tab:setup(list, button_stack, object_stack)
  self.is_tiled = true
  self.hue = {0,.8,.8,1}
  self.text_colour = {1,1,1,1}
  self.border_padding_top = 4
  self.object_padding_x = 1
  self.object_padding_y = 1
  self.border_padding_right = 2
  self.border_padding_left = 2
  self.border_padding_top = 2
  self.border_padding_bottom = 2
  self.hover_image = self.image
  self.button_stack = button_stack or "b"
  self.object_stack = object_stack or "r"
  self.button_width = 75
  self.button_height = 25
  local w, h = self:get_size()
  self.w = w + self.button_width
  self.list = list
  self.tab_list = {}
  self.first_button = ""
  self.last_button = ""
  self.type = "Tab Box"
  self.btn_count = 0
end

function tab:remove(label)
  engine.log("Removing "..label)
  local c_id = self:find_child_id(label.."_canvas")
  if c_id then
    table.remove(self.objects, c_id)
  end
  local id = self:find_child_id(label)
  table.remove(self.objects, id)
  for i = 1, #self.tab_list do
    if self.tab_list[i] == label then
      table.remove(self.tab_list, i)
      break
    end
  end
  self:assert_buttons()
end

function tab:assert_buttons()
  if self.tab_list[1] ~= nil then
    self:set_visible(self.tab_list[#self.tab_list])
    local border = self.border_padding_top + self.border_padding_bottom
    local h = math.floor((self.h - border) / (#self.tab_list + 1))
    for i = 1, #self.tab_list do
      local id = self:find_child_id(self.tab_list[i])
      self.objects[id].x = self.border_padding_left + self.object_padding_x
      self.objects[id].y = ((i - 1) * h) + ((i - 1) * self.object_padding_y) + self.border_padding_top
      self.objects[id].h = math.max(h, self.button_height)
    end
    self:assert_size()
  end
end

function tab:resize_canvas(i, w, h)
  if self.objects[i].is_tab_canvas then
    w = w > 0 and w or self.objects[i].w
    h = h > 0 and h or self.objects[i].h
    self.objects[i].w = w
    self.objects[i].h = h
  end
end

function tab:on_resize()
  local x, y = self:get_coordinates()
  local w, h = self:get_size()
  x = 5
  y = y + self.button_height
  w = w - (self.parent.border_padding_left + self.border_padding_right)
  h = h - (self.parent.border_padding_bottom + self.parent.border_padding_top + 2)
  for i = 1, #self.objects do
    self:resize_canvas(i, w, h)
  end
  self:assert_buttons()
end

function tab:add_tab(label, obj)
  if self.first_button == "" then
    self.first_button = label
  end
  self.btn_count = self.btn_count + 1
  local w, h = self:get_size()
  local border = self.border_padding_left + self.border_padding_right
  local num = #self.tab_list + 1
  local bw = self.button_width
  local bh = self.button_height
  local bx = ((num - 1) * w) + ((num - 1) * self.object_padding_x) + self.border_padding_right
  local by = self.border_padding_top
  local btn = engine.ui.base:new(label, bx, by, bw, bh)
        btn.is_tiled = true
        btn.hue = self.hue
        btn.text_colour = self.text_colour
        btn.text = label
        function btn:left_mouse_pressed()
          self.parent:set_visible(self.label)
          self.window:assert_size()
        end
  obj.label = label.."_canvas"
  obj.is_tab_canvas = true
  obj.hue = self.hue
  self:add(btn)
  table.insert(self.tab_list, label)
  self:assert_buttons()
  self:stack(self.object_stack, self.tab_list[1], obj)
  self:set_visible(label)
  self:stretch()
end

function tab:set_visible(label)
  for i = 1, #self.objects do
    local o_label = self.objects[i].label
    if o_label == label.."_canvas" then
      self.objects[i].is_visible = true
    elseif string.sub(o_label, #o_label - 6, #o_label) == "_canvas" then
      self.objects[i].is_visible = false
    end
  end
end

function tab:update_call(dt)
  
end

return tab