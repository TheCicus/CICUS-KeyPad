---@diagnostic disable: param-type-mismatch, trailing-space, missing-parameter, lowercase-global
local doors = {}
local doors_changeposition = {}
local keypadModel = -1235090659 
local keypadAnimDict = "anim@heists@keypad@"  -- Dizionario delle animazioni del tastierino
local keypads = {}


ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
  ESX.PlayerLoaded = false
end)





Citizen.CreateThread(function ()
    while true do
        Wait(0)
        for _, a in pairs(CICUS.Main.Stations) do
            for _, k in pairs(a.Doors) do
                if k.keypads then
                    for _, c in pairs(k.keypads) do
                        if c.change_position then
                            newprops = GetClosestProp(c.oldcoords)
                            SetEntityHeading(newprops, GetEntityHeading(newprops))
                            SetEntityCoords(newprops, c.coords)

                        end
                    
                    end
                else
                    return
                end
              
            end
        end
      
    end
    
end)


Citizen.CreateThread(function ()
    for _, a in pairs(CICUS.Main.Stations) do
        for _, k in pairs(a.Doors) do
            -- Create a keypad 
            job = k.job

            -- Spawn keypad non esistenti
            if k.keypads then
                for _, c in pairs(k.keypads) do
                    
                        if not c.already_present then
                            loadModel(keypadModel)
                            keyPad = CreateObject(keypadModel, c.spaw_position[1], c.spaw_position[2], c.spaw_position[3], true, false, false)
                            SetEntityRotation(keyPad, 0.0, 0.0, c.spaw_position[4], 2, true)                
                        end

                        table.insert(keypads, {
                            coords = c.coords
                        })
                    
                end
            else
                return
            end
            
            --
        
            -- Door main

            AddDoorToSystem(k.name, k.door_model, k.door_coords, false, 
            false, false )

            if k.double then
                local doubleDoor = nil
                for _, z in pairs(CICUS.Main.Stations) do
                    for _, d in pairs(z.Doors) do
                        if d.name == k.name_double then
                            doubleDoor = d
                            break
                        end
                    end
                end

                if doubleDoor then
                    if k.lock and doubleDoor.lock then
                        TriggerServerEvent("open:door:server", k.name, 4)
                        TriggerServerEvent("open:door:server", doubleDoor.name, 4)
                        doors[k.name] = true
                        doors[doubleDoor.name] = true
                    elseif not k.lock and not doubleDoor.lock then
                        TriggerServerEvent("open:door:server", k.name, 0)
                        TriggerServerEvent("open:door:server", doubleDoor.name, 0)
                        doors[k.name] = false
                        doors[doubleDoor.name] = false
                    end
                end
            else
                TriggerServerEvent("open:door:server", k.name, 4)
                doors[k.name] = k.lock
            end
        end
    end

    for _, keypad in pairs(keypads) do
        exports.ox_target:addModel(-1235090659, {
            {
                name = 'ox:option0',
                icon = 'fa-solid fa-clipboard-list',
                label = 'Sblocca porta',
                distance = 2,
                onSelect = function(data)
                    for _, a in pairs(CICUS.Main.Stations) do
                        for _, k in pairs(a.Doors) do
                            for _, c in pairs(k.keypads) do
                                local entityCoords = GetEntityCoords(data.entity)
                                print(entityCoords, c.coords)
                                if AreCoordsCloseEnough(entityCoords, c.coords, 0.5) then
                                    SetupDoor(data.entity, a.Job, c.animation)
                                end
                            end
                        end
                    end
                end,

                canInteract = function(entity, distance, coords, name, bone)
                    local entityCoords = GetEntityCoords(entity)
                    local closeEnough = AreCoordsCloseEnough(entityCoords, keypad.coords, 0.5)
                    return closeEnough
                end
            },
        })
    end
    
end)

-- Funzione per confrontare le coordinate






function SetupDoor(entity, job, animationpos)
    StartAnim(entity, animationpos, function (finish)
        if finish then
            if ESX.GetPlayerData().job.name == job then
                Success(entity)
            else
                print("ss")
                Error(entity)
                PlaySoundFromEntity(
                    -1, 
                    "ERROR", 
                    PlayerPedId(), 
                    "HUD_LIQUOR_STORE_SOUNDSET", 
                    false, false
                )
            end
        end
    end)
    
end

function Success(entity)
    local model = GetHashKey("hei_prop_hei_keypad_02")
    local heading = GetEntityHeading(entity)
    local prop_coords = GetEntityCoords(entity)
    local newProp = CreateObject(model, prop_coords,  true, false, false)
    NetworkRegisterEntityAsNetworked(newProp)  
    SetEntityCoords(newProp, prop_coords.x, prop_coords.y - 0.007, prop_coords.z)
    SetEntityHeading(newProp, heading)
    SetDoor(true, prop_coords)

    Wait(5000)
    print("ccc")
    SetDoor(false, prop_coords)
    DeleteEntity(newProp)


end

function SetDoor(type, coords)
        local objCoords = coords

        for _, a in pairs(CICUS.Main.Stations) do
            for _, k in pairs(a.Doors) do
                local closestObj = GetClosestObjectOfType(objCoords, 1.0, k.door_model, false, false, false) -- Trova l'oggetto più vicino
                if closestObj then
                    local doorCoords = k.door_coords
                   

                    local objeCoords = GetEntityCoords(closestObj)
                    local distance = #(doorCoords - objeCoords)
                    local threshold = 1.0
                    if distance < threshold then
                        if k.door_model == GetEntityModel(closestObj) then
                            if type == true then
                                TriggerServerEvent("open:door:server", k.name, 0)
                                doors[k.name] = false
                            else 
                                TriggerServerEvent("open:door:server", k.name, 4)
                                doors[k.name] = true
                            end

                            if k.duoble_door then
                                local doubleDoor = nil
                                for _, z in pairs(CICUS.Main.Stations) do
                                    for _, d in pairs(z.Doors) do
                                        if d.name == k.name_double then
                                            doubleDoor = d
                                            break
                                        end
                                    end
                                end                
                                if doubleDoor then
                                    if doors[doubleDoor.name] == true then
                                        TriggerServerEvent("open:door:server",doubleDoor.name, 0)

                                        doors[doubleDoor.name] = false
                                    else 
                                        TriggerServerEvent("open:door:server", doubleDoor.name, 4)
                                        doors[doubleDoor.name] = true
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
end

function Error(entity)
    local model = GetHashKey("hei_prop_hei_keypad_01")
    local heading = GetEntityHeading(entity)
    local prop_coords = GetEntityCoords(entity)

    loadModel(model)
    local newProp = CreateObject(model, prop_coords,  true, false, false)
    NetworkRegisterEntityAsNetworked(newProp)  
    SetEntityCoords(newProp, prop_coords.x, prop_coords.y - 0.007, prop_coords.z)
    SetEntityHeading(newProp, heading)
    Wait(5000)
    DeleteEntity(newProp)
end

RegisterNetEvent("set:door")
AddEventHandler("set:door", function (door, state)
    DoorSystemSetDoorState(door, state, false, false)
end)

function StartAnim(entity, pos,  callback)

    -- LoadAnim
    RequestAnimDict(keypadAnimDict)
    while not HasAnimDictLoaded(keypadAnimDict) do
        Wait(500)
    end

    local playerPed = PlayerPedId()
    local x, y, z =  table.unpack(GetEntityCoords(entity))
    local sceneHeading = GetEntityHeading(entity)
    local sceneRotation = vector3(0.0, 0.0, sceneHeading)
    -- Scene

    -- Start 
    local scene = NetworkCreateSynchronisedScene(
        pos.x, 
        pos.y, 
        pos.z, 
        sceneRotation.x, 
        sceneRotation.y, 
        sceneRotation.z, 
        2, 
        true, 
        true, 
        1.0, 
        0.0, 
        1.0 
    )

    NetworkAddPedToSynchronisedScene(playerPed, scene, keypadAnimDict, "enter", 8.0, -8.0, 0, 0, 1000.0, 0)
    NetworkStartSynchronisedScene(scene)
    StartAudioScene(scene)

    scene = NetworkCreateSynchronisedScene(
        pos.x, 
        pos.y, 
        pos.z, 
        sceneRotation.x, 
        sceneRotation.y, 
        sceneRotation.z, 
        2, 
        true, 
        true, 
        1.0, 
        0.0, 
        1.0 
    )

    NetworkAddPedToSynchronisedScene(playerPed, scene, keypadAnimDict, "idle_a", 8.0, -8.0, 0, 0, 1000.0, 0)
    NetworkStartSynchronisedScene(scene)
    local audio = StartAudioScene(scene)
    SetAudioSceneVariable(audio, "volume", 2.0)
    
    Wait(300)
    PlaySoundFromEntity(
        -1, 
	    "ATM_WINDOW", 
	    PlayerPedId(), 
        "HUD_FRONTEND_DEFAULT_SOUNDSET", 
	    false, false
    )
    Wait(700)
    PlaySoundFromEntity(
        -1, 
	    "ATM_WINDOW", 
	    PlayerPedId(), 
        "HUD_FRONTEND_DEFAULT_SOUNDSET", 
	    false, false
    )
    Wait(700)
    PlaySoundFromEntity(
        -1, 
	    "ATM_WINDOW", 
	    PlayerPedId(), 
        "HUD_FRONTEND_DEFAULT_SOUNDSET", 
	    false, false
    )
    Wait(700)
    PlaySoundFromEntity(
        -1, 
	    "ATM_WINDOW", 
	    PlayerPedId(), 
        "HUD_FRONTEND_DEFAULT_SOUNDSET", 
	    false, false
    )
    
    scene = NetworkCreateSynchronisedScene(
        pos.x, 
        pos.y, 
        pos.z, 
        sceneRotation.x, 
        sceneRotation.y, 
        sceneRotation.z, 
        2, 
        true, 
        true, 
        1.0, 
        0.0, 
        1.0 
    )

    NetworkAddPedToSynchronisedScene(playerPed, scene, keypadAnimDict, "exit", 8.0, -8.0, 0, 0, 1000.0, 0)
    NetworkStartSynchronisedScene(scene)
    local audio = StartAudioScene(scene)
    SetAudioSceneVariable(audio, "volume", 2.0)
    Wait(1500)
    ClearPedTasksImmediately(playerPed)
    ClearPedTasks(playerPed)
    if callback then
        callback(true)
    end
end






function loadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(500)
    end
end

-- Funzione per caricare il dizionario delle animazioni del tastierino

-- NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, keypadAnimDict, "enter", 8.0, 8.0, 0, 0, 1000.0, 0)
-- NetworkStartSynchronisedScene(scene)
-- Wait(0)
-- local localScene = NetworkGetLocalSceneFromNetworkId(scene)
-- repeat Wait(0) until GetSynchronizedScenePhase(localScene) > 0.99
-- scene = NetworkCreateSynchronisedScene( -- Repeated code...
--     GetEntityCoords(KeyPad), -- FiveM unwraps this to X, Y, Z
--     GetEntityRotation(KeyPad), -- ^
--     2, -- Rotation Order
--     true, -- Hold last frame
--     false, -- Do not loop
--     1.0, -- p9
--     0.0, -- Starting phase (0.0 meaning we play it from the beginning)
--     1.0  -- animSpeed
-- )
-- NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, keypadAnimDict, "idle_a", 8.0, 8.0, 0, 0, 1000.0, 0)
-- NetworkStartSynchronisedScene(scene)
-- Wait(1000)
-- scene = NetworkCreateSynchronisedScene(
--         GetEntityCoords(KeyPad), GetEntityRotation(KeyPad),
--         2, false, false, 1.0, 0.0, 1.0
-- )
-- NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, keypadAnimDict, "exit", 8.0, 8.0, 0, 0, 1000.0, 0)
-- NetworkStartSynchronisedScene(scene)

function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(500)
    end
end

function GetClosestProp(coords)
    local playerPed = PlayerPedId()
    local closestProp = nil
    local closestDist = 1 
    local handle, object = FindFirstObject()
    local success

    repeat
        local objPos = GetEntityCoords(object)
        local distance = Vdist(coords - objPos)
        if distance < closestDist then
            closestDist = distance
            closestProp = object
        end
        success, object = FindNextObject(handle)
    until not success

    EndFindObject(handle)
    return closestProp
end











-- DOOR SYSTEM ---
-- for _, door in pairs(Config.Job.Door) do
--     -- Add all door system
--     AddDoorToSystem(door.name, door.model, door.coords)
--     -- Check double
--     if door.double then
--         -- doubleDoor Systyem
--         local doubleDoor = nil
--         for _, d in pairs(Config.Job.Door) do
--             if d.name == door.name_double then
--                 doubleDoor = d
--                 break
--             end
--         end
--         if doubleDoor then
--             if door.lock and doubleDoor.lock then
--                 DoorSystemSetDoorState(door.name, true)
--                 DoorSystemSetDoorState(doubleDoor.name, true)
--                 doors[door.name] = true
--                 doors[doubleDoor.name] = true
--             elseif not door.lock and not doubleDoor.lock then
--                 DoorSystemSetDoorState(door.name, false)
--                 DoorSystemSetDoorState(doubleDoor.name, false)
--                 doors[door.name] = false
--                 doors[doubleDoor.name] = false
--             end
--         end
--     else
--         -- Door no duble
--         DoorSystemSetDoorState(door.name, door.lock)
--         doors[door.name] = door.lock
--     end
-- end

-- -- Tastierio
-- AddEventHandler("Send:Tastierino:Open", function()
--     if playerJob then
--         local objCoords = GetEntityCoords(PlayerPedId()) 
--         for _, door in pairs(Config.Job.Door) do
--             local closestObj = GetClosestObjectOfType(objCoords, 1.0, door.model, false, false, false) -- Trova l'oggetto più vicino
--             if closestObj then
--                 local doorCoords = door.coords
--                 local objCoords = GetEntityCoords(closestObj)
--                 local distance = #(doorCoords - objCoords)
--                 local threshold = 1.0
--                 if distance < threshold then
--                     if door.model == GetEntityModel(closestObj) then
--                         if doors[door.name] == true then
--                             DoorSystemSetDoorState(door.name, false)
--                             doors[door.name] = false
--                         else 
--                             DoorSystemSetDoorState(door.name, true)
--                             doors[door.name] = true
--                         end

--                         -- Controlla se la porta è doppia e gestisci anche la porta doppia
--                         if door.double then
--                             local doubleDoor = nil
--                             for _, d in pairs(Config.Job.Door) do
--                                 if d.name == door.name_double then
--                                     doubleDoor = d
--                                     break
--                                 end
--                             end
--                             if doubleDoor then
--                                 if doors[doubleDoor.name] == true then
--                                     DoorSystemSetDoorState(doubleDoor.name, false)
--                                     doors[doubleDoor.name] = false
--                                 else 
--                                     DoorSystemSetDoorState(doubleDoor.name, true)
--                                     doors[doubleDoor.name] = true
--                                 end
--                             end
--                         end
--                     end
--                 end
--             end
--         end
--     else 
--         print("Non sei Polizziotto")
--     end
-- end)


