currently_modified_tanks = {}

local modify_tank_legs = require("modify_tank_legs")

script.on_event(defines.events.on_equipment_inserted, function (event)
    modify_tank_legs(event.grid)
end)
script.on_event(defines.events.on_equipment_removed, function (event)
    modify_tank_legs(event.grid)
end)
script.on_event(defines.events.on_built_entity, function (event)
    modify_tank_legs(event.entity.grid)
end, {{filter = "name", name = "tank"}})