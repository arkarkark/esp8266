-- luacheck: globals cjson file
local M = cjson.decode(require("getcontents")("secrets.json") or "{}")

return M
