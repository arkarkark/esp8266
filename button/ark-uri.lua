function encodeURIComponent(str)
   if (str) then
      str = string.gsub (str, "([^%w_ %- . ~])",
			 function (c) return string.format ("%%%02X", string.byte(c)) end)
   end
   return str
end

function encodeURITable(table)
   local reply = ""
   for k, v in pairs(table) do
      if string.len(reply) > 0 then reply = reply .. "&" end
      reply = reply .. encodeURIComponent(k) .. "=" .. encodeURIComponent(v)
   end
   return reply
end
