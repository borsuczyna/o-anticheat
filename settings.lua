local date = os.date("*t")
local settings = {
    language = 'en',
    logFile = ('logs/%04d-%02d-%02d-%02d-%02d-%02d.log'):format(date.year, date.month, date.day, date.hour, date.min, date.sec),
    -- logFile = 'logs/latest.log',
}

local useAnticheat = {
    lockerCheck = true,
    flyHack = true,
    vehicleFlyHack = true,
    explosions = true,
    damageMultiplier = true,
    triggerSpam = true,
    explodePlayers = true,
    speedHack = true,
    handlingHack = true,
    luaExecutor = true,
    massElementDataChanger = true,
}

copyrightPosition = 2

local webhookName = 'o-anticheat'
local discordWebHook = false -- 'https://discord.com/api/webhooks/<example>'
local embedColor = 0x00ff00

local protectedElementDatas = {
    'vehicle:owner', 'vehicle:ownedPlayer', 'vehicle:ownedGroup', 'vehicle:ownedBy',
    'vehicle:id', 'vehicle:sid', 'vehicle:uid',
    'player:id', 'player:sid', 'player:uid',
    'player:admin', 'player:rank', 'player:rankName', 'player:group', 'player:groupRank', 'player:groupRankName', 'player:level',
    'player:money', 'player:bankMoney', 'player:premiumMoney', 'player:premiumCredits', 'player:premiumExpire', 'player:premiumExpireTime',
}

local loadstringAllowedResources = {
    clientSide = {
        'YOUR_RESOURCE_NAME',
    },
    serverSide = {
        'YOUR_RESOURCE_NAME',
    }
}

function getAnticheatSetting(setting)
    return useAnticheat[setting]
end

function getDiscordWebhook()
    return webhookName, discordWebHook, embedColor
end

function isResourceLoadstringAllowed(resourceName)
    local side = (not not localPlayer) and 'clientSide' or 'serverSide'
    for _, allowedResource in ipairs(loadstringAllowedResources[side]) do
        if allowedResource == resourceName then
            return true
        end
    end
    return false
end

function isElementDataProtected(elementData)
    for _, protectedElementData in ipairs(protectedElementDatas) do
        if protectedElementData == elementData then
            return true
        end
    end
    return false
end

function getSetting(setting)
    return settings[setting]
end