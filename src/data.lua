local function base_leg_index_for_angle(degrees)
    degrees = degrees % 360
    local offset = 33.22
    if degrees <= offset then return 3
    elseif degrees <= 90 then return 4
    elseif degrees <= 180 - offset then return 8
    elseif degrees <= 180 then return 7
    elseif degrees <= 180 + offset then return 6
    elseif degrees <= 270 then return 5
    elseif degrees <= 360 - offset then return 1
    else return 2
    end
end


local function generate_leg_at_position(mount_x, mount_y, index)
    local angle = math.deg(math.atan(mount_y, mount_x))
    local base_leg_index = base_leg_index_for_angle(angle)
    local ground_x = mount_x / 12
    local ground_y = mount_y / 24
    return {
        leg = "spidertron-leg-" .. base_leg_index,
        mount_position = util.by_pixel(mount_x, mount_y),
        ground_position = {ground_x, ground_y},
        walking_group = index%2 + 1
    }
end

local function generate_legs(leg_count)
    local legs = {}
    for i = 1, leg_count do
        local mount_x = -25.0
        if i > leg_count / 2 then
            mount_x = 25.0
        end
        local mount_y = 0
        if leg_count > 2 then
            local position = ((i - 1)%(leg_count/2))/(leg_count/2 - 1)
            mount_y = position * 60.0 - 30.0
        end
        table.insert(legs, generate_leg_at_position(mount_x, mount_y, i))
    end
    return legs
end

for i = 1,15 do
    local legged_tank = table.deepcopy(data.raw["car"]["tank"])
    local n = i * 2

    legged_tank.name = "tank-" .. n

    legged_tank.localised_name = {"entity-name.tank"}
    legged_tank.localised_description = {"entity-description.tank"}
    legged_tank.hidden = true
    legged_tank.type = "spider-vehicle"
    legged_tank.height = 1
    legged_tank.graphics_set = {
        light = legged_tank.light,
        base_animation = legged_tank.animation,
        animation = legged_tank.turret_animation,
    }
    legged_tank.graphics_set.shadow_base_animation = legged_tank.graphics_set.base_animation.layers[3]
    legged_tank.graphics_set.base_animation.layers[3] = nil
    legged_tank.graphics_set.shadow_animation = legged_tank.graphics_set.animation.layers[3]
    legged_tank.graphics_set.animation.layers[3] = nil
    --legged_tank.graphics_set.animation.layers[3].shift[1] = legged_tank.graphics_set.animation.layers[3].shift[1] + legged_tank.height
    --legged_tank.graphics_set.animation.layers[3].shift[2] = legged_tank.graphics_set.animation.layers[3].shift[2] + legged_tank.height
    --legged_tank.graphics_set.base_animation.layers[3].shift[1] = legged_tank.graphics_set.base_animation.layers[3].shift[1] + legged_tank.height
    --legged_tank.graphics_set.base_animation.layers[3].shift[2] = legged_tank.graphics_set.base_animation.layers[3].shift[2] + legged_tank.height

    legged_tank.graphics_set.base_render_layer = "higher-object-above"
    legged_tank.graphics_set.render_layer = "train-stop-top"
    legged_tank.torso_rotation_speed = legged_tank.rotation_speed
    legged_tank.movement_energy_consumption = legged_tank.consumption
    legged_tank.automatic_weapon_cycling = false
    legged_tank.chain_shooting_cooldown_modifier = 0

    legged_tank.spider_engine = {
        legs = generate_legs(n)
    }

    data:extend({legged_tank})
end

