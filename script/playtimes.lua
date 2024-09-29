function atl_server_statistics.format_playtime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

function atl_server_statistics.on_player_join(player)
    local player_name = player:get_player_name()
    local current_time = os.time()
    atl_server_statistics.mod_storage:set_int(player_name .. "_connect_time", current_time)
end

function atl_server_statistics.update_playtime_on_stats(player_name)
    local connect_time = atl_server_statistics.mod_storage:get_int(player_name .. "_connect_time")
    local current_time = os.time()
    local time_diff = current_time - connect_time
    atl_server_statistics.increment_stat(player_name, "PlayTime", time_diff)
    atl_server_statistics.mod_storage:set_int(player_name .. "_connect_time", current_time)
end

function atl_server_statistics.on_player_leave(player)
    local player_name = player:get_player_name()
    atl_server_statistics.update_playtime_on_stats(player_name)
end

function atl_server_statistics.on_shutdown()
    for _, player in ipairs(minetest.get_connected_players()) do
        local player_name = player:get_player_name()
        atl_server_statistics.update_playtime_on_stats(player_name)
    end
end
