-- luacheck: globals adc cjson wifi

-- see https://ifttt.com/maker_webhooks for documentation

-- config values are
--     name: the name of the ifttt event
--     key: the key from the documentation page of https://ifttt.com/maker_webhooks
--     data: (optional) a table of data only keys of value1, value2 and value3 will work
--           mac_address and adc_level are added to value1 and value2 if none are provided

-- curl -X POST -H "Content-Type: application/json" -d '{"value1":"","value2":"","value3":"testing"}'
--   "http://maker.ifttt.com/trigger/alert/with/key/$(cat ~/.config/ifttt/key)"

require("ark-uri")
local ping = require("action-ping")

local M = {}

-- config.url
function M.run(config)
    print("action-ifttt.run(" .. cjson.encode(config) .. ")")
    local data = {
        value1 = wifi.sta.getmac(),
        value2 = adc.readvdd33()
    }
    for k, v in pairs(config.data or {}) do
        data[k] = v
    end

    local secrets = require("secrets")
    local key = config.key or secrets.ifttt_key
    return ping.run(
        {
            url = "http://maker.ifttt.com/trigger/" .. config.name .. "/with/key/" .. key,
            encoding = "json",
            data = data,
            method = "POST"
        }
    )
end

return M
