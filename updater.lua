local repoData = false
local updatedFiles = 0
local filesToUpdate = 0

local function getFileSha(name)
    local name = base64Encode(name):sub(1, 16)
    local shaFile = 'sha/' .. name .. '.sha'
    if fileExists(shaFile) then
        local file = fileOpen(shaFile)
        local sha = fileRead(file, fileGetSize(file))
        fileClose(file)
        return sha
    end

    return false
end

local function onFileUpdate()
    if updatedFiles == filesToUpdate then
        local resourceName = getResourceName(getThisResource())
        restartResource(getResourceFromName(resourceName))
    end
end

local function updateFile(path, content, sha)
    if fileExists(path) then
        fileDelete(path)
    end

    local file = fileCreate(path)
    fileWrite(file, base64Decode(content))
    fileClose(file)

    local name = base64Encode(path):sub(1, 16)
    local shaFile = 'sha/' .. name .. '.sha'
    local file = fileCreate(shaFile)
    fileWrite(file, sha)
    fileClose(file)

    local progress = math.floor(updatedFiles / filesToUpdate * 100)
    print('[o-anticheat] Updated file ' .. path .. ' (' .. progress .. '%)')
    onFileUpdate()
end

local function checkForUpdates()
    -- count files to update
    if repoData then
        for i, file in ipairs(repoData.tree) do
            if file.type == 'blob' then
                local sha = getFileSha(file.path)
                if sha ~= file.sha then
                    filesToUpdate = filesToUpdate + 1
                end
            end
        end

        for i, file in ipairs(repoData.tree) do
            if file.type == 'blob' and file.path ~= 'settings.lua' then
                local sha = getFileSha(file.path)
                if sha ~= file.sha then
                    local url = file.url
                    fetchRemote(url, function(data, err)
                        local data = fromJSON(data)
                        updateFile(file.path, data.content, file.sha)
                        updatedFiles = updatedFiles + 1
                    end)
                end
            end
        end
    end

    if filesToUpdate == 0 then
        print('[o-anticheat] No updates found!')
        initAnticheat()
    else
        print('[o-anticheat] Found ' .. filesToUpdate .. ' files to update!')
    end
end

local function getRepoData()
    local url = 'https://api.github.com/repos/borsuczyna/o-anticheat/git/trees/main?recursive=1'
    fetchRemote(url, function(data, err)
        repoData = fromJSON(data)
        checkForUpdates()
    end)
end

local function startAnticheat()
    getRepoData()
end

addEventHandler('onResourceStart', resourceRoot, startAnticheat)