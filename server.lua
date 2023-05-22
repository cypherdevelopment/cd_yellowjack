local QBCore = exports['qb-core']:GetCoreObject()

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

RegisterServerEvent('cd_yellowjack:RemoveBill')
AddEventHandler('cd_yellowjack:RemoveBill', function(id,amount,desc)
    MySQL.Query(
        'DELETE FROM `barbills` WHERE @name,@amount,@desc',
        {
            ['@name'] = id,
            ['@amount'] = amount,
            ['@desc'] = desc
        },
        function(result)
    end)
end)

-- Webhook System -- 

-- Function -- 
-- function chatMessage(author, text)
--     url = "https://discord.com/api/webhooks/1109976260219768964/gvo2OWSj37v40ty21MyLyZlrL7SPk0SEe6Z6qBRLmSJ2Duc_EL7mm0scp5Bf0rxIH-e7"

--     local embeds = {
--         {
--             ["title"] = text,
--             ["type"] = "rich",
--             ["color"] = 14177041,
--             ["footer"] = {
--                 ["text"] = "YellowJack"
--             }
--         }
--     }

--     PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({username = author, embeds = embeds}), { ['Content-Type'] = 'application/json'})
-- end

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
