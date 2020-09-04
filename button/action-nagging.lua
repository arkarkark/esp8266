local M = {}

local run = require("run")

function M.run(config)
    run.add("pause", config.initial_delay)
    for i = 1, #config.messages do
        local data = {
            title = config.title,
            message = config.messages[i]
        }
        if config.device then
            data.device = config.device
        end
        if config.sound then
            data.sound = config.sound
        end

        run.add("pause", config.delay)
        run.add("wifion")
        run.add("pushover", data)
	if i == 1 then
	    run.add("battery", {name = config.title})
	end
        run.add("wifioff")
    end
    run.add("end", {sleep = true})
end

return M
