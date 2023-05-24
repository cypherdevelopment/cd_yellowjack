local QBCore = exports['qb-core']:GetCoreObject()
local uiopen = false
local billingopen = false 
local target = exports['qb-target']
local Location = vector3(1986.38, 3049.54, 47.22)

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

AddEventHandler('onResourceStart', function()

    DrawBlip()

end)

-- Draw Blip -- 
function DrawBlip()
    local Blip = AddBlipForCoord(Location)
    SetBlipSprite(Blip, 93)
    BeginTextCommandSetBlipName('Bar')
end


-- Clock On/Off -- 
RegisterNetEvent('cd_yellowjack:dutytoggle')
AddEventHandler('cd_yellowjack:dutytoggle', function()
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
target:AddBoxZone("barfridge", vector3(1981.75, 3052.28, 47.22), 1.5, 1.6, {
    name = "barfridge",
    heading = 55.32,
    debugPoly = false,
    minZ = 47.00,
    maxZ = 48.00,
}, {
    options = {
        {
            icon = "fa-solid fa-beer",
            label = "Alcohol: Beer",
            job = "yellowjack",
            action = function()
                TriggerServerEvent('cd_yellowjack:GiveItem', 'beer')
                QBCore.Functions.Notify('You grabbed a Beer!', primary, 5000)
            end 
        },
        {
            icon = "fa-solid fa-whiskey-glass",
            label = "Alcohol: Whiskey",
            job = "yellowjack",
            action = function()
                TriggerServerEvent('cd_yellowjack:GiveItem', 'whiskey')
                QBCore.Functions.Notify('You grabbed a Whiskey!', primary, 5000)
            end 
        },
        {
            icon = "fa-solid fa-martini-glass-citrus",
            label = "Alcohol: Vodka",
            job = "yellowjack",
            action = function()
                TriggerServerEvent('cd_yellowjack:GiveItem', 'vodka')
                QBCore.Functions.Notify('You grabbed a Vodka!', primary, 5000)
            end 
        },
        {
            icon = "fa-solid fa-wine-glass",
            label = "Alcohol: Wine",
            job = "yellowjack",
            action = function()
                TriggerServerEvent('cd_yellowjack:GiveItem', 'wine')
                QBCore.Functions.Notify('You grabbed a Wine!', primary, 5000)
            end 
        },
        {
            icon = "fa-solid fa-bottle-water",
            label = "Drink: Water",
            job = "yellowjack",
            action = function()
                TriggerServerEvent('cd_yellowjack:GiveItem', 'water_bottle')
                QBCore.Functions.Notify('You grabbed a Water!', primary, 5000)
            end 
        },
        {
            icon = "fa-solid fa-mug-hot",
            label = "Drink: Coffee",
            job = "yellowjack",
            action = function()
                TriggerServerEvent('cd_yellowjack:GiveItem', 'coffee')
                QBCore.Functions.Notify('You grabbed a Coffee!', primary, 5000)
            end 
        },
    },
    distance = 1.0,
})

-- Food Section -- 
-- Targets --
--vector4(1984.18, 3049.84, 47.22, 323.95)--

-- UI (Invoicing) Section --
RegisterNetEvent('cd_yellowjack:useui')
AddEventHandler('cd_yellowjack:useui', function()
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
    name = data.name
    id = data.id
    amount = data.amount
    desc = data.desc
    print(name,id,amount,desc)
    AddBill(id,amount,desc)
    SendWebHook(name,amount,desc)
    uiopen = false
    cb({})
    SetNuiFocus(false, false)
end)
RegisterNuiCallback('closeui', function(data, cb)
    billingopen = false
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

function GetTab()
    local Player = QBCore.Functions.GetPlayerData()
    QBCore.Functions.TriggerCallback('cd_yellowjack:GetTab', function(cb)
        if cb == nil then 
            print('here')
        end
            print(cb.citizenid,cb.amount)
    end,Player.citizenid)
end

-- Webhook System --
function SendWebHook(name, amount, desc)
    TriggerServerEvent('cd_yellowjack:SendWebHook',name,amount,desc)
end 



RegisterCommand('OpenBarTab',function()
    -- GetTab()
    if not billingopen then
        SendNUIMessage({
            type = "openbilling"
        })
        billingopen = true
        SetNuiFocus(true, true)
    else
        SendNUIMessage({
            type = "closebilling"
        })
        billingopen = false
        SetNuiFocus(false, false)
    end
end,false)

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