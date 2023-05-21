local QBCore = exports['qb-core']:GetCoreObject()
local uiopen = false 
local clockedOn = false 
local target = exports['qb-target']

-- Is Player Clocked On? --
CreateThread(function()
    while true do 

        -- Wait 30 Seconds --
        Wait(30000)

        -- Get Player and Player Job Status --
end)

-- Bar Fridge -- 
-- Targets -- 

-- Food Section -- 
-- Targets --

-- UI (Invoicing) Section --
RegisterNetEvent('cd_yellowjack:useui', function()
    if not uiopen then 
        SendNUIMessage({
            type = "openui",
        })
        uiopen = true 
        SetNuiFocus(true, true)
    else 
        SendNUIMessage({
            type = "closeui",
        })
        uiopen = false
        SetNuiFocus(false, false)
end)