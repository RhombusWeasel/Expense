return function (args)
  if args[1] == nil then
    console.log("Current State : "..engine.current_state)
    return
  end
  if args[1] == "last" or args[1] == "-l" then
    console.log("Previous State: "..engine.last_state)
  elseif args[1] == "info" or args[1] == "-i" then
    console.log("Current State : "..engine.current_state)
    console.log("Previous State: "..engine.last_state)
  elseif args[1] == "return" or args[1] == "-r" then
    if engine.last_state ~= nil then
      engine.state.set(engine.last_state)
    end
  elseif args[1] == "all" or args[1] == "-a" then
    local list = {}
    for k, v in pairs(engine.state) do
      table.insert(list, k)
    end
    table.sort(list, function(a, b) return a<b end)
    console.log("State List:-")
    for i = 1, #list do
      console.log(list[i])
    end
  else
    engine.state.set(args[1])
  end
end