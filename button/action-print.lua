-- luacheck: globals cjson

local M = {}

function M.run(config)
    print("action-print.run(" .. cjson.encode(config) .. ")")
end

return M
