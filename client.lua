local QBCore = exports['qb-core']:GetCoreObject()
local Config = Config or {}
local hasVoted = {}

local function openVotingMenu()
    local playerId = QBCore.Functions.GetPlayerData().citizenid
    if hasVoted[playerId] then
        QBCore.Functions.Notify("You have already voted.", "error")
        return
    end

    if Config.MenuLibrary == 'ox_lib' then
        lib.showContext('voting_menu')
    else
        exports['qb-menu']:openMenu({
            {
                header = 'Vote for your Favorite',
                isMenuHeader = true
            },
            {
                header = 'Person 1',
                txt = 'Vote for Person 1',
                params = {
                    event = 'qb-vote:client:vote',
                    args = 'person1'
                }
            },
            {
                header = 'Person 2',
                txt = 'Vote for Person 2',
                params = {
                    event = 'qb-vote:client:vote',
                    args = 'person2'
                }
            }
        })
    end
end

local function openCheckVotesMenu(person1Count, person2Count)
    if Config.MenuLibrary == 'ox_lib' then
        lib.registerContext({
            id = 'check_votes_menu',
            title = 'Current Vote Counts',
            options = {
                {
                    title = 'Person 1: ' .. person1Count,
                    icon = 'fas fa-user',
                    disabled = true
                },
                {
                    title = 'Person 2: ' .. person2Count,
                    icon = 'fas fa-user',
                    disabled = true
                }
            }
        })
        lib.showContext('check_votes_menu')
    else
        exports['qb-menu']:openMenu({
            {
                header = 'Current Vote Counts',
                isMenuHeader = true
            },
            {
                header = 'Person 1: ' .. person1Count,
                isMenuHeader = true
            },
            {
                header = 'Person 2: ' .. person2Count,
                isMenuHeader = true
            }
        })
    end
end

if Config.MenuLibrary == 'ox_lib' then
    lib.registerContext({
        id = 'voting_menu',
        title = 'Vote for your Favorite',
        options = {
            {
                title = 'Person 1',
                icon = 'fas fa-user',
                event = 'qb-vote:client:vote',
                args = { option = 'person1' }
            },
            {
                title = 'Person 2',
                icon = 'fas fa-user',
                event = 'qb-vote:client:vote',
                args = { option = 'person2' }
            }
        }
    })
end

RegisterNetEvent('qb-vote:client:vote', function(data)
    local playerId = QBCore.Functions.GetPlayerData().citizenid
    if hasVoted[playerId] then
        QBCore.Functions.Notify("You have already voted.", "error")
        return
    end

    local option = data.option
    hasVoted[playerId] = true
    TriggerServerEvent('qb-vote:server:vote', option)
end)

RegisterNetEvent('qb-vote:client:updateVoteCounts', function(person1Count, person2Count)
    openCheckVotesMenu(person1Count, person2Count)
end)

local function setupTarget()
    if Config.TargetLibrary == 'ox_target' then
        -- Voting location
        exports.ox_target:addBoxZone({
            coords = Config.VotingLocation,
            size = vec3(1, 1, 1),
            rotation = 0,
            debug = false,
            options = {
                {
                    event = "qb-vote:client:openMenu",
                    icon = "fas fa-user",
                    label = "Vote for your Favorite",
                },
            },
            distance = 2.0
        })

        exports.ox_target:addBoxZone({
            coords = Config.CheckVotesLocation,
            size = vec3(1, 1, 1),
            rotation = 0,
            debug = false,
            options = {
                {
                    event = "qb-vote:client:checkVotes",
                    icon = "fas fa-chart-bar",
                    label = "Check Vote Counts",
                },
            },
            distance = 2.0
        })
    else

        exports['qb-target']:AddBoxZone("voting_zone", Config.VotingLocation, 1, 1, {
            name = "voting_zone",
            heading = 0,
            debugPoly = false,
            minZ = Config.VotingLocation.z - 1,
            maxZ = Config.VotingLocation.z + 1,
        }, {
            options = {
                {
                    type = "client",
                    event = "qb-vote:client:openMenu",
                    icon = "fas fa-user",
                    label = "Vote for your Favorite",
                },
            },
            distance = 2.0
        })


        exports['qb-target']:AddBoxZone("check_votes_zone", Config.CheckVotesLocation, 1, 1, {
            name = "check_votes_zone",
            heading = 0,
            debugPoly = false,
            minZ = Config.CheckVotesLocation.z - 1,
            maxZ = Config.CheckVotesLocation.z + 1,
        }, {
            options = {
                {
                    type = "client",
                    event = "qb-vote:client:checkVotes",
                    icon = "fas fa-chart-bar",
                    label = "Check Vote Counts",
                },
            },
            distance = 2.0
        })
    end
end

RegisterNetEvent('qb-vote:client:openMenu', function()
    openVotingMenu()
end)

RegisterNetEvent('qb-vote:client:checkVotes', function()
    TriggerServerEvent('qb-vote:server:requestVoteCounts')
end)

CreateThread(function()
    setupTarget()
end)
