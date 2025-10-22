fx_version 'cerulean'
games { 'gta5' }

name 'ESX Goggles (Night/Thermal Vision)'
author 'IA Assistant'
description 'Sistema de Gafas con Visión Nocturna y Térmica, restringido por Facciones (Job).'

shared_scripts {
    '@es_extended/imports.lua',
    '@es_extended/config.lua',
    'config.lua'
}

client_scripts {
    '@es_extended/client/main.lua',
    'client/client.lua'
}

server_scripts {
    '@es_extended/server/main.lua',
    'server/server.lua'
}