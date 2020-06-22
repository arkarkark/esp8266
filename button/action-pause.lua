-- luacheck: globals cjson tmr
local M = {}

-- Pause for a certain amount of time (can provide a number in a
-- combination of hours, minutes and seconds.

-- ` if config has a section called wifi then before pausing the wifi
-- will be shut off (to save power) and then at the end of the pause
-- the wifi will connect again. NOTE: wifi connection may take a few seconds

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
    local promise = require('lua-promise')
    print("Pausing for " .. seconds .. " seconds")

    if config.wifi then
        require("action-wifioff").run()
    end

    return promise.new(
        function(resolve, _)
	    local function alldone ()
		print("All done with tmr pause")
		local wifion_promise = promise.resolve()
		if config.wifi then
		    print("pause will turn wifi back on before exiting")
		    wifion_promise = require("action-wifion").run(config.wifi)
		end
		wifion_promise:next(resolve)
	    end
	    print("Starting tmr pause")
	    tmr.alarm(2, seconds * 1000, tmr.ALARM_SINGLE, alldone)
	end
    )
end

return M
