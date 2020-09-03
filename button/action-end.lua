-- luacheck: globals cjson gpio node wifi

local M = {}

-- turn off the wifi, set the gpio pin low to drop power and put the
-- device to sleep incase the pin drop didn't do it.

function M.run(config)
    print("action-end.run(" .. cjson.encode(config) .. ")")
    wifi.setmode(wifi.NULLMODE)
    gpio.write(4, gpio.LOW)
    if config.sleep then
        node.dsleep(0)
    end
end

return M
