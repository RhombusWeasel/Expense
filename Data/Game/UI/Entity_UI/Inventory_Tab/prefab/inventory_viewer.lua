local list_entry = engine.ui.base:extend()
      function list_entry:setup(ship, item_id)
        self.ent = ship
        self.item_id = item_id
        self.hue = {0,0,0,1}
        self.text_colour = {0,1,0,1}
        self.text_align_x = "left"
        self.text_align_y = "top"
        self.text_padding_x = 6
        local cargo = self.ent.cargo.goods[self.item_id]
        self.text = engine.string.r_pad(tostring(cargo.amount), 4, " ").." "..engine.string.l_pad(engine.recipes[cargo.item].label, 20, " ")
        self.text = self.text..engine.string.r_pad(tostring(cargo.price), 4, " ")
      end
      function list_entry:update(dt)
        local cargo = self.ent.cargo.goods[self.item_id]
        self.text = engine.string.r_pad(tostring(cargo.amount), 4, " ").." "..engine.string.l_pad(engine.recipes[cargo.item].label, 20, " ")
        self.text = self.text.."["..engine.string.r_pad(tostring(cargo.price), 4, " ").."]"
      end

local inv = engine.ui.base:extend()

function inv:setup(ent)
  self.hue = {0,0,0,1}
  self.text_colour = {0,1,0,1}
  self.ent = ent
  self.counter = 0
  self:stack("r", "", engine.ui.column:new("name_col", 0, 0, 150, 0, "Item", self.ent.cargo.goods, "label", "left", false))
  self:stack("r", "name_col", engine.ui.column:new("amt_col", 0, 0, 75, 0, "Amount", self.ent.cargo.goods, "amount", "right", false))
  self:stack("r", "amt_col", engine.ui.column:new("price_col", 0, 0, 75, 0, "Paid", self.ent.cargo.goods, "price", "right", true))
end

return inv