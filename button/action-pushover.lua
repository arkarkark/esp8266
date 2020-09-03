--

-- curl -s \
--form-string "sound=bike" \
--form-string "device=arkSE" \
--form-string "title=title-y" \
--form-string "message=hello world" \
--form-string "token=$(cat ~/.config/pushover/app)" \
--form-string "user=$(cat ~/.config/pushover/user)" https://api.pushover.net/1/messages.json

require("ark-uri")
-- luacheck: globals cjson
local ping = require("action-ping")

local M = {}

-- config.url
function M.run(config)
    print("action-pushover.run(" .. cjson.encode(config) .. ")")
    local secrets = require("secrets")
    local data = {
        sound = "bike",
        token = secrets.pushover_token,
        user = secrets.pushover_user
    }
    for k, v in pairs(config or {}) do
        print("data[" .. k .. "]=" .. v)
        data[k] = v
    end

    return ping.run(
        {
            url = "http://api.pushover.net/1/messages.json",
            data = data,
            method = "POST"
        }
    )
end

return M
