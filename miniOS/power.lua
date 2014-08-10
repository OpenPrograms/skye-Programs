local targs = {...}
local computer = require("computer")
print(...)
if not targs[1] then computer.shutdown()
elseif targs[1] == "s" then computer.shutdown()
elseif targs[1] == "r" then computer.shutdown(true) end
error("Could not shutdown!")