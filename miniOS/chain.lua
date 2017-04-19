local targs = {...}
local opt = table.remove(targs, 1)

if opt == "get" then print(fs.drive.toLetter(computer.getBootAddress()) .. ":"); return end

local td, tf = fs.drive.drivepathSplit(table.remove(targs, 1) or "")
if #targs == 0 then targs = nil end
local ta = fs.drive.toAddress(td)

if opt == "set" then computer.setBootAddress(ta); return end

if tf == "" then tf = "init.lua" end

local oldgetboot = computer.getBootAddress
local fakeget = function() return ta end
local oldsetboot = computer.setBootAddress
local fakeset = function(addr) ta = addr end
computer.getBootAddress = fakeget

if opt == "tmp" then computer.setBootAddress = fakeset
elseif opt == "nex" then computer.setBootAddress = function(...) fakeset(...); oldsetboot(...) end
else
  printErr("Unexpected option `" .. (opt or "") .. "`")
  print([[

Usage:
chain <option> <path>
  
Options:
get - get boot drive
set - set boot drive from path
tmp - start OS from path, blocks set
nex - start OS from path, allows set

Warning!
If the OS returns then REBOOT!
miniOS will probably be broken.]])
  return
end

if not filesystem.exists(td .. ":" .. tf) then
  printErr("File to chainload `" .. td .. ":" .. tf .. "` does not exist!")
  return
end

term.clear()
error({[1]="INTERRUPT", [2]="RUN", [3]=(td .. ":" .. tf), [4]=targs or {}})

error("INTERRUPT failiure.")
