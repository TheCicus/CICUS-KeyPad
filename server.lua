ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent("CS_KeyPad:SERVER:SetDoorStateSynchedPlayer")
AddEventHandler("CS_KeyPad:SERVER:SetDoorStateSynchedPlayer", function (door, state)
    local players = ESX.GetPlayers()
    for _, player in pairs(players) do
        TriggerClientEvent("CS_KeyPad:CLIENT:SetDoorStateSynchedPlayer", player, door, state)
    end
end)


