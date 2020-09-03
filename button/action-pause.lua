-- luacheck: globals cjson tmr
local M = {}

-- Pause for a certain amount of time (can provide a number in a
-- combination of hours, minutes and seconds.

function M.run(config)
    print("action-pause.run(" .. cjson.encode(config) .. ")")
    local seconds = 0
    if config.hours then
        seconds = seconds + config.hours * 60 * 60
    end
    if config.minutes then
        seconds = seconds + config.minutes * 60
    end
    if config.seconds then
        seconds = seconds + config.seconds
    end

    return require("lua-promise").new(
        function(resolve, _)
            print("Pausing for " .. seconds .. " seconds")
            tmr.alarm(2, seconds * 1000, tmr.ALARM_SINGLE, resolve)
        end
    )
end

return M
