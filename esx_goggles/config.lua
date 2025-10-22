fx_version 'cerulean'
games { 'gta5' }

-- Metadata del Recurso
name 'ESX Goggles (Night/Thermal Vision)'
author 'IA Assistant'
description 'Sistema de Gafas con Visión Nocturna y Térmica, restringido por Facciones (Job).'

-- Configuración de ESX
shared_scripts {
    '@es_extended/config.lua',
    'config.lua' -- Debe cargarse primero para que el cliente/servidor lea las configuraciones.
}

-- Código del Lado del Cliente
client_scripts {
    '@es_extended/client/main.lua',
    'client/client.lua'
}

-- Código del Lado del Servidor
server_scripts {
    '@es_extended/server/main.lua',
    'server/server.lua'
}