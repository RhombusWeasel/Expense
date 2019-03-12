local tiled = true

local function new_buy_button(item, amt, ship, stat)
  local btn = engine.ui.base:extend()
        function btn:setup()
          self.hue = {0,.8,.2,1}
          self.text_colour = {1,1,1,1}
          self.item = item
          self.ship = ship
          self.stat = stat
          self.amt = amt
          self.text = "Buy "..amt
        end
        function btn:left_mouse_pressed()
          engine.commands.buy_goods(self.item, self.amt, self.ship, self.stat)
        end
  return btn:new(item.."_buy_"..amt, 0, 0, 77, 20)
end

local label = engine.ui.base:extend()
      function label:setup(item)
        self.is_tiled = tiled
        self.hue = {0,.8,.8,1}
        self.text_colour = {1,1,1,1}
        self.text_align_x = "left"
        self.text_padding_x = 6
        self.text = engine.recipes[item].label
      end

local amt = engine.ui.base:extend()
      function amt:setup(stat, item)
        self.is_tiled = tiled
        self.text_align_x = "right"
        self.text_padding_x = 5
        self.hue = {0,.8,.8,1}
        self.text_colour = {1,1,1,1}
        self.item = item
        self.stat = stat
        self.text = stat.crafting.output[item].amount.."/"..stat.crafting.output[item].max
      end
      function amt:update_call(dt)
        self.text = self.stat.crafting.output[self.item].amount.."/"..self.stat.crafting.output[self.item].max
      end

local price = engine.ui.base:extend()
      function price:setup(stat, item)
        self.text = "Track"
        self.text_align_x = "right"
        self.text_padding_x = 6
        self.text_colour = {1,1,1,1}
        self.is_tiled = tiled
        self.hue = {0,.8,.8,1}
        self.item = item
        self.stat = stat
        self.text = tostring(stat.crafting.output[self.item].price)
        engine.log(item.." price button added. "..self.text)
      end
      function price:update_call(dt)
        self.text = tostring(self.stat.crafting.output[self.item].price)
      end

local buy_box = engine.ui.base:extend()
      function buy_box:setup(ent)
        self.text = "Buy"
        self.text_align_y = "top"
        self.text_padding_y = 5
        self.border_padding_top = 20
        self.text_colour = {1,1,1,1}
        self.is_tiled = true
        self.re_sort = true
        self.ent = ent
        self.hue = {0,.8,.8,1}
      end
      function buy_box:resort(ent)
        local stat = game.ecs:get_entity(ent.engine.docked)
        if stat.crafting then
          self.objects = {}
          local last_btn = ""
          for k, v in pairs(stat.crafting.output) do
            self:stack("b", last_btn, label:new(v.item, 0, 0, 150, 20, v.item))
            self:stack("r", v.item, amt:new(v.item.."_amt", 0, 0, 80, 20, stat, v.item))
            self:stack("r", v.item.."_amt", price:new(v.item.."_price", 0, 0, 80, 20, stat, v.item))
            self:stack("b", v.item, new_buy_button(v.item, 1, self.ent, stat))
            self:stack("r", v.item.."_buy_1", new_buy_button(v.item, 10, self.ent, stat))
            self:stack("r", v.item.."_buy_10", new_buy_button(v.item, 100, self.ent, stat))
            self:stack("r", v.item.."_buy_100", new_buy_button(v.item, 1000, self.ent, stat))
            last_btn = v.item.."_buy_1"
          end
          self.window:assert_size()
        end
        self.re_sort = false
      end
      function buy_box:update_call(dt)
        local sb = self.parent:find_child("sell")
        local th = sb.y + sb.h + self.parent.object_padding_y
        if self.x ~= th then
          self.y = th
          self.window:assert_size()
        end
        local ent = self.window.ent
        if ent.engine.docked > 0 then
          if self.re_sort then
            self:resort(ent)
          end
        else
          self.objects = {}
          self.h = 20
          self.has_children = false
          self.window:assert_size()
          self.re_sort = true
        end
      end

return buy_box