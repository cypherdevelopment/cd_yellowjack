local QBCore = exports['qb-core']:GetCoreObject()
local uiopen = false
local billingopen = false 
local target = exports['qb-target']
local Location = vector3(Config.yellowJackBlip.x, Config.yellowJackBlip.y, Config.yellowJackBlip.z)

-- Draw Blip -- 
function DrawBlip()
    AddTextEntry('BLIP', 'YellowJack Bar')
    local Blip = AddBlipForCoord(Location)
    SetBlipSprite(Blip, 93)
    BeginTextCommandSetBlipName('BLIP')
    EndTextCommandSetBlipName(Blip)
end


AddEventHandler('onResourceStart', function()
    DrawBlip()
end)

-- Duty Station --
target:AddBoxZone("dutytoggle", vector3(1981.39, 3051.11, 47.21), 1.5, 1.6, {
    name = "dutytoggle",
    heading = 151.81,
    debugPoly = false, 
    minZ = 47.00,
    maxZ = 48.00,
}, {
    options = {
        {
            type = "server",
            event = "QBCore:ToggleDuty",
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

-- UI (Invoicing) Section --
RegisterNuiCallback('sbmtbtn', function(data, cb)
    local name = data.name
    local id = data.id
    local amount = data.amount
    local desc = data.desc
    AddBill(id,amount,desc)
    --SendWebHook(name,amount,desc)
    uiopen = false
    cb({})
    SetNuiFocus(false, false)
end)
 

-- Close-UI Callback--
RegisterNuiCallback('closeui', function(data, cb)
    uiopen = false
    billingopen = false
    cb({})
    SetNuiFocus(false, false)
end)

RegisterNuiCallback('checkaccount', function(data, cb)
    local Player = QBCore.Functions.GetPlayerData()
    local enough
    if Player ~= nil then
        local money = Player.money.bank
        if money < data.cost then 
            enough = false
            QBCore.Functions.Notify('You do not have enough money', 'error', 2500)
        else
            enough = true
        end
        cb({enough})
    end
end)

RegisterNuiCallback('paybill', function(data, cb)
    local id = data.id 
    local price = data.price
    local desc = data.desc
    RemoveBill(id,price,desc)
    TriggerServerEvent('cd_yellowjack:ChargeBill', price)
end)

--Returns tab from database--
function GetTab()
    local Player = QBCore.Functions.GetPlayerData()
    local tab = nil
    --print(Player.citizenid)
    QBCore.Functions.TriggerCallback('cd_yellowjack:GetTab', function(cb)
        if cb == nil then 
            print('here')
        end 
        tab = cb   
    end,Player.citizenid)
    while tab == nil do 
        Citizen.Wait(1)
    end
    return tab
end


-- UI Target --
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

-- target:AddGlobalPlayer(
--     parameters = {
--     options = {
--       {
--         type: string,
--         event: string,
--         icon: string,
--         label: string,
--         targeticon: string,
--         item: string,
--         action: function,
--         canInteract: function,
--         job: string or table,
--         gang: string or table
--       }
--     },
--     distance: float
--   })

-- Webhook System --
function SendWebHook(name, amount, desc)
    TriggerServerEvent('cd_yellowjack:SendWebHook',name,amount,desc)
end 

-- Billing System --
function AddBill(id,amount,desc) 
    TriggerServerEvent('cd_yellowjack:AddBill',id,amount,desc)
    Citizen.Wait(50)
end

function RemoveBill(id,amount,desc) 
    TriggerServerEvent('cd_yellowjack:RemoveBill',id,amount,desc)
end

RegisterCommand('OpenBarTab',function()
    if not billingopen then
        local tab = GetTab()
        SendNUIMessage({
            type = "openbilling",
            bills = tab
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