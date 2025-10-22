local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Callback principal para verificar permisos de facción
ESX.RegisterServerCallback('esx_goggles:server:canPlayerUseGoggles', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local canUse = false

    if #Config.AllowedFactions == 0 then
        canUse = true
    else
        for _, factionName in ipairs(Config.AllowedFactions) do
            if xPlayer.job.name == factionName then
                canUse = true
                break
            end
        end
    end
    
    cb(canUse) 
end)

-- Nuevo Callback para verificar acceso a modos avanzados
ESX.RegisterServerCallback('esx_goggles:server:hasAdvancedAccess', function(source, cb, mode)
    local xPlayer = ESX.GetPlayerFromId(source)
    local hasAccess = IsPlayerInAllowedFaction(xPlayer)
    
    -- Verificaciones adicionales por modo si es necesario
    if mode == 'ST' then -- Modo Stealth solo para rangos altos
        hasAccess = hasAccess and HasHighRank(xPlayer)
    end
    
    cb(hasAccess)
end)

-- Funciones auxiliares
function IsPlayerInAllowedFaction(xPlayer)
    if #Config.AllowedFactions == 0 then
        return true
    end
    
    for _, factionName in ipairs(Config.AllowedFactions) do
        if xPlayer.job.name == factionName then
            return true
        end
    end
    return false
end

function HasHighRank(xPlayer)
    local highRanks = {'boss', 'lieutenant', 'captain', 'chief', 'leader'}
    for _, rank in ipairs(highRanks) do
        if xPlayer.job.grade_name == rank then
            return true
        end
    end
    return false
end

-- Evento para limpieza de desconexiones
RegisterNetEvent('esx_goggles:server:playerDisconnectedWithGoggles')
AddEventHandler('esx_goggles:server:playerDisconnectedWithGoggles', function()
    -- Lógica de limpieza si se necesita
end)