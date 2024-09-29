function atl_server_statistics.get_value(player_name, key)
    return atl_server_statistics.mod_storage:get_int(player_name .. "_" .. key) or 0
end

function atl_server_statistics.increment_value(player_name, key, amount)
    local current_value = atl_server_statistics.get_value(player_name, key)
    atl_server_statistics.mod_storage:set_int(player_name .. "_" .. key, current_value + amount)
end

function atl_server_statistics.log_error(message)
    minetest.log("error", message)
end

function atl_server_statistics.player_has_stats(player_name)
    for _, stat in ipairs(atl_server_statistics.statistics) do
        if atl_server_statistics.mod_storage:contains(player_name .. "_" .. stat) then
            return true
        end
    end
    return false
end

function atl_server_statistics.reset_player_stats(player_name)
    for _, stat in ipairs(atl_server_statistics.statistics) do
        atl_server_statistics.mod_storage:set_int(player_name .. "_" .. stat, 0)
    end
end

function atl_server_statistics.is_player_online(player_name)
    if minetest.get_player_by_name(player_name) then
        return true
    end
    return false
end
