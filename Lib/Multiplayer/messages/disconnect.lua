return function()
  local pkt = {
    command = "disconnect",
    token = engine.token.auth.my_id,
    col = engine.token.auth.colour,
    message = engine.token.auth.name.." disconnected.",
  }
  engine.chat_server:send(engine.string.serialize(pkt))
  engine.chat_host:flush()
end