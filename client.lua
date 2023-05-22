local QBCore = exports['qb-core']:GetCoreObject()
local uiopen = false 
local target = exports['qb-target']

-- Check Duty Status every 30 seconds --
CreateThread(function()
    while true do 

        -- Wait 30 Seconds --
        Wait(60000)

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
        TriggerServerEvent('QBCore:ToggleDuty')
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
--vector4(1981.75, 3052.28, 47.22, 55.32)--

-- Food Section -- 
-- Targets --
--vector4(1984.18, 3049.84, 47.22, 323.95)--

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

RegisterNuiCallback('sbmtbtn', function(data, cb)
    --local Player = QBCore.Functions.GetPlayerData()
    name = data.name
    id = data.id
    amount = data.amount
    desc = data.desc
    print(name,id,amount,desc)
    AddBill(id,amount,desc)
    uiopen = false
    cb({})
    SetNuiFocus(false, false)
end)

function AddBill(id,amount,desc) 
    TriggerServerEvent('cd_yellowjack:AddBill',id,amount,desc)
    Citizen.Wait(50)
end

function RemoveBill(id,amount,desc) 
    TriggerServerEvent('cd_yellowjack:RemoveBill',id,amount,desc)
end

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
            job = "yellowjack",
        }
    },
    distance = 1.0,
})