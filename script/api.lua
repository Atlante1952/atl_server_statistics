function atl_server_statistics.get_player_name(player)
    return type(player) == "userdata" and player:get_player_name() or player
end

function atl_server_statistics.get_value(player_name, key)
    return player_name and atl_server_statistics.mod_storage:get_int(player_name .. "_" .. key) or 0
end

function atl_server_statistics.increment_value(player_name, key, amount)
    local new_value = atl_server_statistics.get_value(player_name, key) + (amount or 0)
    atl_server_statistics.mod_storage:set_int(player_name .. "_" .. key, new_value)
    return new_value
end

function atl_server_statistics.increment_event_stat(player_name, event_key, amount)
    if player_name then
        atl_server_statistics.increment_value(player_name, event_key, amount)
    end
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

function atl_server_statistics.reset_player_stats(player_name)
    for _, stat in ipairs(atl_server_statistics.statistics) do
        atl_server_statistics.mod_storage:set_int(player_name .. "_" .. stat, 0)
    end
    minetest.chat_send_player(player_name, minetest.colorize(atl_server_statistics.reset_color_message, "-!- Your statistics have been reset."))
end

function atl_server_statistics.format_playtime(seconds)
    return string.format("%02d:%02d:%02d", math.floor(seconds / 3600), math.floor((seconds % 3600) / 60), seconds % 60)
end

function atl_server_statistics.update_playtime_on_stats(player_name)
    local connect_time = atl_server_statistics.mod_storage:get_int(player_name .. "_connect_time")
    if connect_time > 0 then
        atl_server_statistics.increment_value(player_name, "PlayTime", os.time() - connect_time)
        atl_server_statistics.mod_storage:set_int(player_name .. "_connect_time", os.time())
    end
end