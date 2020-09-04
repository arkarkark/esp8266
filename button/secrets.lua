-- luacheck: globals cjson
local M = cjson.decode(require("getcontents")("secrets.json"))

return M
