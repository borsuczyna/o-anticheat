local filesToUpdate = 0
local updatedFiles = 0

local function updateFile(data, err, fileName)
    if fileExists(fileName) then
        fileDelete(fileName)
    end

    local file = fileCreate(fileName)
    fileWrite(file, data)
    fileClose(file)

    updatedFiles = updatedFiles + 1
    print('Updating anticheat: ' .. updatedFiles .. '/' .. filesToUpdate)
    if updatedFiles == filesToUpdate then
        outputDebugString('Anticheat updated')
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
        initAnticheat()
    end)
end

local function checkVersionMatch()
    -- read whole https://raw.githubusercontent.com/borsuczyna/o-anticheat/main/version.txt
    fetchRemote('https://raw.githubusercontent.com/borsuczyna/o-anticheat/main/version.txt', function(data, err)
        local file = fileOpen('version.txt')
        local version = fileRead(file, fileGetSize(file))
        fileClose(file)

        if data ~= version then
            outputDebugString('Updating anticheat')
            updateFiles()
        else
            outputDebugString('Anticheat is up to date')
            initAnticheat()
        end
    end)
end

local function startAnticheat()
    checkVersionMatch()
end

addEventHandler('onResourceStart', resourceRoot, startAnticheat)