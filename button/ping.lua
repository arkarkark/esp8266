--ping.lua
-- luacheck: globals net tmr gpio encodeURITable wifi, ignore conn

print("Sending to IFTTT")

require("ark-uri")

conn = nil
conn=net.createConnection(net.TCP, 0)

conn:on("receive", function(conn, payload)
	   --Shutdown
	   print("got reply\n" .. payload)

	   if payload.find("STAY AWAKE") then
	      print("Staying awake!")
	   else
	      gpio.write(4, gpio.LOW)
	   end
	   --If esp is enabled that means the button is still pushed!
	   -- tmr.alarm(0, 2000, 1, function() reset() end)
end)

conn:on("disconnection", function(conn, payload)
	   print("disconnection")

end)

conn:on("connection", function(conn, payload)
	   print("Connected! sending POST")
	   local data = encodeURITable({
	      mac_address=wifi.sta.getmac()
	   })

	   local request = "POST /button"
			.." HTTP/1.1\r\n"
			.."Content-type: application/x-www-form-urlencoded\r\n"
		        .."Content-Length: " .. string.len(data) .. "\r\n"
			.."\r\n"
			..data

	   print("Sending:" .. request)


	   conn:send(request
	   )
	   print("IFTTT request sent. Goodbye")
end)

-- [[
--conn:dns("maker.ifttt.com",function(conn, ip)
 --   if (ip) then
  --      print("We can connect to " .. ip)
  --      conn:connect(80,ip)
  --  else
  --      reset()
  --  end
-- end)
-- ]]

conn:connect(8080, "10.1.10.12")

function reset()
    print("Reseting Wifi..")
    -- wifi.sta.disconnect()
    -- wifi.sta.config("","")
    -- dofile("setwifi.lua")
end
