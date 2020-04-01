if not miniOS then error("This program requires miniOS classic", 0) end

local args = {...}
local gpu = term.gpu()

local ow, oh = gpu.getViewport()

if #args == 0 then
  print(ow .. " " .. oh)
  return
end

if #args ~= 2 then
  print("Usage: resolution [<width> <height>]")
  return
end

local w = tonumber(args[1])
local h = tonumber(args[2])
if not w or not h then
  printErr("invalid width or height")
end

local result, reason = gpu.setResolution(w, h)
if not result then
  if reason then -- otherwise we didn't change anything
    printErr(reason)
  end
  return 1
end
if w < ow or h < oh then term.clear() end
