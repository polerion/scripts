script_name('Autoupdate script') -- Г­Г Г§ГўГ Г­ГЁГҐ Г±ГЄГ°ГЁГЇГІГ 
script_author('FORMYS') -- Г ГўГІГ®Г° Г±ГЄГ°ГЁГЇГІГ 
script_description('Autoupdate') -- Г®ГЇГЁГ±Г Г­ГЁГҐ Г±ГЄГ°ГЁГЇГІГ 

require "lib.moonloader" -- ГЇГ®Г¤ГЄГ«ГѕГ·ГҐГ­ГЁГҐ ГЎГЁГЎГ«ГЁГ®ГІГҐГЄГЁ
local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'
local keys = require "vkeys"
local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

update_state = false

local script_vers = 2
local script_vers_text = "1.01"

local script_path = thisScript().path
local script_url = 'https://raw.githubusercontent.com/polerion/scripts/main/autoupdate.lua'

local update_path = getWorkingDirectory() .. "update.ini"
local update_url = 'https://raw.githubusercontent.com/polerion/scripts/main/update.ini'




function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    sampRegisterChatCommand("update", cmd_update)

    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load (nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then
                sampAddChatMessage('Привет. Скрипт может быть обновлён. Новая версия:' .. updateIni.info.vers_text, -1)
                update_state = true
            end
            os.remove(update_path)
        end

    end)

	while true do
        wait(0)
        if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage('Скрипт обновлён', -1)

                end
            end)
        end
	end
end

function cmd_update(arg)
    sampShowDialog(1000, "Автообновление", "Возможность автообновления", "Новая версия: ".. script_vers_text, "", 0)
end
