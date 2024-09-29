function atl_server_statistics.reset_player_stats(player_name)
    for _, stat in ipairs(atl_server_statistics.statistics) do
        atl_server_statistics.mod_storage:set_int(player_name .. "_" .. stat, 0)
    end
    minetest.chat_send_player(player_name, minetest.colorize(atl_server_statistics.reset_color_message, "-!- Your statistics have been reset."))
end

function atl_server_statistics.cancel_reset_request(player_name)
    reset_requests[player_name] = nil
    minetest.chat_send_player(player_name, minetest.colorize(atl_server_statistics.reset_color_message, "-!- Reset request has expired."))
end