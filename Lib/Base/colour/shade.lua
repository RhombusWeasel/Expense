return function(col, hue)
  local rCol = {}
  if hue == nil then hue = 1 end
  if type(col) == "string" then
    rCol = {engine.colour[col][1] * hue, engine.colour[col][2] * hue, engine.colour[col][3] * hue, engine.colour[col][4]}
  else
    rCol = {col[1] * hue, col[2] * hue, col[3] * hue, col[4]}
  end
  return rCol
end