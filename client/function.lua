-- Variabili 
local keypadAnimDict = "anim@heists@keypad@" 


-- Funzione per confrontare i vectior
function AreCoordsCloseEnough(coords1, coords2, tolerance)
    local dx = coords1.x - coords2.x
    local dy = coords1.y - coords2.y
    local dz = coords1.z - coords2.z
    return (dx * dx + dy * dy + dz * dz) <= (tolerance * tolerance)
end

