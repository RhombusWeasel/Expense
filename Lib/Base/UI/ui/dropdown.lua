local standard_entry = engine.ui.base:extend()
      function standard_entry:setup(t)
        self.show_background = false
        self.is_tiled = false
        self.text_align_x = "left"
        self.text = t
        self:calculate_size()
      end
      function standard_entry:left_mouse_pressed()
        self.parent:set_value(self.text)
      end
      function standard_entry:calculate_size()
        self.w = engine.font[engine.current_font]:getWidth(self.text) + (self.border_padding_left + self.border_padding_right)
      end

local entry_box = engine.ui.base:extend()
      function entry_box:setup(list, template, parent)
        list = list or {}
        self.value = 1
        self.text = ""
        self.is_visible = false
        template = template or standard_entry
        local last_entry = ""
        self.max_wid = 0
        for i = 1, #list do
          self:stack("b", last_entry, template:new(list[i], 0, 0, 0, 20, list[i]), #self.objects)
          if self.objects[i].w > self.max_wid then
            self.max_wid = self.objects[i].w
          end
          last_entry = list[i]
        end
        for i = 1, #list do
          self.objects[i].w = self.max_wid
        end
        local val = parent:find_child("value")
        val.w = self.w
      end
      function entry_box:set_value(t)
        engine.log(t)
        for i = 1, #self.objects do
          if self.objects[i].text == t then
            self.parent.value = i
            local val = self.parent:find_child("value")
            val.text = t
            engine.log(val.text)
          end
        end
        self.parent:on_value_change()
        self.is_visible = false
      end

local drop_button = engine.ui.base:extend()
      function drop_button:setup(parent)
        self.x = parent.border_padding_left + parent.object_padding_x
        self.y = parent.border_padding_top + parent.object_padding_y + 1
        self.w = 20
        self.h = 20
        self.hue = {0,.6,.6,1}
      end
      function drop_button:left_mouse_pressed()
        local list = self.parent:find_child("entries")
        list.is_visible = not list.is_visible
      end

local val_box = engine.ui.base:extend()
      function val_box:setup()
        self.text_align_x = "left"
        self.text_padding_x = 5
        self.text_padding_y = 5
      end
      function val_box:left_mouse_pressed()
        local entries = self.parent:find_child("entries")
        entries.is_visible = not entries.is_visible
      end

local dd = engine.ui.base:extend()

function dd:base_init(list, template)
  self.value = 1
  self.text = ""
  self:stack("r", "", drop_button:new("drop_button", 0, 0, 0, 0, self))
  self:stack("r", "drop_button", val_box:new("value", 0, 0, 0, 20))
  self:stack("b", "value", entry_box:new("entries", 0, 0, 0, 0, list, template, self))
  self.w = self.border_padding_left + self.border_padding_right + self.objects[1].w + self.object_padding_x
  local entries = self:find_child("entries")
  entries.objects[1]:left_mouse_pressed()
end

function dd:left_mouse_pressed()
  local list = self:find_child("entries")
  list.is_visible = not list.is_visible
end

function dd:assert_mouse_released(b)
  local list = self:find_child("entries")
  if not self.is_hovered and not list.is_hovered then
    list.is_visible = false
  end
  self:assert_size()
end

function dd:on_value_change() end

return dd