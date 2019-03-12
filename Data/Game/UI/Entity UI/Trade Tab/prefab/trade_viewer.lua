local tiled = true

local tv = engine.ui.base:extend()

function tv:setup(ent)
  self.w = 310
  self.h = 500
  self.is_tiled = true
  self.border_padding_left = 5
  self.border_padding_right = 5
  self.border_padding_top = 5
  self.border_padding_bottom = 5
  self:stack("b", "", engine.prefab.sell_box:new("sell", 6, 6, 310, 20, ent))
  self:stack("b", "sell", engine.prefab.buy_box:new("buy", 0, 0, 310, 20, ent))
end

return tv