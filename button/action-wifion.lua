-- luacheck: globals tmr wifi

local M = {}

function M.run(config)
    return require("lua-promise").new(
        function(resolve, reject)
            local secrets = require("secrets")
            wifi.setmode(wifi.STATION, true)
            wifi.sta.config(
                {
                    ssid = config.ssid or secrets.wifi_ssid,
                    pwd = config.password or secrets.wifi_password,
                    save = true
                }
            )

            print("WIFI: Connecting to SSID: " .. wifi.sta.getconfig(true).ssid)

            local cnt = 0
            local function timer()
                local ip = wifi.sta.getip()
                if ip == nil then
                    cnt = cnt + 1
                    print("WIFI: (" .. cnt .. ") Waiting for IP...")
                    if cnt > 19 then
                        tmr.stop(1)
                        print("WIFI: Took Too Long, Giving up")
                        print("WIFI: Showing Available APs...")
                        M.listap()
                        print("WIFI: end")
                        reject()
                    end
                else
                    print("WIFI: We got an IP address: " .. ip)
                    tmr.stop(1)
                    resolve(ip)
                end
            end

            tmr.alarm(1, 1000, tmr.ALARM_AUTO, timer)
        end
    )
end

local function listap_callback(t) -- (SSID : Authmode, RSSI, BSSID, Channel)
    print("\n\tSSID\t\t RSSI\tAUTH\tCHANNEL")
    local aps = {}
    for bssid, v in pairs(t) do
        local ssid, rssi, authmode, channel = string.match(v, "([^,]+),([^,]+),([^,]+),([^,]*)")
        table.insert(aps, {bssid = bssid, ssid = ssid, rssi = rssi, authmode = authmode, channel = channel})
    end

    table.sort(
        aps,
        function(a, b)
            return tonumber(a.rssi) > tonumber(b.rssi)
        end
    )

    for _, ap in ipairs(aps) do
        print(string.format("%16s", ap.ssid) .. "\t  " .. ap.rssi .. "\t" .. ap.authmode .. "\t" .. ap.channel)
    end

    print("done with ap list")
end

function M.listap()
    wifi.sta.getap(1, listap_callback)
end

return M
