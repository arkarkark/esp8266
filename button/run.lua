-- luacheck: globals cjson file tmr wifi

local M = {}

local promise = require('lua-promise')

local config = require('config').config

M.actionIndex = 1

function M.run_action(action)
    return require("action-" .. action.type).run(action.config)
end

local function do_next_action()
    if M.actionIndex <= #config.actions then
	promise = M.run_action(config.actions[M.actionIndex])
    elseif M.actionIndex - 1 == #config.actions then
	promise = M.run_action({type = "end"})
    else
	return false
    end
    M.actionIndex = M.actionIndex + 1
    return promise
end

function M.run()
    print("RUN!")
    local reply = do_next_action()
    if type(reply) == "boolean" and reply == false then
	print("action returned false so stopping")
	return
    end
    if type(reply) == "table" and type(reply.next) == "function" then
	reply:next(M.run, M.run)
    else
	M.run()
    end
end


return M
