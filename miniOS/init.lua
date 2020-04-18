local function loadfile(name)
  local handle, reason = component.invoke(computer.getBootAddress(), "open", name)
  if not handle then error(reason) end
  local buffer = ""
  repeat
    local data, reason = component.invoke(computer.getBootAddress(), "read", handle, math.huge)
    if not data and reason then error(reason) end
    buffer = buffer .. (data or "")
  until not data
  component.invoke(computer.getBootAddress(), "close", handle)
  -- Tail call!
  return load(buffer, "=" .. name, 'bt', _G)
end
-- Tail call!
return loadfile("miniOS.lua")()