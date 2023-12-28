local languages = {
    en = {
        permissionRequired = 'Anticheat requires permission: {1}\nEasiest fix is to add this permission to server/mods/deathmatch/acl.xml',
        permissionRequiredReload = 'After that, type reloadacl in F8 or server console',
        clickToCopy = 'Click here to copy to clipboard',
        copiedToClipboard = 'Copied to clipboard',
    },
    se = {
        permissionRequired = 'Anticheat kräver tillstånd: {1}\nEnklaste lösningen är att lägga till detta tillstånd i server/mods/deathmatch/acl.xml',
        permissionRequiredReload = 'Skriv sedan reloadacl i F8 eller serverkonsolen',
        clickToCopy = 'Klicka här för att kopiera till klippbord',
        copiedToClipboard = 'Kopierad till urklipp'
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
