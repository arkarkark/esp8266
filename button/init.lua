--init.lua

-- luacheck: globals gpio tmr wifi, ignore cnt timer

gpio.mode(3, gpio.INPUT) -- GPIO0
gpio.mode(4, gpio.OUTPUT) -- GPIO2
gpio.write(4, gpio.HIGH)
cnt = 0



print("Starting ark's SmartButton")


function timer()
   if wifi.sta.getip() == nil then
      cnt = cnt + 1
      print("(" .. cnt .. ") Waiting for IP...")
      if cnt > 9 then
	 tmr.stop(1)
	 print("should dofile wetwifi here")
	 -- dofile("setwifi.lua")
      end
   else
      print("We got an IP address!")
      tmr.stop(1)
      -- dofile("ping.lua")
   end
end

if  gpio.read(3) == 1 then
   tmr.alarm(1, 1000, 1, timer)
end
