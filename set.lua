dofile("global.lua")
local pkc = tonumber(serv.form("PACKET"))
local gpn, gpf = serv.form("ON", "OFF")
local n = ""
if pkc ~= nil and pkc > 0 and pkc < 4 then
-- Set packet:
    pkd = pkc
    n = "Выбран пакет: " .. pks[pkc]
elseif gpn == "*" then
-- All groups:
    gps = ""
    n = "Выбраны все группы"
elseif gpn ~= "" then
-- Add group:
    gps = gps .. "\n" .. gpn
    n = "Добавлена группа: " .. gpn
elseif gpf ~= "" then
-- Remove group:
    gps = gps:gsub("\n" .. gpf, "")
    n = "Убрана группа: " .. gpf
end
-- Send command to reload the playlist:
serv.header("Content-Type", "application/json; charset=UTF-8")
if n == "" then 
    serv.body(json.encode({cmd = "stop();"}))
else
    local r, e = serv.file(cff, pkd .. "\n" .. gps)
    assert(r, e)
    serv.body(json.encode({cmd = "reload(0.1);", notify = n}))
end
