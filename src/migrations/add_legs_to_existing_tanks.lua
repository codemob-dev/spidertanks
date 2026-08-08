local modify_tank_legs = require("modify_tank_legs")

for _, surface in pairs(game.surfaces) do
    for _, entity in ipairs(surface.find_entities_filtered{name = "tank"}) do
        modify_tank_legs(entity.grid, "tank")
    end
    if script.active_mods["car-equipment"] then
        for _, entity in ipairs(surface.find_entities_filtered{name = "car"}) do
            modify_tank_legs(entity.grid, "car")
        end
    end
end