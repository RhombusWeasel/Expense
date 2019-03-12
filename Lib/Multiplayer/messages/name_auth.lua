return function(event, pkt)
  engine.token.auth.name = pkt.set_name
  engine.system.save(engine.token.auth, "/Mods/Base/MP/token", "auth")
  local chat = game.ui:find_child("chat")
  local text = chat:find_child("text_box")
  text:add_text(pkt)
end