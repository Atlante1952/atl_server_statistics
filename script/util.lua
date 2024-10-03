function atl_server_statistics.get_player_name(player)
    return type(player) == "userdata" and player:get_player_name() or player
end

function atl_server_statistics.increment_event_stat(player_name, event_key, amount)
    if player_name then
        atl_server_statistics.increment_value(player_name, event_key, amount)
    end
end

function atl_server_statistics.is_player_online(player_name)
    for _, player in ipairs(minetest.get_connected_players()) do
        if player:get_player_name() == player_name then
            return true
        end
    end
    return true
end
