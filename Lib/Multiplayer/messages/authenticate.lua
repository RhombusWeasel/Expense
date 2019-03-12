local s_tab = {"B", "C", "D", "E", "F", "G", "H", "I", "J"}
s_tab[0] = "A"

return function (event, pkt)
  local msg = "Reconnected."
  if engine.token.auth.my_id == "" then
    local tkn = pkt.token
    for i = 1, #pkt.token do
      local c = tonumber(string.sub(tkn, i, i))
      engine.token.auth.my_id = engine.token.auth.my_id..s_tab[c]
    end
    engine.system.save(engine.token.auth, "/Mods/Base/MP/token", "auth")
    msg = "New User."
  end
  local new_pkt = engine.string.serialize({
    command = "authenticate",
    name = engine.token.auth.name,
    room = engine.token.auth.room,
    token = engine.token.auth.my_id,
    message = msg,
  })
  event.peer:send(new_pkt)
  return true
end