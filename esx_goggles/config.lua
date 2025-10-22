Config = {}

-- Nombre del objeto que el jugador debe tener en el inventario para poder usar la función.
Config.GogglesItemName = 'nightvision_goggles' 

-- [[ CONFIGURACIÓN DE TECLAS ]]
Config.ToggleKey = 20      -- Tecla Z (INPUT_VEH_HEADLIGHT)
Config.ChangeModeKey = 74  -- Tecla J (INPUT_VEH_HORN)

-- [[ CONFIGURACIÓN DE FACCIONES AUTORIZADAS ]]
Config.AllowedFactions = {
    'police', 
    'swat', 
    'military', 
    'cartel',
    'mafia', 
    'yakuza'
}

-- [[ CONFIGURACIÓN DE MODOS TÁCTICOS AVANZADOS ]]
Config.VisionModes = {
    ['NV'] = {
        name = "NIGHTVISION",
        label = "Visión Nocturna",
        effect = "ChopVision",
        setNightvision = true,
        setThermalVision = false
    },
    ['TV'] = {
        name = "THERMAL", 
        label = "Visión Térmica",
        effect = "ThermalVision",
        setNightvision = false,
        setThermalVision = true
    },
    ['AR'] = {
        name = "AUGMENTED",
        label = "Realidad Aumentada",
        effect = "FocusIn",
        setNightvision = false,
        setThermalVision = false
    },
    ['ST'] = {
        name = "STEALTH",
        label = "Modo Sigilo",
        effect = "ChopVision",
        setNightvision = true,
        setThermalVision = false,
        reduceFootprint = true
    }
}

-- [[ ORDEN DE CICLO DE MODOS ]]
Config.ModeCycle = {'NV', 'TV', 'AR', 'ST'}

-- [[ CONFIGURACIÓN DE COMUNICACIONES TÁCTICAS ]]
Config.TacticalComms = {
    enabled = true,
    radioChannel = 911,
    rangeMultiplier = 1.5,
    encrypted = true
}

-- [[ CONFIGURACIÓN DE SENSORES ]]
Config.TacticalSensors = {
    motionDetection = true,
    proximityAlert = true,
    scanDistance = 50.0
}

-- Color de la interfaz/notificación
Config.Color = 'inform' 

-- Tiempos de espera
Config.Timeout = 100