local S = minetest.get_translator("atl_server_statistics")

minetest.register_chatcommand("stats", {
    description = "Allows you to display your current statistics or those of a target player",
    params = "<player_name>",
    func = function(player_name, param)
        local target_player_name = param ~= "" and param or player_name
        if not atl_server_statistics.player_has_stats(target_player_name) then
            return minetest.chat_send_player(player_name, minetest.colorize(atl_server_statistics.color_message, S("-!- No statistics available for ") .. target_player_name))
        end
        if atl_server_statistics.is_player_online(target_player_name) then
            atl_server_statistics.update_playtime_on_stats(target_player_name)
        end
        local stats_message = S("-!- Statistics of ") .. target_player_name .. " <> "
        for _, stat in ipairs(atl_server_statistics.statistics) do
            local value = atl_server_statistics.get_value(target_player_name, stat)
            if value > 0 then
                stats_message = stats_message .. string.format("%s %s  |  ", stat, (stat == "PlayTime" and atl_server_statistics.format_playtime(value)) or value)
            end
        end
        minetest.chat_send_player(player_name, minetest.colorize(atl_server_statistics.color_message, stats_message))
    end,
})

minetest.register_chatcommand("reset", {
    description = "Allows you to reset your statistics with confirmation",
    func = function(player_name)
        local current_time = os.time()
        if atl_server_statistics.reset_requests[player_name] then
            if current_time - atl_server_statistics.reset_requests[player_name] <= atl_server_statistics.time_before_end_request then
                atl_server_statistics.reset_player_stats(player_name)
                minetest.chat_send_player(player_name, minetest.colorize(atl_server_statistics.reset_color_message, S("-!- Your statistics have been reset.")))
                atl_server_statistics.reset_requests[player_name] = nil
            else
                atl_server_statistics.reset_requests[player_name] = current_time
                return minetest.chat_send_player(player_name, minetest.colorize(atl_server_statistics.reset_color_message, S("-!- Reset request has expired. Please try again.")))
            end
        else
            atl_server_statistics.reset_requests[player_name] = current_time
            minetest.chat_send_player(player_name, minetest.colorize(atl_server_statistics.reset_color_message, S("-!- To confirm the reset, type /reset again within the next 30 seconds.")))
        end
    end,
})

minetest.register_chatcommand("leaderboard", {
    description = "Displays the leaderboard with tabs for each statistics domain",
    func = function(player_name)
        atl_server_statistics.handle_leaderboard_command(player_name)
        if atl_server_statistics.is_player_online(player_name) then
            atl_server_statistics.update_playtime_on_stats(player_name)
        end
    end,
})
