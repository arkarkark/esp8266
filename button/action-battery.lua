-- luacheck: globals adc cjson file wifi

local ping = require("action-ping")

local M = {}

-- config.url
function M.run(config)
    print("action-battery.run(" .. cjson.encode(config) .. ")")
    local v = adc.readvdd33() -- mV is in the range 0 to 4400

    local vlimit = config.limit or 3000

    local battery_email_sent_file = "battery_email_sent.txt"

    if v > vlimit then
        if file.exists(battery_email_sent_file) then
            print("BATTERY: removing file since voltage is good")
            file.remove(battery_email_sent_file)
        else
            print("BATTERY is good and we have no file to remove")
        end
    else
        if file.exists(battery_email_sent_file) then
            print("BATTERY: v is low, but already sent a warning so not doing anything ")
            return
        end

        local title = "Low Battery: " .. config.name
        local body = title .. "<br>\n" .. v .. "mV<br>\nmac address: " .. wifi.sta.getmac()
        local data = {
            value1 = title,
            value2 = body
        }

        local key = config.key or require("secrets").ifttt_key

        local function add_battery_email_sent_file()
            print("BATTERY: writing file to indicate we have mailed about low voltage")
            local f = file.open(battery_email_sent_file, "w")
            f:write("ok")
            f:close()
        end

        print("key:" .. key)
        return ping.run(
            {
                url = "http://maker.ifttt.com/trigger/email/with/key/" .. key,
                encoding = "json",
                data = data,
                method = "POST"
            }
        ):next(
            add_battery_email_sent_file,
            function()
                print("Failed to ping ifttt")
            end
        )
    end
end

return M
