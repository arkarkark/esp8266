-- luacheck: globals cjson file
local M = {}

M.config = cjson.decode(require("getcontents")("config.json"))
M.actions = M.config.actions

return M
