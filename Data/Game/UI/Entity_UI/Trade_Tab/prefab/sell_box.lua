local tiled = true

local function new_sell_button(item, amt, ship, stat)
  local btn = engine.ui.base:extend()
        function btn:setup()
          self.hue = {0,.8,.2,1}
          self.text_colour = {1,1,1,1}
          self.item = item
          self.ship = ship
          self.stat = stat
          self.amt = amt
          self.text = "Sell "..amt
        end
        function btn:update_call(dt)
          if engine.commands.check_cargo(self.ship, self.item) >= self.amt then
            self.is_visible = true
          else
            self.is_visible = false
          end
        end
        function btn:left_mouse_pressed()
          engine.commands.sell_goods(self.item, self.amt, self.ship, self.stat)
        end
  return btn:new(item.."_sell_"..amt, 0, 0, 77, 20)
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
        self.text = stat.crafting.inventory[item].amount.."/"..stat.crafting.inventory[item].max
      end
      function amt:update_call(dt)
        self.text = self.stat.crafting.inventory[self.item].amount.."/"..self.stat.crafting.inventory[self.item].max
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
        self.text = tostring(stat.crafting.inventory[self.item].price)
        engine.log(item.." price button added. "..self.text)
      end
      function price:update_call(dt)
        self.text = tostring(self.stat.crafting.inventory[self.item].price)
      end

local sell_box = engine.ui.base:extend()
      function sell_box:setup(ent)
        self.text = "Sell"
        self.text_align_y = "top"
        self.text_padding_y = 5
        self.border_padding_top = 20
        self.text_colour = {1,1,1,1}
        self.is_tiled = true
        self.re_sort = true
        self.ent = ent
        self.hue = {0,.8,.8,1}
      end
      function sell_box:resort(ent)
        local stat = game.ecs:get_entity(ent.engine.docked)
        if stat.crafting then
          self.objects = {}
          local last_btn = ""
          for k, v in pairs(stat.crafting.inventory) do
            self:stack("b", last_btn, label:new(v.item, 0, 0, 150, 20, v.item))
            self:stack("r", v.item, amt:new(v.item.."_amt", 0, 0, 80, 20, stat, v.item))
            self:stack("r", v.item.."_amt", price:new(v.item.."_price", 0, 0, 80, 20, stat, v.item))
            self:stack("b", v.item, new_sell_button(v.item, 1, self.ent, stat))
            self:stack("r", v.item.."_sell_1", new_sell_button(v.item, 10, self.ent, stat))
            self:stack("r", v.item.."_sell_10", new_sell_button(v.item, 100, self.ent, stat))
            self:stack("r", v.item.."_sell_100", new_sell_button(v.item, 1000, self.ent, stat))
            last_btn = v.item.."_sell_1"
          end
          self.window:assert_size()
        end
        self.re_sort = false
      end
      function sell_box:update_call(dt)
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

return sell_box