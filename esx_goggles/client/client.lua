local ESX = nil
local isNightVisionActive = false
local isThermalVisionActive = false
local isGogglesActive = false
local currentMode = 'NV'
local currentModeIndex = 1
local isBusy = false
local playerCanUseGoggles = false

-- Inicialización
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    
    ESX.TriggerServerCallback('esx_goggles:server:canPlayerUseGoggles', function(canUse)
        playerCanUseGoggles = canUse
    end)
end)

-- Actualizar permisos cuando cambia el trabajo
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.TriggerServerCallback('esx_goggles:server:canPlayerUseGoggles', function(canUse)
        playerCanUseGoggles = canUse
        
        if not playerCanUseGoggles and isGogglesActive then
            TurnOffGoggles()
            ESX.ShowNotification('Has perdido el permiso para usar las gafas. Apagando.', Config.Color)
        end
    end)
end)

-- Función para verificar posesión del ítem
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

-- Función mejorada para aplicar modos
local function ApplyMode(modeKey)
    local mode = Config.VisionModes[modeKey]
    if not mode then return end

    -- Verificar acceso para modos avanzados
    if modeKey == 'AR' or modeKey == 'ST' then
        ESX.TriggerServerCallback('esx_goggles:server:hasAdvancedAccess', function(hasAccess)
            if not hasAccess then
                ESX.ShowNotification('No tienes acceso a este modo táctico.', 'error')
                return
            end
            ActuallyApplyMode(modeKey, mode)
        end, modeKey)
    else
        ActuallyApplyMode(modeKey, mode)
    end
end

-- Función que aplica físicamente el modo
local function ActuallyApplyMode(modeKey, mode)
    -- Limpiar efectos anteriores
    StopScreenEffect('ChopVision')
    StopScreenEffect('ThermalVision') 
    StopScreenEffect('FocusIn')
    SetNightvision(false)
    SetThermalVision(false)

    -- Aplicar nuevo modo
    if mode.effect then
        StartScreenEffect(mode.effect, 0, true)
    end
    SetNightvision(mode.setNightvision or false)
    SetThermalVision(mode.setThermalVision or false)

    -- Actualizar estado
    isNightVisionActive = mode.setNightvision
    isThermalVisionActive = mode.setThermalVision
    currentMode = modeKey

    -- Efectos especiales por modo
    if mode.reduceFootprint then
        SetPlayerTargetingMode(3)
        SetPlayerCanDoDriveBy(PlayerId(), false)
    else
        SetPlayerTargetingMode(0)
        SetPlayerCanDoDriveBy(PlayerId(), true)
    end

    -- Activar comunicaciones tácticas si están configuradas
    if Config.TacticalComms.enabled and isGogglesActive then
        ESX.ShowNotification('Comms Tácticas - Canal ' .. Config.TacticalComms.radioChannel, Config.Color)
    end

    ESX.ShowNotification('HMD: ' .. mode.label .. ' ~g~ACTIVADO~s~', Config.Color)
end

-- Función para apagar completamente las gafas
local function TurnOffGoggles()
    StopScreenEffect('ChopVision')
    StopScreenEffect('ThermalVision')
    StopScreenEffect('FocusIn')
    SetNightvision(false)
    SetThermalVision(false)
    SetPlayerTargetingMode(0)
    SetPlayerCanDoDriveBy(PlayerId(), true)
    
    isNightVisionActive = false
    isThermalVisionActive = false
    isGogglesActive = false
    ESX.ShowNotification('Sistema HMD ~r~DESACTIVADO~s~.', Config.Color)
end

-- BUCLE 1: Activación/Desactivación (Tecla Z)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)

        if IsControlJustPressed(0, Config.ToggleKey) then
            if isBusy then 
                Citizen.Wait(Config.Timeout)
            else
                isBusy = true
                
                if not playerCanUseGoggles then
                    ESX.ShowNotification('Tu facción no te permite usar el HMD Táctico.', 'error')
                elseif not HasGogglesItem() then
                    ESX.ShowNotification('No tienes el equipo táctico requerido.', 'error')
                else
                    if not isGogglesActive then
                        -- Encender sistema
                        isGogglesActive = true
                        currentModeIndex = 1
                        ApplyMode(Config.ModeCycle[currentModeIndex])
                    else
                        -- Apagar sistema
                        TurnOffGoggles()
                    end
                end
                
                Citizen.Wait(Config.Timeout)
                isBusy = false
            end
        end
    end
end)

-- BUCLE 2: Cambio de Modos (Tecla J)
Citizen.CreateThread(function()
    while true do
        if isGogglesActive then
            Citizen.Wait(5)

            if IsControlJustPressed(0, Config.ChangeModeKey) then
                if isBusy then 
                    Citizen.Wait(Config.Timeout)
                else
                    isBusy = true
                    
                    -- Ciclar al siguiente modo
                    currentModeIndex = (currentModeIndex % #Config.ModeCycle) + 1
                    ApplyMode(Config.ModeCycle[currentModeIndex])
                    
                    Citizen.Wait(Config.Timeout)
                    isBusy = false
                end
            end
        else
            Citizen.Wait(500)
        end
    end
end)

-- BUCLE 3: HUD Táctico (Información en pantalla)
Citizen.CreateThread(function()
    while true do
        if isGogglesActive then
            local mode = Config.VisionModes[currentMode]
            if mode then
                -- Mostrar información del HMD
                SetTextFont(0)
                SetTextScale(0.4, 0.4)
                SetTextColour(255, 255, 255, 255)
                SetTextEntry("STRING")
                AddTextComponentString("🛡️ HMD TÁCTICO | " .. mode.label)
                DrawText(0.005, 0.011)
                
                -- Mostrar teclas de control
                SetTextEntry("STRING")
                AddTextComponentString("~INPUT_VEH_HEADLIGHT~ Encender/Apagar | ~INPUT_VEH_HORN~ Cambiar Modo")
                DrawText(0.005, 0.035)
            end
        end
        Citizen.Wait(0)
    end
end)

-- Limpieza al detener el recurso
AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    if isGogglesActive then
        TurnOffGoggles()
        TriggerServerEvent('esx_goggles:server:playerDisconnectedWithGoggles') 
    end
end)