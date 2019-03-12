local red = {1,.2,.6,1}
local cyan = {0,.8,.8,1}
local purple = {1, .5, 1, 1}
local green = {.2, 1, .2, 1}
local yellow = {1,1,0,1}

local lua = {}
      lua["--"] = {
        type = "comment",
        block = "[[",
        unblock = "]]",
        col = {1,1,1,1}
      }
      lua["local"] = {col = red}
      lua["for"] = {col = red}
      lua["repeat"] = {col = red}
      lua["until"] = {col = red}
      lua["while"] = {col = red}
      lua["do"] = {col = red}
      lua["if"] = {col = red}
      lua["then"] = {col = red}
      lua["elseif"] = {col = red}
      lua["else"] = {col = red}
      lua["function"] = {col = red}
      lua["end"] = {col = red}
      lua["return"] = {col = red}
      lua["select"] = {col = cyan}
      lua["require"] = {col = cyan}
      lua["type"] = {col = cyan}
      lua["true"] = {col = cyan}
      lua["false"] = {col = cyan}
      lua["engine"] = {col = purple}
      lua["game"] = {col = purple}
      lua["love"] = {col = purple}
      lua["table"] = {col = green}
      lua["math"] = {col = green}
      lua["+"] = {col = cyan}
      lua["-"] = {col = cyan}
      lua["*"] = {col = cyan}
      lua["/"] = {col = cyan}
      lua["%"] = {col = cyan}
      lua["="] = {col = cyan}
      lua["["] = {col = cyan}
      lua["]"] = {col = cyan}
      lua["{"] = {col = cyan}
      lua["}"] = {col = cyan}
      lua["("] = {col = cyan}
      lua[")"] = {col = cyan}
      lua["."] = {col = cyan}
      lua[","] = {col = cyan}
      lua["~"] = {col = cyan}
      lua["#"] = {col = cyan}
      lua["'"] = {col = yellow}
      lua['"'] = {col = yellow}

return lua