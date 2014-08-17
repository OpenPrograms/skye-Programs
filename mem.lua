local c=require("computer")
print(math.floor(c.totalMemory()/1024).."k RAM, "..math.floor(c.freeMemory()/1024).."k Free")