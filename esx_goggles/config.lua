
-- config.lua (CÓDIGO COMPLETO FINAL - ESX_GOGGLES con FACCIONES ÉLITE)

Config = {}

-- Nombre del objeto que el jugador debe tener en el inventario para poder usar la función.
-- DEBES ASEGURARTE de que este objeto exista en tu base de datos (items).
Config.GogglesItemName = 'nightvision_goggles' 

-- [[ CONFIGURACIÓN DE TECLAS ]]
Config.ToggleKey = 20      -- Código de tecla para ENCEDER/APAGAR (INPUT_VEH_HEADLIGHT - Tecla N/H)
Config.ChangeModeKey = 74  -- Código de tecla para CAMBIAR MODO (Tecla J)

-- [[ CONFIGURACIÓN DE FACCIONES AUTORIZADAS ]]
-- Lista de jobs permitidos para USAR las gafas. 
-- Incluye trabajos legales (policía, militar) y trabajos/bandas criminales (mafia, cartel).
-- El script SÓLO permitirá el uso a los jobs que estén en esta lista.
Config.AllowedFactions = {
    -- Facciones de Ley/Militares
    'police', 
    'swat', 
    'military', 
    
    -- Facciones Criminales de Élite
    'cartel',   -- Ejemplo de job para un Cártel
    'mafia',    -- Ejemplo de job para una Mafia
    'yakuza'    -- Ejemplo de job para una Yakuza
    -- Asegúrate de que estos nombres coincidan con los job.name de tu servidor
}

-- Color de la interfaz/notificación
Config.Color = 'inform' 

-- Tiempos de espera
Config.Timeout = 100 -- Pequeño timeout para evitar spamming de la tecla
