fx_version 'cerulean'
game 'gta5'

name 'esx_goggles'
author 'YourName'
description 'Advanced Tactical HMD System for ESX'
version '2.0.0'
license 'MIT'

shared_script '@es_extended/imports.lua'
shared_script 'config.lua'

client_scripts {
    '@es_extended/client/common.lua',
    'client/client.lua'
}

server_scripts {
    '@es_extended/server/common.lua',
    'server/server.lua'
}

dependencies {
    'es_extended'
}