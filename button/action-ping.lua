-- luacheck: globals adc cjson gpio http net table tmr wifi

-- config values are
--     url: the url to hit
--     data: (optional) a table of data to send mac_address and adc_level are added to this table
--     encoding: either uri (default) or json
--     method:  POST (default) or GET

local uri = require("ark-uri")

local M = {}

function M.run(config)
    print("action-ping.run")
    local promise = require('deferred').new()

    local data = {
	mac_address=wifi.sta.getmac(),
	adc_level=adc.readvdd33()
    }
    for k,v in pairs(config.data or {}) do
	data[k] = v
    end

    local encode = uri.encodeTable
    local content_type = "application/x-www-form-urlencoded"
    if config.encoding == "json" then
	encode = cjson.encode
	content_type = "application/json"
    end

    data = encode(data)

    local method = string.lower(config.method) or "post"

    print("http." .. method .. ": " .. config.url .. " with: " .. content_type .. "\n" .. data)

    http[method](
	config.url,
	"Content-Type: " .. content_type .. "\r\n",
	data,
	function(status_code, body, headers)
	    if status_code == -1 then
		promise:reject(status_code, body, headers)
		print("ERROR", status_code, body, cjson.encode(headers))
	    else
		promise:resolve(status_code, body, headers)
		print("Success", status_code, body, cjson.encode(headers))
	    end
	end
    )
    return promise
end

return M
