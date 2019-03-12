return function (args)
  if args[1] == nil or args[2] == nil then
    engine.log("ERROR: Invalid table reference.")
    engine.log("You must provide a valid table name. eg 'list engine system'")
    return
  end
  if args[1] == "game" then
    for k, v in pairs(game[args[2]]) do
      engine.log(k)
    end
  elseif args[1] == "engine" then
    for k, v in pairs(engine[args[2]]) do
      engine.log(k)
    end
  end
end