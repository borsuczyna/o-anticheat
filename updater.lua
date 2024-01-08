local filesToUpdate = 0
local updatedFiles = 0
local started = false

local function updateFile(data, err, fileName)
    if fileExists(fileName) then
        fileDelete(fileName)
    end

    local file = fileCreate(fileName)
    fileWrite(file, data)
    fileClose(file)

    if not file then
        outputAnticheatLog('Failed to update file ' .. fileName .. ' update anticheat manually', true)
        outputDebugString('Failed to update file ' .. fileName .. ' update anticheat manually')
        restartResource(getThisResource())
        return
    end

    updatedFiles = updatedFiles + 1
    print('Updating (' .. updatedFiles .. '/' .. filesToUpdate .. ')')
    if updatedFiles == filesToUpdate then
        outputAnticheatLog('Anticheat updated!', true)
        outputDebugString('Anticheat updated!')
        restartResource(getThisResource())
    end
end

local function updateFiles()
    fetchRemote('https://raw.githubusercontent.com/borsuczyna/o-anticheat/main/files.txt', function(data, err)
        local files = split(data, '\n')

        for i, file in ipairs(files) do
            filesToUpdate = filesToUpdate + 1
        end

        for i, file in ipairs(files) do
            if fileExists(file) then
                fileDelete(file)
            end
            fetchRemote('https://raw.githubusercontent.com/borsuczyna/o-anticheat/main/' .. file, updateFile, '', false, file)
        end
    end)
end

local function checkVersionMatch()
    fetchRemote('https://raw.githubusercontent.com/borsuczyna/o-anticheat/main/version.txt', function(data, err)
        local file = fileOpen('version.txt')
        local version = fileRead(file, fileGetSize(file))
        fileClose(file)

        if data ~= version then
            outputDebugString('Updating anticheat')
            updateFiles()
        else
            outputDebugString('Anticheat is up to date')
            if not started then
                initAnticheat()
                started = true
            end
        end
    end)
end

function addSetting(name, value)
    local settingsFile = fileOpen('settings.lua')
    local settingsData = fileRead(settingsFile, fileGetSize(settingsFile))
    fileClose(settingsFile)

    if string.find(settingsData, name) then return end
    local pos = string.find(settingsData, 'local useAnticheat = {')

    local newSettingsData = string.sub(settingsData, 1, pos + 21) .. '\n\t' .. name .. ' = ' .. tostring(value) .. ',' .. string.sub(settingsData, pos + 22)
    fileDelete('settings.lua')
    local newSettingsFile = fileCreate('settings.lua')
    fileWrite(newSettingsFile, newSettingsData)
    fileClose(newSettingsFile)

    print('Added setting ' .. name .. ' = ' .. tostring(value))

    restartResource(getThisResource())
end

local function startAnticheat()
    if not checkPermissions() then return end
    checkVersionMatch()
    addSetting('resourcesGuard', true)
    addSetting('serialSpoofer', true)
    addSetting('aimbot', true)
end

setTimer(checkVersionMatch, 20 * 60000, 0)

addEventHandler('onResourceStart', resourceRoot, startAnticheat)