local modify_tank_legs = require("modify_tank_legs")

for _, surface in pairs(game.surfaces) do
    for _, entity in ipairs(surface.find_entities_filtered{name = "tank"}) do
        modify_tank_legs(entity.grid)
    end
end