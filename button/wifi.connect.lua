-- luacheck: globals adc cjson tmr wifi

print("wifi.connect.lua")

for k, v in pairs(wifi.sta.getconfig(true)) do
   print(k .. " - " .. v)
end

-- Print AP list that is easier to read
local function listap(t) -- (SSID : Authmode, RSSI, BSSID, Channel)
    print("\n\tSSID\t\t RSSI\tAUTH\tCHANNEL")
    local aps = {}
    for bssid,v in pairs(t) do
        local ssid, rssi, authmode, channel = string.match(v, "([^,]+),([^,]+),([^,]+),([^,]*)")
	table.insert(aps, {bssid=bssid, ssid=ssid, rssi=rssi, authmode=authmode, channel=channel})
    end

    table.sort(aps, function(a, b) return tonumber(a.rssi) > tonumber(b.rssi) end)

    for _, ap in ipairs(aps) do
	print(string.format("%16s",ap.ssid).."\t  "..ap.rssi.."\t"..ap.authmode.."\t"..ap.channel)
    end

    print("done with ap list")
end

local cnt = 0
local function timer()
   if wifi.sta.getip()== nil then
      cnt = cnt + 1
      print("(" .. cnt .. ") Waiting for IP...")
      if cnt > 9 then
	 tmr.stop(1)
	 print("Could not get IP address")
      end
   else
      print("We got an IP address!" .. wifi.sta.getip())
      tmr.stop(1)
      print("Getting list of stations (Strongest First)")
      wifi.sta.getap(1, listap)
   end
end

tmr.alarm(1, 1000, 1, timer)
