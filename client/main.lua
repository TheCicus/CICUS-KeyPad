---@diagnostic disable: param-type-mismatch, missing-parameter

CICUS = exports.cicus_lib:CICUS()

-- VARIABILI
Keypads = {}
Doors = {}
KeypadModel = GetHashKey("prop_ld_keypad_01b")



-- SPAWN KEYPAD

Citizen.CreateThread(function ()
    while true do
        Wait(500)
        for j, u in pairs(Doors) do
            SetDoorStateSynchedPlayer(j, u)
        end

        for _, a in pairs(CICUS_KeyPad.Main.Stations) do
            for _, k in pairs(a.Keypad) do
                if k.change_position then
                    newprops = GetClosestObjectOfType(k.oldcoords, 10.0, KeypadModel, false, false, false)
                    SetEntityHeading(newprops, GetEntityHeading(newprops))
                    SetEntityCoords(newprops, k.coords)
                end
            end
        end
    end
end)

for _, a in pairs(CICUS_KeyPad.Main.Stations) do
        for b, k in pairs(a.Keypad) do
        
            if not k.already_present then
                CICUS.Utils.RequestModel(KeypadModel)
                KeyPad = CreateObjectNoOffset(KeypadModel, k.coords.x, k.coords.y,  k.coords.z, true, false, false)
                SetEntityRotation(KeyPad, k.rot.x, k.rot.y, k.rot.z, 2, true)                
            end
    
            Door = GetClosestObjectOfType(k.coords.x, k.coords.y,  k.coords.z, 100.0, k.door_model, false, false, false)
    
            if k.duoble_door then
                Keypads[b] = {
                    coords = k.coords,
                    double_door = true,
                    door_model = k.door_model
                }
            
                local second_door = GetFirstSecondDoor(k)
                AddDoorToSystem(b .. "_second", GetEntityModel(second_door), GetEntityCoords(second_door), false, false, false)
                SetDoorStateSynchedPlayer(b .. "_second", 4)
                Doors[b .. "_second"] = 4
               
            else Keypads[b] = {coords = k.coords, double_door = false} end
    
            AddDoorToSystem(b, GetEntityModel(Door), GetEntityCoords(Door), false, false, false)
            SetDoorStateSynchedPlayer(b, 4)
            Doors[b] = 4
    
        end
end    

AddEventHandler("onResourceStop", function ()
    DeleteObject(KeyPad)
end)



-- CICLO PRINCIPALE --

local notified = false
CurrentKeyPad = nil

Citizen.CreateThread(function ()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())
        local keypad = GetClosestObjectOfType(playerCoords, 1.0, KeypadModel, false, false, false)
        local keypadCoords = GetEntityCoords(keypad)
        local pedCoords = GetEntityCoords(PlayerPedId())
        local hash = HashCoords(keypadCoords)

        local v = KeypadsHash[hash]
        if v and CICUS.Utils.CompareVector3(v.coords, keypadCoords, 5) and Vdist2(pedCoords.x, pedCoords.y, pedCoords.z, keypadCoords.x, keypadCoords.y, keypadCoords.z) < 0.7 then
            CurrentKeyPad = keypad
            if not CICUS_KeyPad.Main.Using_ox_target then 
                
                CICUS.lib.KeyPress('interact', function()
                    ClearAllHelpMessages()
                    notified = true
                    CICUS_KeyPadOnSelect()
                end)

                if not notified then
                    notified = true  
                    CICUS_KeyPad.Main.Custom_Notify()
                end
            end
        else
            notified = false
            CurrentKeyPad = nil
            ClearHelp(true)
        end

        Wait(500)
    end
end)

KeypadsHash = {}
for _, v in pairs(Keypads) do
    local hash = HashCoords(v.coords)
    KeypadsHash[hash] = v
end








