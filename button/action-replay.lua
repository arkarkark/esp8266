-- luacheck: globals cjson
local M = {}

-- replay a named action from the config.json file
-- finds the action with a name matching the name in the config table.
-- optionally overwrites some values from the original config with the values in config.config
-- you can also provide a type rather than a name, then the first action of that type will be replayed.

-- {
--   "actions": [
--     {
--       "config": {
--         "seconds": 1
--       },
--       "name": "test",
--       "type": "print"
--     },
--     {
--       "config": {
--         "config": {
--           "seconds": 10
--         },
--         "name": "test"
--       },
--       "type": "replay"
--     }
--   ]
-- }

function M.run(config)
    print("action-replay.run(" .. cjson.encode(config) .. ")")
    local action_name = config.name
    local action_type = config.type
    local actions = require('config').actions

    for i = 1, #actions do
	local name_ok = (not action_name) or actions[i].name == action_name
	local type_ok = (not action_type) or actions[i].type == action_type
	if name_ok and type_ok then
	    local new_action = cjson.decode(cjson.encode(actions[i]))
	    for key, value in pairs(config.config or {}) do
		new_action.config[key] = value
	    end
	    return require('run').run_action(new_action)
	end
    end
    print("Unable to find action named '" .. action_name .. "' or of type '" .. action_type .. "'to replay")
end

return M
