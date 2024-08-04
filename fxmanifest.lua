fx_version 'cerulean'
game 'gta5'
lua54 "yes"

author 'Zartoz'
description 'Advanced fivem voting system'
version '1.0.0'

shared_scripts {
    'locales/en.lua',
    '@ox_lib/init.lua',
    'locales/*.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

dependencies {
    'qb-core',
    'oxmysql'
}
