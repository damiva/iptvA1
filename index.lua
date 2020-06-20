dofile("global.lua")
local http = require("http")
-- Get playlist.m3u:
local r,e = http.get(url .. pkd .. ".m3u")
assert(r ~= nil, e)
-- Create playlist.fxml:
local pl = {
    cacheinfo = "nocache",
    is_iptv = true,
    url_tvg = "http://help.telecom.by/_files/TelecomTV/TelecomTVepg/xmltv.xml",
    menu = {
        {
            title = "Пакет: <b style='color:lime'>" .. pks[pkd] .. "</b>",
            logo_30x30 = serv.url_root .. "/logo.png",
            playlist_url = "submenu",
            submenu = {}
        },
        {
            title = "Категории: <b style='color:" .. (gps == "" and "lime'>ВСЕ" or "orange'>не все</b>") .. "</b>",
            logo_30x30 = serv.url_root .. "/cat.svg",
            playlist_url = "submenu",
            submenu = {{
                title = "ВСЕ",
                playlist_url = serv.url_root .. "/set.lua?ON=*", 
                logo_30x30 = serv.url_root .. (gps == "" and "/on.svg" or "/off.svg")
            }}
        }
    },
    channels = {}
}
-- Add packets menu:
for i = 1, 3 do
    pl.menu[1].submenu[i] = {
        title = pks[i],
        playlist_url = serv.url_root .. "/set.lua?PACKET=" .. i,
        logo_30x30 = serv.url_root .. (i == pkd and "/on.svg" or "/off.svg")
    }
end
-- Parse playlist.m3u & add channels to playlist.fxml:
local gt = ""
for i, t, u in r.body:gmatch('#EXTINF:(.-),%s*(.-)%c(.-)%c') do 
    local g = i:match('^.-group%-title="(.-)".*$')
    if g then 
        gt = g:gsub("%-", "−")
        pl.menu[2].submenu[#pl.menu[2].submenu + 1] = {
            title = gt,
            playlist_url = serv.url_root .. "/set.lua?" .. (gps ~= "" and gps:find(gt, 1, true) and "OFF=" or "ON=") .. serv.encuri(gt), 
            logo_30x30 = serv.url_root .. (gps ~= "" and gps:find(gt, 1, true) and "/on.svg" or "/off.svg")
        }
    end
    if gps == "" or gps:find(gt, 1, true) then pl.channels[#pl.channels + 1] = {title = t:gsub("%(тест%)", ""), stream_url = u} end
end
-- Send playlist.fxml:
serv.header("Content-Type", "application/json; charset=UTF-8")
serv.body(json.encode(pl))
