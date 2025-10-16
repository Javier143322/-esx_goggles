-- client/client.lua (CÓDIGO COMPLETO FINAL - ESX_GOGGLES con FACCIONES ÉLITE)

local ESX = nil
local isNightVisionActive = false
local isThermalVisionActive = false
local isGogglesActive = false     -- Estado general de las gafas encendidas
local currentMode = 'NV'          -- Modo actual por defecto ('NV' o 'TV')
local isBusy = false              -- Flag para evitar spamming
local playerCanUseGoggles = false -- Permiso de trabajo/job (viene del servidor)

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getExtendedClient', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    
    -- 1. Verificar el permiso de trabajo/job inicial
    ESX.TriggerServerCallback('esx_goggles:server:canPlayerUseGoggles', function(canUse)
        playerCanUseGoggles = canUse
    end)
end)

-- 2. Actualizar el permiso si el trabajo del jugador cambia
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.TriggerServerCallback('esx_goggles:server:canPlayerUseGoggles', function(canUse)
        playerCanUseGoggles = canUse
        
        -- Si el jugador pierde el permiso (ej. es despedido o cambia de job) y las tiene activas, las apagamos.
        if not playerCanUseGoggles and isGogglesActive then
            TurnOffGoggles()
            ESX.ShowNotification('Has perdido el permiso para usar las gafas. Apagando.', Config.Color)
        end
    end)
end)

-- Función para comprobar si el jugador tiene el objeto de las gafas
local function HasGogglesItem()
    local xPlayer = ESX.GetPlayerData()
    if xPlayer and xPlayer.inventory then
        for i=1, #xPlayer.inventory, 1 do
            local item = xPlayer.inventory[i]
            if item.name == Config.GogglesItemName and item.count > 0 then
                return true
            end
        end
    end
    return false
end

-- Función para aplicar un modo específico (NV o TV)
local function ApplyMode(mode)
    StopScreenEffect('ChopVision')
    StopScreenEffect('ThermalVision')
    SetNightvision(false)
    SetThermalVision(false)

    isNightVisionActive = false
    isThermalVisionActive = false

    if mode == 'NV' then
        StartScreenEffect('ChopVision', 0, true) 
        SetNightvision(true)
        isNightVisionActive = true
        currentMode = 'NV'
        ESX.ShowNotification('Visión Nocturna ~g~ACTIVADA~s~. (Cambiar con Tecla J)', Config.Color)
    elseif mode == 'TV' then
        StartScreenEffect('ThermalVision', 0, true) 
        SetThermalVision(true)
        isThermalVisionActive = true
        currentMode = 'TV'
        ESX.ShowNotification('Visión Térmica ~g~ACTIVADA~s~. (Cambiar con Tecla J)', Config.Color)
    end
end

-- Función para apagar completamente las gafas
local function TurnOffGoggles()
    StopScreenEffect('ChopVision')
    StopScreenEffect('ThermalVision')
    SetNightvision(false)
    SetThermalVision(false)
    isNightVisionActive = false
    isThermalVisionActive = false
    isGogglesActive = false
    ESX.ShowNotification('Gafas ~r~DESACTIVADAS~s~.', Config.Color)
end

-- BUCLE 1: Detección de la tecla de Activación/Desactivación (Config.ToggleKey - Tecla N/H)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)

        if IsControlJustPressed(0, Config.ToggleKey) then
            if isBusy then 
                Citizen.Wait(Config.Timeout)
            else
                isBusy = true
                
                -- 1. Verificar Permiso de Trabajo (Policía, Cártel, Mafia, etc.)
                if not playerCanUseGoggles then
                    ESX.ShowNotification('Tu facción no te permite usar estas gafas.', Config.Color)
                -- 2. Verificar Objeto en Inventario
                elseif HasGogglesItem() then
                    if not isGogglesActive then
                        -- Encender
                        isGogglesActive = true
                        ApplyMode(currentMode)
                    else
                        -- Apagar
                        TurnOffGoggles()
                    end
                else
                    ESX.ShowNotification('No tienes el objeto "' .. Config.GogglesItemName .. '" para usar esta función.', Config.Color)
                end
                
                Citizen.Wait(Config.Timeout)
                isBusy = false
            end
        end
    end
end)

-- BUCLE 2: Detección de la tecla para cambiar de modo (Config.ChangeModeKey - Tecla J)
Citizen.CreateThread(function()
    while true do
        -- Solo revisar si las gafas están activas
        if isGogglesActive then
            Citizen.Wait(5)

            if IsControlJustPressed(0, Config.ChangeModeKey) then
                if isBusy then 
                    Citizen.Wait(Config.Timeout)
                else
                    isBusy = true
                    if currentMode == 'NV' then
                        ApplyMode('TV')
                    else
                        ApplyMode('NV')
                    end
                    Citizen.Wait(Config.Timeout)
                    isBusy = false
                end
            end
        else
            Citizen.Wait(500)
        end
    end
end)


-- Evento para resetear los efectos si el script se detiene o el jugador se desconecta
AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    if isGogglesActive then
        TurnOffGoggles()
        TriggerServerEvent('esx_goggles:server:playerDisconnectedWithGoggles') 
    end
end)

