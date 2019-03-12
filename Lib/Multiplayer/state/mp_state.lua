local mp = {}

function mp.startup()
  love.filesystem.createDirectory("Mods/Base/MP")
  love.filesystem.createDirectory("Mods/Base/MP/token")
  engine.log("Creating host...")
  engine.host = enet.host_create()
  engine.log("Host created.")
  engine.log("Connecting to server... "..engine.token.auth.server_ip)
  engine.server = engine.host:connect(engine.token.auth.server_ip)
  local done = false
  while not done do
    local event = engine.host:service(10)
    if event then
      if event.type == "connect" then
        event.peer:send("{command = 'auth', message = 'Hi'}")
      elseif event.type == "receive" then
        local pkt = engine.string.unpack(event.data)
        if engine.messages[pkt.command] then
          done = engine.messages[pkt.command](event, pkt)
        end
      end
    end
  end
end

function mp.update(dt)
  local event = engine.host:service(10)
  if event then
    if event.type == "receive" then
      local pkt = engine.string.unpack(event.data)
      if engine.messages[pkt.command] then
        done = engine.messages[pkt.command](event, pkt)
      end
    end
  end
end

function mp.draw()
  
end

return mp