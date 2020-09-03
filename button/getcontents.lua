-- one day we can replace this with file.getcontents
function getcontents(name)
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

return getcontents
