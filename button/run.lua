-- luacheck: globals file cjson

print("RUN!")

local deferred = require('deferred')

-- Load config

-- one day we can replace this with file.getcontents
local function getcontents(name)
    if file.open(name) then
	local contents = file.read()
	file.close()
	return contents
    end
end

local config = cjson.decode(getcontents("config.json"))

-- do all the things
local promise = deferred.new()
promise:resolve()

for _, config_action in pairs(config.actions) do
    local next = require("action-" .. config_action.type).run(config_action.config)

    promise:next(function() return next end)
    promise = next
end

local function bye()
    dofile("bye.lua")
end

promise:next(bye, bye)
