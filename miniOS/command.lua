-- command.lua, a very basic command interpreter for miniOS
--are we in miniOS?
if not miniOS then error("This program requires miniOS!") return end

local shell = {}

local tArgs={...}
local continue
if tArgs[1] == "-c" then continue = true table.remove(tArgs, 1) end

local function intro() print(_OSVERSION .. " [".. math.floor(computer.totalMemory()/1024).."k RAM, at least "..math.floor(miniOS.freeMem/1024).."k Free]" .."\nCommand Interpreter By Skye M.\n") end 
if not continue then intro() end

local history = {}
if miniOS.cmdHistory then history = miniOS.cmdHistory end
if miniOS.cmdDrive then fs.drive.setcurrent(miniOS.cmdDrive) end

local function runprog(file, parts)
	miniOS.cmdHistory = history
	miniOS.cmdDrive = fs.drive.getcurrent()
	table.remove(parts, 1)
	error({[1]="INTERRUPT", [2]="RUN", [3]=file, [4]=parts})
end

local function runbat(file, parts)
	error("Not yet Implemented!")
end

local function listdrives()
	for letter, address in fs.drive.list() do
		print(letter, address)
	end
end

local function lables()
	for letter, address in fs.drive.list() do
		print(letter, component.invoke(address, "getLabel"))
	end
end

local function label(parts)
	proxy, reason = fs.proxy(parts[2])
	if not proxy then
		print(reason)
		return
	end
	if #parts < 3 then
		print(proxy.getLabel() or "no label")
	else
		local result, reason = proxy.setLabel(parts[3])
		if not result then print(reason or "could not set label") end
	end
end

local function outputFile(file, paged)
  local handle, reason = filesystem.open(file)
  if not handle then
    error(reason, 2)
  end
  local buffer = ""
  repeat
    local data, reason = filesystem.read(handle)
    if not data and reason then
      error(reason)
    end
    buffer = buffer .. (data or "")
  until not data
  filesystem.close(handle)
  if paged then printPaged(buffer)
  else print(buffer) end
end

local function runline(line)
	line = text.trim(line)
	if line == "" then return true end
	parts = text.tokenize(line)
	command = string.lower(text.trim(parts[1]))
	--drive selector
	if #command == 2 then if string.sub(command, 2, 2) == ":" then filesystem.drive.setcurrent(string.sub(command, 1, 1)) return true end end
	--internal commands
	if command == "exit" then history = {} return "exit" end
	if command == "cls" then term.clear() return true end
	if command == "ver" then print(_OSVERSION) return true end
	if command == "mem" then print(math.floor(computer.totalMemory()/1024).."k RAM, "..math.floor(computer.freeMemory()/1024).."k Free") return true end
	if command == "dir" then for file in filesystem.list("/") do print(file) end return true end
	if command == "intro" then intro() return true end
	if command == "disks" then listdrives() return true end
	if command == "discs" then listdrives() return true end
	if command == "drives" then listdrives() return true end
	if command == "labels" then lables() return true end
	if command == "label" then if parts[2] then label(parts) return true else print("Invalid Parameters") return false end end
	if command == "type" then outputFile(parts[2]) return true end
	if command == "more" then outputFile(parts[2], true) return true end
	if command == "echo" then print(table.concat(parts, " ", 2)) return true end
	if command == "cmds" then printPaged([[
Internal Commands:
exit --- Exit the command interpreter, Usually restarts it.
cls ---- Clears the screen.
ver ---- Outputs version information.
mem ---- Outputs memory information.
dir ---- Lists the files on the current disk.
cmds --- Lists the commands.
intro -- Outputs the introduction message.
drives - Lists the drives and their addresses.
labels - Lists the drives and their labels.
label -- Sets the label of a drive.
echo --- Outputs its arguments.
type --- Like echo, but outputs a file.
more --- Like type, but the output is paged.
copy --- Copies a file.
move --- Moves a file.]]) print() return true end
	if command == "" then return true end
	if command == nil then return true end
	--external commands and programs
	command = parts[1]
	if filesystem.exists(command) then
		if not filesystem.isDirectory(command) then
			if text.endswith(command, ".lua") then runprog(command, parts) return true end
			if text.endswith(command, ".bat") then runbat(command, parts) return true end
			runprog(command, parts) return true
		end
	end
	if filesystem.exists(command .. ".lua")  then
		if not filesystem.isDirectory(command .. ".lua") then
			runprog(command .. ".lua", parts)
			return true
		end
	end
	if filesystem.exists(command .. ".bat") then
		if not filesystem.isDirectory(command .. ".bat") then
			runbat(command .. ".bat", parts)
			return true
		end
	end
	print("'" .. parts[1] .. "' is not an internal or external command, program or batch file.")
	return false
end

function shell.runline(line)
	local result = table.pack(pcall(runline, line))
	if result[1] then
		return table.unpack(result, 2, result.n)
	else
		if type(result[2]) == "table" then if result[2][1] == "INTERRUPT" then error(result[2]) end end
		printErr("ERROR:", result[2])
	end
end

if shell.runline(table.concat(tArgs, " ")) == "exit" then return end

while true do
	term.write(filesystem.drive.getcurrent() ..">")
	local line = term.read(history)
	while #history > 10 do
		table.remove(history, 1)
	end
	if shell.runline(line) == "exit" then return end
end