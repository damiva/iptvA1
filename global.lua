-- Definitions:
url, pks, cff = "http://help.a1.by/_files/TelecomTV/TelecomTVpacket/TVPACKET", {"Социальный", "Базовый", "Расширенный"}, "config.txt"
pkd, gps = 3, ""
-- Libs:
serv, json = require("server"), require("json")
-- Get params:
local c, e = serv.file(cff)
assert(e == nil, e)
if c ~= nil then
    local p, g = c:match("^(.-)\n(.*)$")
    pkd = tonumber(p)
    if pkd == nil or pkd < 1 or pkd > 3 then pkd = 3 end
    if g ~= nil then gps = g end
end