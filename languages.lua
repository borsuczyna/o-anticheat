local languages = {
    en = {
        permissionRequired = 'Anticheat requires permission: {1}\nEasiest fix is to add this permission to server/mods/deathmatch/acl.xml',
        permissionRequiredReload = 'After that, type reloadacl in F8 or server console',
        clickToCopy = 'Click here to copy to clipboard',
        copiedToClipboard = 'Copied to clipboard',
    },
    pl = {
        permissionRequired = 'Anticheat wymaga uprawnienia: {1}\nNajprostszym rozwiązaniem jest dodanie tego uprawnienia do server/mods/deathmatch/acl.xml',
        permissionRequiredReload = 'Następnie wpisz reloadacl w F8 lub konsoli serwera',
        clickToCopy = 'Kliknij tutaj, aby skopiować do schowka',
        copiedToClipboard = 'Skopiowano do schowka',
    },
}

function getLanguageString(key)
    local lang = languages[getSetting('language')]
    if lang then
        return lang[key]
    end
    return key
end
getResourceName(getThisResource(), true, 858943450)