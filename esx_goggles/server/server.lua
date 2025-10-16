-- server/server.lua (CÓDIGO COMPLETO FINAL - ESX_GOGGLES con FACCIONES ÉLITE)

local ESX = nil

TriggerEvent('esx:getExtendedServer', function(obj) ESX = obj end)

-- Callback para que el cliente pueda verificar si el trabajo del jugador tiene permiso para USAR las gafas.
-- Esta función es clave para restringir el uso a facciones de élite (legales o criminales).
ESX.RegisterServerCallback('esx_goggles:server:canPlayerUseGoggles', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local canUse = false

    -- Usamos la lista de facciones autorizadas
    if #Config.AllowedFactions == 0 then
        -- 1. Si la lista está vacía, cualquiera puede usarlas.
        canUse = true
    else
        -- 2. Comprobamos si el job del jugador está en la lista de facciones autorizadas.
        for _, factionName in ipairs(Config.AllowedFactions) do
            if xPlayer.job.name == factionName then
                canUse = true
                break
            end
        end
    end
    
    cb(canUse) 
end)

-- Evento para limpiar el estado si el jugador se desconecta con las gafas puestas (Placeholder/Seguridad)
RegisterNetEvent('esx_goggles:server:playerDisconnectedWithGoggles')
AddEventHandler('esx_goggles:server:playerDisconnectedWithGoggles', function()
    -- Lógica de limpieza o registro si se necesita en el futuro.
end)

