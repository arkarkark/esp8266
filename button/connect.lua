-- luacheck: globals tmr wifi

print("Connecting to SSID: " .. wifi.sta.getconfig(true).ssid)

local cnt = 0

local function timer()
   if wifi.sta.getip() == nil then
      cnt = cnt + 1
      print("(" .. cnt .. ") Waiting for IP...")
      if cnt > 19 then
	 tmr.stop(1)
	 print("Giving up")
	 dofile("bye.lua")
      end
   else
      print("We got an IP address!")
      tmr.stop(1)
      dofile("run.lua")
   end
end

tmr.alarm(1, 1000, 1, timer)
