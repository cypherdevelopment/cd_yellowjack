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
