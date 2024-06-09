ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent("open:door:server")
AddEventHandler("open:door:server", function (door, state)
    local players = ESX.GetPlayers()
    for _, player in pairs(players) do
        TriggerClientEvent("set:door", player, door, state)
    end
end)