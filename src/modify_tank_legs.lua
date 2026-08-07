local function transfer_inventory(old_tank, new_tank, tank_inventory, spider_inventory)
    local old_inventory
    if old_tank.name == "tank" then
        old_inventory = old_tank.get_inventory(tank_inventory)
    else
        old_inventory = old_tank.get_inventory(spider_inventory)
    end
    
    local new_inventory
    if new_tank.name == "tank" then
        new_inventory = new_tank.get_inventory(tank_inventory)
    else
        new_inventory = new_tank.get_inventory(spider_inventory)
    end
    new_inventory.transfer_from_inventory(old_inventory)

    if old_inventory.is_filtered() and new_inventory.supports_filters() then
        for i = 1, #old_inventory do
            new_inventory.set_filter(i, old_inventory.get_filter(i))
        end
    end
end

local function modify_tank_legs(grid)
    local old_tank = grid.entity_owner
    if old_tank == nil then
        return
    end
    if old_tank.name:sub(1, #"tank") ~= "tank" then
        return
    end
    if currently_modified_tanks[old_tank.unit_number] ~= nil then
        return
    end
    local target_num = 0
    for _, equipment in ipairs(grid.get_contents()) do
        if equipment.name == "exoskeleton-equipment" then
            target_num = target_num + equipment.count * 2
        end
    end
    local target_entity_name
    if target_num == 0 then
        target_entity_name = "tank"
    else
        target_entity_name = "tank-" .. target_num
    end
    local new_tank = old_tank.surface.create_entity{
        name = target_entity_name,
        position = old_tank.position,
        direction = old_tank.direction,
        quality = old_tank.quality,
        force = old_tank.force,
    }
    if target_num ~= 0 then
        new_tank.torso_orientation = old_tank.direction
    end

    new_tank.copy_settings(old_tank)

    if (target_num == 0 or old_tank.name == "tank") and not (target_num == 0 and old_tank.name == "tank") then
        local old_logistic_sections = old_tank.get_logistic_sections()
        local new_logistic_sections = new_tank.get_logistic_sections()
        new_logistic_sections.remove_section(1)
        for _, old_section in ipairs(old_logistic_sections.sections) do
            local new_section = new_logistic_sections.add_section(old_section.group)
            new_section.filters = old_section.filters
            new_section.active = old_section.active
            new_section.multiplier = old_section.multiplier
        end
    end

    currently_modified_tanks[new_tank.unit_number] = true
    for _, equipment in ipairs(old_tank.grid.equipment) do
        new_tank.grid.put{
            name = equipment.name,
            quality = equipment.quality,
            position = equipment.position,
        }
    end
    currently_modified_tanks[new_tank.unit_number] = nil
    new_tank.set_driver(old_tank.get_driver())
    new_tank.set_passenger(old_tank.get_passenger())

    transfer_inventory(old_tank, new_tank, defines.inventory.car_trunk, defines.inventory.spider_trunk)
    transfer_inventory(old_tank, new_tank, defines.inventory.car_ammo, defines.inventory.spider_ammo)
    transfer_inventory(old_tank, new_tank, defines.inventory.car_trash, defines.inventory.spider_trash)
    transfer_inventory(old_tank, new_tank, defines.inventory.fuel, defines.inventory.fuel)

    new_tank.health = old_tank.health

    if target_num == 0 then
        new_tank.speed = old_tank.speed
    end

    for _, player in pairs(game.players) do
        if player.opened == old_tank then
            if player.opened_gui_type == defines.gui_type.opened_entity_grid then
                player.opened = new_tank
                player.opened = new_tank.grid
            else
                player.opened = new_tank
            end
        end
    end
    old_tank.destroy()
end

return modify_tank_legs