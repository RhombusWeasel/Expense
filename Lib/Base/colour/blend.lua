return function(col1, col2, bias)
  local bias2 = 1 - bias
  if type(col1) == "string" then
    col1 = engine.colour[col1]
  end
  if type(col2) == "string" then
    col2 = engine.colour[col2]
  end
  return {
    ((col1[1] * bias) + (col2[1] * bias2)),
    ((col1[2] * bias) + (col2[2] * bias2)),
    ((col1[3] * bias) + (col2[3] * bias2)),
    ((col1[4] * bias) + (col2[4] * bias2)),
    }
end