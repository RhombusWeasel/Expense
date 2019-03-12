return function(args)
  if #args < 1 then
    engine.log("ERROR: No name input.")
  end
  local pkt = {
    command = "nameCheck",
    name = args[1],
    token = engine.token.auth.my_id,
    colour = engine.token.auth.colour,
    message = "Checking name - "..args[1],
  }
  engine.chat_server:send(engine.string.serialize(pkt))
end