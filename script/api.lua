function atl_server_statistics.get_value(player_name, key)
    if type(player_name) == "userdata" then
        player_name = player_name:get_player_name()
    end
    local value = atl_server_statistics.mod_storage:get_int(player_name .. "_" .. key)
    return value
end

function atl_server_statistics.increment_value(player_name, key, amount)
    if type(player_name) == "userdata" then
        player_name = player_name:get_player_name()
    end
    local current_value = atl_server_statistics.get_value(player_name, key)
    local new_value = current_value + amount
    atl_server_statistics.mod_storage:set_int(player_name .. "_" .. key, new_value)
    return new_value
end

function atl_server_statistics.get_stat(player_name, key)
    return atl_server_statistics.get_value(player_name, key)
end

function atl_server_statistics.increment_stat(player_name, key, amount)
    atl_server_statistics.increment_value(player_name, key, amount)
end

function atl_server_statistics.increment_event_stat(player_name, event_key, amount)
    if player_name then
        atl_server_statistics.increment_stat(player_name, event_key, amount)
    else
        atl_server_statistics.log_error("Player name is nil in event callback for " .. event_key)
    end
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

function atl_server_statistics.is_player_online(player_name)
    for _, player in ipairs(minetest.get_connected_players()) do
        if player:get_player_name() == player_name then
            return true
        end
    end
    return false
end


