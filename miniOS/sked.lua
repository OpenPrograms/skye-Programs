local b={}
local l=1
local function ctr() s=term.read() s=s:sub(1,s:len()-1) return s end
local function p(d) term.write(d,true) end
while true do
local c=ctr()
if c=="l" then for k,v in pairs(b) do p(v.."\n") end
elseif c=="lc" then p(tostring(b[l]).."\n")
elseif c=="s" then p">" l=tonumber(ctr())
elseif c=="so" then p(l)
elseif c=="a" then p":" table.insert(b,l,ctr()) l=l+1
elseif c=="r" then p":" b[l]=ctr()
elseif c=="d" then p(table.remove(b,l))
elseif c=="o" then p">" local rF=ctr() local f=filesystem.open(rF) local a=filesystem.read(f) filesystem.close(f) for L in a:gmatch("[^\r\n]+") do table.insert(b,l,L) l=l+1 end
elseif c=="w" then p">" local wT=ctr() local f=filesystem.open(wT,"w") for k,v in pairs(b) do filesystem.write(f,v.."\n") end filesystem.close(f)
elseif c=="e" then break else p"?" end end