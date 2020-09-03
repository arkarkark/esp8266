local M = {}

local promise = require("lua-promise")

local config = require("config").config

M.actionIndex = 1
M.insertIndex = 2

function M.run_action(action)
    print("Running " .. action.type .. " from index:" .. M.actionIndex .. " insertIndex:" .. M.insertIndex)
    return require("action-" .. action.type).run(action.config or {})
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
    M.insertIndex = M.actionIndex + 1
    return promise
end

function M.add(name, action_config)
    print("adding " .. name .. " at " .. M.insertIndex)
    table.insert(config.actions, M.insertIndex, {type = name, config = action_config})
    M.insertIndex = M.insertIndex + 1
end

function M.run()
    local reply = do_next_action()
    if type(reply) == "boolean" and reply == false then
        print("Action returned false so stopping")
        return
    end
    if type(reply) == "table" and type(reply.next) == "function" then
        reply:next(M.run, M.run)
    else
        M.run()
    end
end

return M
