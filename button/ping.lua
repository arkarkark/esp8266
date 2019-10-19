-- luacheck: globals adc  gpio net tmr encodeURITable wifi

print("Sending ping to server")

require("ark-uri")

local conn = net.createConnection(net.TCP, 0)

local function bye()
      --Shutdown
      gpio.write(4, gpio.LOW)
end

conn:on("receive", bye)
conn:on("disconnection", bye)

conn:on(
   "connection",
   function(c)
      print("Connected! sending POST")
      local data = encodeURITable({
	    mac_address=wifi.sta.getmac(),
	    adc_level=adc.readvdd33()
      })

      local request = "POST /button"
	 .. " HTTP/1.1\r\n"
	 .. "Content-type: application/x-www-form-urlencoded\r\n"
	 .. "Content-Length: " .. string.len(data) .. "\r\n"
	 .. "\r\n"
	 .. data

      print("Sending:" .. request)

      c:send(request)
      print("Ping request sent. Goodbye")
   end
)

local cnt = 0

local function timer()
   if wifi.sta.getip() == nil then
      cnt = cnt + 1
      print("(" .. cnt .. ") Waiting for IP...")
      if cnt > 9 then
	 tmr.stop(1)
	 print("Giving up")
	 bye()
      end
   else
      print("We got an IP address!")
      tmr.stop(1)
      conn:connect(8080, "10.1.10.12")
   end
end

tmr.alarm(1, 1000, 1, timer)
