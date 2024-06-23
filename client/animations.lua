---@diagnostic disable: param-type-mismatch, missing-parameter

function StartAnim(entity, callback)
    local keypadAnimDict = "anim@heists@keypad@"

    -- LOAD ANIMATION
    CICUS.Utils.RequestAnim(keypadAnimDict)

    -- POS E HEANDING
    local playerPed = PlayerPedId()
    local sceneRotation = vector3(0.0, 0.0, GetEntityHeading(entity))
    local offsetX = -0.05
    local offsetY = -0.35
    local pos = GetOffsetFromEntityInWorldCoords(entity, offsetX, offsetY, -0.60)

    -- CREATE SCENE
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

    -- START
    NetworkAddPedToSynchronisedScene(playerPed, scene, keypadAnimDict, "enter", 8.0, -8.0, 0, 0, 1000.0, 0)
    NetworkStartSynchronisedScene(scene)
    StartAudioScene(scene)

    -- LOOP
    scene = NetworkCreateSynchronisedScene(pos.x, pos.y, pos.z, sceneRotation.x, sceneRotation.y, sceneRotation.z, 2, true, true, 1.0, 0.0, 1.0)
    NetworkAddPedToSynchronisedScene(playerPed, scene, keypadAnimDict, "idle_a", 8.0, -8.0, 0, 0, 1000.0, 0)
    NetworkStartSynchronisedScene(scene)
    local audio = StartAudioScene(scene)
    SetAudioSceneVariable(audio, "volume", 2.0)
    
    -- SOUND
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
    
    -- FINISH
    scene = NetworkCreateSynchronisedScene( pos.x, pos.y, pos.z, sceneRotation.x, sceneRotation.y, sceneRotation.z, 2, true, true, 1.0, 0.0, 1.0)
    NetworkAddPedToSynchronisedScene(playerPed, scene, keypadAnimDict, "exit", 8.0, -8.0, 0, 0, 1000.0, 0)
    NetworkStartSynchronisedScene(scene)
    local audio = StartAudioScene(scene)
    SetAudioSceneVariable(audio, "volume", 2.0)

    Wait(1500)

    ClearPedTasksImmediately(playerPed)
    ClearPedTasks(playerPed)

    if callback then callback(true) end
end

