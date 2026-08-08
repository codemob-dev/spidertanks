currently_modified_tanks = {}

local modify_tank_legs = require("modify_tank_legs")

script.on_event(defines.events.on_equipment_inserted, function (event)
    modify_tank_legs(event.grid, "tank")
    if event.grid.valid and script.active_mods["car-equipment"] then
        modify_tank_legs(event.grid, "car")
    end
end)
script.on_event(defines.events.on_equipment_removed, function (event)
    modify_tank_legs(event.grid, "tank")
    if event.grid.valid and script.active_mods["car-equipment"] then
        modify_tank_legs(event.grid, "car")
    end
end)
script.on_event(defines.events.on_built_entity, function (event)
    modify_tank_legs(event.entity.grid, "tank")
    if event.entity.valid and script.active_mods["car-equipment"] then
        modify_tank_legs(event.entity.grid, "car")
    end
end, {{filter = "name", name = "tank"}})