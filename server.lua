QBCore = exports['qb-core']:GetCoreObject()

AddEventHandler('onResourceStart', function(resourceName)
    QBCore.Functions.AddJob('yellowjack', {
        label = 'YellowJack',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            ['0'] = {
                name = 'Freelancer',
                payment = 10
            }
        }
    })
end)

RegisterServerEvent('cd_yellowjack:AddBill')
AddEventHandler('cd_yellowjack:AddBill', function(id,amount,desc)
    MySQL.insert(
        'INSERT INTO barbills (citizenid, amount, description) VALUES (@name, @amount, @desc);',
        {
            ['@name'] = id,
            ['@amount'] = amount,
            ['@desc'] = desc
        },
        function(result)
    end)
end)

RegisterServerEvent('cd_yellowjack:ChargeBill')
AddEventHandler('cd_yellowjack:ChargeBill', function(price)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.RemoveMoney('bank',price,'Bar Bill.')
end)

RegisterServerEvent('cd_yellowjack:RemoveBill')
AddEventHandler('cd_yellowjack:RemoveBill', function(citizenid,amount,desc)
    print(citizenid,amount,desc)
    MySQL.query(
        'DELETE FROM barbills WHERE citizenid = @citizenid AND amount = @amount AND description = @description',
        {
            ['@citizenid'] = citizenid,
            ['@amount'] = amount,
            ['@description'] = desc
        },
        function(result)
    end)
end)

QBCore.Functions.CreateCallback('cd_yellowjack:GetTab', function(source, cb, id)
    MySQL.query(
        'SELECT citizenid,amount,description FROM barbills WHERE citizenid = @citizenid',
        {
            ['@citizenid'] = id
        },
        function(result)
            if result == nil then 
                print('nope')
            end
            
            cb(result)
        end)
end)

QBCore.Functions.CreateCallback('cd_yellowjack:GetBalance', function(source, cb)
    Player = QBCore.Functions.GetPlayer(source);

    if not Player then return end 

    Bank = QBCore.Functions.GetMoney('bank')
    Cash = QBCore.Functions.GetMoney('cash')
    Balance = Bank + Cash 
    cb(Balance)
end)


-- Webhook System -- 
RegisterServerEvent('cd_yellowjack:SendWebHook')
AddEventHandler('cd_yellowjack:SendWebHook', function(name, amount, desc)
    local embeds = {
        {
            ["title"] = "New Invoice!",
            ["description"] = "**Customer**: " .. name .. "\n**Amount**: " .. amount .. "\n**Description**: " .. desc,
            ["type"] = "rich",
            ["color"] = 16776960,
            ["footer"] = {
                ["text"] = "YellowJack Bar"
            },
        }
    }

    PerformHttpRequest(Config.WebhookURL, function(err, text, headers) end, 'POST', json.encode({username = "YellowJack Invoice System", embeds = embeds}), { ['Content-Type'] = 'application/json'})
end)

-- GiveItem System -- 
RegisterNetEvent('cd_yellowjack:GiveItem')
AddEventHandler('cd_yellowjack:GiveItem', function(Item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem(Item, 1)
end)
