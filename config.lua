CICUS = {} -- Tabella principale

-- In questo script sara possibile chiudere una porta tramite keypad 
-- NOTA: Le porte devono essere già presenti nelle mappe o essere spawnate prima 
-- NOTA: Per ottenere le coordinate di una porta, utilizza la mod: dolu_tool https://github.com/dolutattoo/dolu_tool

CICUS.Main = {
    Maintimeclose = 5000, -- Tempo di chiusura predefinito della porta

    Stations = {
        ["police_station"] = { -- Nome della stazione di polizia
            Job = "lspd", -- Lavoro associato alla stazione di polizia
            Doors = { -- Lista delle porte della stazione di polizia
                {
                    name = "police1", -- Nome della porta
                    door_model = -1197461458, -- Modello della porta
                    door_coords = vector3(-296.2513, -1052.724, 28.41679), -- Coordinate della porta
                    lock = true, -- Stato predefinito della porta (chiusa)
                    duoble_door = false, -- Flag per porte doppie (non specificato nel codice fornito)

                    -- Lista dei tastierini associati a questa porta
                    keypads = {
                        {
                            already_present = true, -- Flag se il tastierino è già presente
                            change_position = true, -- Flag per cambiare la posizione del tastierino già esistente

                            oldcoords = vector3(-294.8377, -1053.306, 28.62844), -- Vecchie coordinate del tastierino
                            coords = vector3(-294.8377, -1053.306, 28.93844), -- Nuove coordinate del tastierino

                            animation = vector3(-294.8377 - 0.2, -1053.306 - 0.3, 28.62844 - 0.3), -- Animazione del tastierino
                        },
                        {
                            already_present = false, -- Flag se il tastierino deve essere spawnato
                            change_position = false, -- Flag per cambiare la posizione del tastierino spawnato

                            coords = vector3(-296.345, -1051.818, 28.82844), -- Coordinate del nuovo tastierino da spawnare
                            spaw_position = {-296.345, -1051.818, 28.82844, 68.374}, -- Posizione di spawn del nuovo tastierino

                            animation = vector3(-296.345 + 0.3, -1051.818 - 0.2, 28.62844 - 0.3) -- Animazione del nuovo tastierino
                        }
                    },
                },
                -- Puoi aggiungere altre porte e tastierini qui...
            },
        },
        -- Puoi aggiungere altre stazioni di polizia con porte qui...
    }
}