--[[
    ButanoDeath - Reproduce un audio cuando tú o alguien de tu grupo muere
    Compatible con WoW Classic Era / Vanilla / Retail / Forever
]]

local SOUND_FILE = "Interface\\AddOns\\ButanoDeath\\sounds\\death.mp3"
local ADDON_PREFIX = "ButanoDeath"

-- Registro de prefijo para comunicación interna de addons
local function RegisterPrefix()
    if C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix then
        C_ChatInfo.RegisterAddonMessagePrefix(ADDON_PREFIX)
    elseif RegisterAddonMessagePrefix then
        RegisterAddonMessagePrefix(ADDON_PREFIX)
    end
end

-- Envío de mensaje invisible al grupo/banda
local function SendAddonBroadcast(msg)
    local chatType = nil
    if IsInRaid and IsInRaid() then
        chatType = "RAID"
    elseif IsInGroup and IsInGroup() then
        chatType = "PARTY"
    end

    if chatType then
        if C_ChatInfo and C_ChatInfo.SendAddonMessage then
            C_ChatInfo.SendAddonMessage(ADDON_PREFIX, msg, chatType)
        elseif SendAddonMessage then
            SendAddonMessage(ADDON_PREFIX, msg, chatType)
        end
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_DEAD")
frame:RegisterEvent("PLAYER_ALIVE")
frame:RegisterEvent("PLAYER_UNGHOST")
frame:RegisterEvent("CHAT_MSG_ADDON")

local wasDead = false
local lastPlayed = 0
local COOLDOWN = 3 -- 3 segundos de margen para evitar saturar el audio en un wipe completo

local function PlayDeathAudio()
    local now = GetTime()
    if now - lastPlayed < COOLDOWN then
        return
    end
    lastPlayed = now

    -- Intentamos con canal Master primero
    local played = PlaySoundFile(SOUND_FILE, "Master")
    if not played then
        PlaySoundFile(SOUND_FILE)
    end
end

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        RegisterPrefix()

    elseif event == "PLAYER_DEAD" then
        if not wasDead then
            wasDead = true
            PlayDeathAudio()
            print("|cffff6600[ButanoDeath]|r Te has caído por las escaleras yendo a llevarle el butano a tu abuela... F")
            
            -- Avisamos a todos los compañeros del grupo/raid que tengan el addon
            local playerName = UnitName("player") or "Alguien"
            SendAddonBroadcast("DEATH:" .. playerName)
        end

    elseif event == "PLAYER_ALIVE" or event == "PLAYER_UNGHOST" then
        if not UnitIsDeadOrGhost("player") then
            wasDead = false
        end

    elseif event == "CHAT_MSG_ADDON" then
        local prefix, message, channel, sender = ...
        if prefix == ADDON_PREFIX then
            -- Verificamos si no somos nosotros mismos (nuestro propio cliente ya lo reproduce al morir)
            local senderName = sender and strsplit("-", sender)
            local myName = UnitName("player")

            if senderName and myName and senderName ~= myName then
                if message and message:find("^DEATH:") then
                    local victim = message:sub(7)
                    PlayDeathAudio()
                    print("|cffff6600[ButanoDeath]|r ¡|cffffffff" .. victim .. "|r se ha caído por las escaleras con la bombona! F")
                elseif message == "PLAY" then
                    PlayDeathAudio()
                end
            end
        end
    end
end)

-- Comandos en chat: /butanodeath o /bd o /butano
SLASH_BUTANODEATH1 = "/butanodeath"
SLASH_BUTANODEATH2 = "/bd"
SLASH_BUTANODEATH3 = "/butano"
SlashCmdList["BUTANODEATH"] = function(msg)
    PlayDeathAudio()
    -- Si estamos en grupo/raid, también lo enviamos para que suene a los demás
    SendAddonBroadcast("PLAY")
end

