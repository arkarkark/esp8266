-- luacheck: globals wifi
local M = {}

function M.run()
    print("action-wifioff.run()")
    wifi.setmode(wifi.NULLMODE)
end

return M
