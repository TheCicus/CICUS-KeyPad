
CICUS_KeyPad = {} 

CICUS_KeyPad.Main = {
    Maintimeclose = 5000, 
    Stations = {
        ["police_station"] = {
            Keypad = {
                --["keypad_04"] = {

                    -- ESEMPIO --

                    -- Se il keypad e gia esistente 
                    -- change_position = true, -- Se vuoi cambiare le cordinate
                    -- old_coords = vector3(), -- Vecchie Cordinate

                    -- coords = vector3(449.89492797852, -985.49200439453, 31.300926208496), -- Cordinate del keypad
                    --  rot = vector3(0.000, 0.000, -89.716), -- Rotazione del keypad
                    -- door_model = 1557126584, modello della porta
                    -- jobs = {{job = "police", job_grade = 3}, {job = "ambulance", job_grade = 1}}  -- Jobs che possono accedere con grado
                    -- double_door_model = "" -- Se ce la secoda porta metti il modello
                --},

                ["keypad_05"] = {
                    coords = vector3(442.448, -991.765,  31.300926208496),
                    rot = vector3(0.000, 0.000, 31.283),
                    door_model = -131296141,
                    duoble_door = true,
                    double_door_model = -131296141,
                    jobs = {{job = "police"}, {job = "ambulance", job_grade = 3}}
                },
            }
        }
    },

    Custom_Notify = function () -- Notifica di quando sei vicino. Se non usi ox_target
        AddTextEntry("CICUS_KeyPad_ALERT", "Premi ~INPUT_CONTEXT~ per aprire la porta")
        BeginTextCommandDisplayHelp("CICUS_KeyPad_ALERT")
        EndTextCommandDisplayHelp(0, true, true, -1)
    end,

    Using_ox_target = false, -- OX_target ?
}


-- SE USI OX TARGET SETTALO QUI:
Wait(1000)
if CICUS_KeyPad.Main.Using_ox_target then
    exports.ox_target:addModel(GetHashKey("prop_ld_keypad_01b"), {
        {
            name = 'ox:option0',
            icon = 'fa-solid fa-lock',
            label = 'Sblocca porta',
            distance = 2,
            onSelect = function(data)
                CICUS_KeyPadOnSelect(data.entity)
            end,
        },
     })
    
end
