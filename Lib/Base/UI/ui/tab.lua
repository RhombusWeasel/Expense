local tab = engine.ui.base:extend()

function tab:base_init()
  self.is_tiled = true
  self.hue = {1,1,1,1}
  self.text_colour = {0,1,0,1}
  self.object_padding_x = 0
  self.object_padding_y = 0
  self.border_padding_right = 0
  self.border_padding_left = 0
  self.border_padding_top = 0
  self.border_padding_bottom = 0
end

function tab:setup(list, button_stack, object_stack)
  self.button_stack = button_stack or "r"
  self.object_stack = object_stack or "b"
  self.button_width = 50
  self.button_height = 20
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
    local border = self.border_padding_left + self.border_padding_right
    local w = math.floor((self.w - border) / (#self.tab_list + 1))
    for i = 1, #self.tab_list do
      local o = self:find_child(self.tab_list[i])
      o.x = ((i - 1) * w) + ((i - 1) * self.object_padding_x) + self.border_padding_right
      o.w = w
    end
    self.button_width = w
  end
end

function tab:resize_canvas(i, w, h)
  local o = self.objects[i]
  if o.is_tab_canvas then
    local x_border = self.border_padding_left
    local y_border = self.border_padding_top + self.border_padding_bottom + self.button_height
    o.x = 1
    o.y = self.button_height + 5
    o.w = w - 2 -- x_border
    o.h = h - (self.button_height + 6)
    o.canvas = love.graphics.newCanvas(o.w, o.h)
  end
end

function tab:on_resize()
  local w, h = self:get_size()
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
  local bw = math.floor((self.w - border) / (#self.tab_list + 1))
  local bh = self.button_height
  local bx = 5
  local by = self.border_padding_top
  local close_btn = engine.ui.close_button:new()
        close_btn.colour = {.4, .4, .4, 1}
        function close_btn:left_mouse_released()
          self.parent.parent:remove(self.parent.label)
        end
        function close_btn:update_call(dt)
          self.x = self.parent.w - (self.w + 4)
          self.y = 4
        end
  local btn = engine.ui.base:new(label, bx, by, bw, bh)
        btn.is_tiled = true
        btn.hue = self.hue
        btn.text_colour = self.text_colour
        btn.text = label
        btn:add(close_btn:new("close"))
        function btn:left_mouse_pressed()
          self.parent:set_visible(self.label)
        end
  obj.label = label.."_canvas"
  obj.is_tab_canvas = true
  obj.hue = self.hue
  self:add(btn)
  table.insert(self.tab_list, label)
  self:stack(self.object_stack, self.tab_list[1], obj)
  self:set_visible(label)
  local cls = self:find_child(label):find_child("close")
  cls.hue = {.4, .4, .4, 1}
  self:assert_buttons()
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
  if not self.initialized then
    self:on_resize()
    self.initialized = true
  end
  self:assert_buttons()
end

return tab