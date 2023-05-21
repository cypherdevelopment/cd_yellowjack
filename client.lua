local QBCore = exports['qb-core']:GetCoreObject()
local uiopen = false 
local target = exports['qb-target']

-- Check Duty Status every 30 seconds --
CreateThread(function()
    while true do 

        -- Wait 30 Seconds --
        Wait(10000)

        -- Get Player and Player Job Status --
        local Player = QBCore.Functions.GetPlayerData()
        DutyStatus = Player.job.onduty
    end
end)

-- Draw Blip -- 
local Location = vector3(1986.38, 3049.54, 47.22)
local Blip = AddBlipForCoord(Location)
SetBlipSprite(Blip, 93)
BeginTextCommandSetBlipName('Bar')

-- Clock On/Off -- 
RegisterNetEvent('cd_yellowjack:dutytoggle', function()
    if not DutyStatus then 
        TriggerServerEvent('QBCore:ToggleDuty')
    else 
        TriggerServerEvent('QBCore:ToggleDuty')
    end 
end)

target:AddBoxZone("dutytoggle", vector3(1981.39, 3051.11, 47.21), 1.5, 1.6, {
    name = "dutytoggle",
    heading = 151.81,
    debugPoly = false, 
    minZ = 47.00,
    maxZ = 48.00,
}, {
    options = {
        {
            type = "client",
            event = "cd_yellowjack:dutytoggle",
            icon = "fas fa-sign-in alt",
            label = "Clock On/Off",
            job = 'yellowjack',
        }
    },
    distance = 1.0,
})

-- Clear All Peds -- 
CreateThread(function()
    while true do
        
        -- Wait 30 Seconds -- 
        Wait(30000)

        -- Clear Peds -- 
        ClearAreaOfPeds(Location.x, Location.y, Location.z, 1000.0, 1)

    end 
end)

-- Bar Fridge -- 
-- Targets -- 

-- Food Section -- 
-- Targets --

-- UI (Invoicing) Section --
RegisterNetEvent('cd_yellowjack:useui', function()
    if not uiopen then
        SendNUIMessage({
            type = "openui"
        })
        uiopen = true
        SetNuiFocus(true, true)
    else
        SendNUIMessage({
            type = "closeui"
        })
        uiopen = false
    end
end)

RegisterNuiCallback('cancelbtn', function(_, cb)
    cb({})

    SetNuiFocus(false, false)
end)

target:AddBoxZone('ui', vector3(1982.32, 3053.33, 47.22), 1.5, 1.6, {
    name = "ui",
    heading = 62.94,
    debugPoly = false, 
    minZ = 47.00,
    maxZ = 48.00,
}, {
    options = {
        {
            type = "client",
            event = "cd_yellowjack:useui",
            icon = "fas fa-money-bill",
            label = "Set Invoice",
            --job = "yellowjack",
        }
    },
    distance = 1.0,
})