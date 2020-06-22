-- luacheck: globals cjson file
local M = {}

-- one day we can replace this with file.getcontents
local function getcontents(name)
    if file.open(name) then
	contents = ""
	while true do
	    local r = file.read()
	    if r == nil then
		break
	    end
	    contents = contents .. r
	end
	file.close()
	return contents
    end
end

M.config = cjson.decode(getcontents("config.json"))
M.actions = M.config.actions


return M
