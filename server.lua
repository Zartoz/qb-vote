local QBCore = exports['qb-core']:GetCoreObject()

local voteCounts = {
    person1 = 0,
    person2 = 0
}

CreateThread(function()
    exports.oxmysql:fetch('SELECT `option`, COUNT(*) as count FROM votes GROUP BY `option`', {}, function(result)
        for _, row in ipairs(result) do
            if row.option == 'person1' then
                voteCounts.person1 = row.count
            elseif row.option == 'person2' then
                voteCounts.person2 = row.count
            end
        end
    end)
end)

RegisterServerEvent('qb-vote:server:vote')
AddEventHandler('qb-vote:server:vote', function(option)
    local src = source
    local playerId = QBCore.Functions.GetPlayer(src).PlayerData.citizenid

    exports.oxmysql:fetch('SELECT * FROM votes WHERE citizenid = ?', {playerId}, function(result)
        if #result > 0 then
            TriggerClientEvent('QBCore:Notify', src, 'You have already voted!', 'error')
        else
            exports.oxmysql:insert('INSERT INTO votes (citizenid, option) VALUES (?, ?)', {playerId, option}, function()
                if voteCounts[option] then
                    voteCounts[option] = voteCounts[option] + 1
                    TriggerClientEvent('QBCore:Notify', src, 'You voted for ' .. option .. '!')
                    TriggerClientEvent('qb-vote:client:updateVoteCounts', -1, voteCounts.person1, voteCounts.person2)
                else
                    TriggerClientEvent('QBCore:Notify', src, 'Invalid vote!', 'error')
                end
            end)
        end
    end)
end)

RegisterServerEvent('qb-vote:server:requestVoteCounts')
AddEventHandler('qb-vote:server:requestVoteCounts', function()
    local src = source
    TriggerClientEvent('qb-vote:client:updateVoteCounts', src, voteCounts.person1, voteCounts.person2)
end)

QBCore.Commands.Add('showvotes', 'Show the current vote counts', {}, false, function(source)
    local src = source
    TriggerClientEvent('QBCore:Notify', src, string.format('Person 1: %d | Person 2: %d', voteCounts.person1, voteCounts.person2))
end)
