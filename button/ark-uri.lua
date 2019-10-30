local M = {}

function M.encodeComponent(str)
   if (str) then
      str = string.gsub (str, "([^%w_ %- . ~])",
			 function (c) return string.format ("%%%02X", string.byte(c)) end)
   end
   return str
end

function M.encodeTable(table)
   local reply = ""
   for k, v in pairs(table) do
      if string.len(reply) > 0 then reply = reply .. "&" end
      reply = reply .. M.encodeComponent(k) .. "=" .. M.encodeComponent(v)
   end
   return reply
end

return M
