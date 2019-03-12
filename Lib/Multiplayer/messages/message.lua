return function(event, pkt)
  local chat = game.ui:find_child("chat")
  local text = chat:find_child("text_box")
  text:add_text(pkt)
end