

ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
  ESX.PlayerLoaded = false
end)




function GetFirstSecondDoor(k)
    local handle, entity = FindFirstObject()
    local success
    repeat
        local pos = GetEntityCoords(entity)
        if GetEntityModel(entity) == k.double_door_model  and entity ~= Door and Vdist(pos.x, pos.y, pos.z, k.coords.x, k.coords.y, k.coords.z) < 100.0 then
            return entity
        end
        success, entity = FindNextObject(handle)
    until not success
    EndFindObject(handle)
end

-- SETSTATE PER TUTTI I PLAYER

function SetDoorStateSynchedPlayer(door, state)
    TriggerServerEvent("CS_KeyPad:SERVER:SetDoorStateSynchedPlayer", door, state)
end

RegisterNetEvent("CS_KeyPad:CLIENT:SetDoorStateSynchedPlayer")
AddEventHandler("CS_KeyPad:CLIENT:SetDoorStateSynchedPlayer", function (door, state)
    DoorSystemSetDoorState(door, state, false, false)
end)


-- UTILS -- TOOL

function RoundCoords(coords)
    local x = math.floor(coords.x + 0.5)
    local y = math.floor(coords.y + 0.5)
    local z = math.floor(coords.z + 0.5)
    return vector3(x, y, z)
end

function HashCoords(coords)
    local roundedCoords = RoundCoords(coords)
    return string.format("%d_%d_%d", roundedCoords.x, roundedCoords.y, roundedCoords.z)
end

-- ONINTERACT --
local isjob = nil

function CICUS_KeyPadOnSelect(entity)
    if (not CurrentKeyPad and entity) or CurrentKeyPad then
        for _, a in pairs(CICUS_KeyPad.Main.Stations) do
            for b, k in pairs(a.Keypad) do
                local entityCoords = GetEntityCoords(CurrentKeyPad or entity)
                if CICUS.Utils.CompareVector3(entityCoords, k.coords, 0.5) then

                    if k.jobs then
                        local playerData = ESX.GetPlayerData()
                        local playerJob = playerData.job
                        isjob = false

                        for _, job in pairs(k.jobs) do
                            if playerJob.name == job.job and (not job.job_grade or playerJob.grade >= job.job_grade) then
                                isjob = true
                                break
                            end
                        end


                        StartSetup(CurrentKeyPad or entity, isjob)
                    else
                        StartSetup(CurrentKeyPad or entity, true)
                    end
                end
            end
        end
    end
end

-- KEYPAD START SETUP

function StartSetup(entity, state)
    StartAnim(entity, function (finish)
        if finish then
            if not state then ESX.ShowNotification("Non il lavoro necessario", 1000, "error") return end
            Success(entity)
        end
    end)
end

-- KEYPAD ANIMATIONS

function Success(entity)
    local prop_coords = GetEntityCoords(entity)
    SetDoor(0, prop_coords)
    Wait(CICUS_KeyPad.Main.Maintimeclose)
    SetDoor(1, prop_coords)
end

function SetDoor(type, coords)
    for n, m in pairs(Keypads) do
        if CICUS.Utils.CompareVector3(coords, m.coords, 5) then
            if Keypads[n].double_door then
                SetDoorStateSynchedPlayer(n .. "_second", type)
                Doors[n .. "_second"] = type
            end
            SetDoorStateSynchedPlayer(n, type)
            Doors[n] = type
        end
    end
end


