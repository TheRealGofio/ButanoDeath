--[[
    ButanoDeath - Reproduce un audio cuando el jugador muere
    Compatible con WoW Classic Era / Vanilla / Retail
]]

local SOUND_FILE = "Interface\\AddOns\\ButanoDeath\\sounds\\death.mp3"

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_DEAD")
frame:RegisterEvent("PLAYER_ALIVE")
frame:RegisterEvent("PLAYER_UNGHOST")

local wasDead = false

local function PlayDeathAudio()
    -- Intentamos con canal Master primero
    local played = PlaySoundFile(SOUND_FILE, "Master")
    if not played then
        -- Si no funciona con Master, reproducimos normal
        PlaySoundFile(SOUND_FILE)
    end
end

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_DEAD" then
        if not wasDead then
            wasDead = true
            PlayDeathAudio()
            print("|cffff6600[ButanoDeath]|r Te has caído por las escaleras yendo a llevarle el butano a tu abuela... F")
        end
    elseif event == "PLAYER_ALIVE" or event == "PLAYER_UNGHOST" then
        if not UnitIsDeadOrGhost("player") then
            wasDead = false
        end
    end
end)

-- Comandos en chat: /butanodeath o /bd o /butano
SLASH_BUTANODEATH1 = "/butanodeath"
SLASH_BUTANODEATH2 = "/bd"
SLASH_BUTANODEATH3 = "/butano"
SlashCmdList["BUTANODEATH"] = function(msg)
    PlayDeathAudio()
end
