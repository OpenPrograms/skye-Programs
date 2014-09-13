local shell = require("shell")

print( shell.execute("wget", nil, "https://raw.githubusercontent.com/OpenPrograms/skye-Programs/master/miniOS/init.lua" ) )
print( shell.execute("wget", nil, "https://raw.githubusercontent.com/OpenPrograms/skye-Programs/master/miniOS/minios.lua" ) )
print( shell.execute("wget", nil, "https://raw.githubusercontent.com/OpenPrograms/skye-Programs/master/miniOS/keyboard.lua" ) )
print( shell.execute("wget", nil, "https://raw.githubusercontent.com/OpenPrograms/skye-Programs/master/miniOS/command.lua" ) )
print( shell.execute("wget", nil, "https://raw.githubusercontent.com/OpenPrograms/skye-Programs/master/miniOS/power.lua" ) )
print( shell.execute("wget", nil, "https://raw.githubusercontent.com/OpenPrograms/skye-Programs/master/miniOS/sked.lua" ) )
