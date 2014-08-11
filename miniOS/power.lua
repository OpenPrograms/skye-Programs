local targs = {...}
local computer = require("computer")
print(...)
if not targs[1] then computer.shutdown()
elseif targs[1]:sub(1,1) == "s" then computer.shutdown()
elseif targs[1]:sub(1,1) == "r" then computer.shutdown(true)
elseif targs[1] then print("Bad Argument: " .. targs[1] .. "\nTry 'r' or 's' or no argument") return end
error("Could not Shutdown!")