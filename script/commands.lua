minetest.register_chatcommand("stats", {
    description = "Show a player's statistics",
    params = "<player_name>",
    func = function(player_name, param)
        local target_player_name = param
        if target_player_name == "" then
            target_player_name = player_name
        end
        if not atl_server_statistics.player_has_stats(target_player_name) then
            minetest.chat_send_player(player_name, minetest.colorize(atl_server_statistics.color_message, "-!- No statistics available for " .. target_player_name))
            return
        end
        if atl_server_statistics.is_player_online(target_player_name) then
            atl_server_statistics.update_playtime_on_stats(target_player_name)
        end
        local stats_message = string.format("-!- Statistic of %s <> ", target_player_name)
        local has_stats = false
        for _, stat in ipairs(atl_server_statistics.statistics) do
            if atl_server_statistics.mod_storage:contains(target_player_name .. "_" .. stat) then
                local value = atl_server_statistics.get_stat(target_player_name, stat)
                if value and value > 0 then
                    if stat == "PlayTime" then
                        value = atl_server_statistics.format_playtime(value)
                    end
                    stats_message = stats_message .. string.format("%s %s  |  ", stat, value)
                    has_stats = true
                end
            end
        end
        if has_stats then
            minetest.chat_send_player(player_name, minetest.colorize(atl_server_statistics.color_message, stats_message))
        else
            minetest.chat_send_player(player_name, minetest.colorize(atl_server_statistics.color_message, "-!- No statistics available for " .. target_player_name))
        end
    end,
})

minetest.register_chatcommand("reset", {
    description = "Reset Your Stats",
    func = function(player_name)
        local current_time = os.time()
        if atl_server_statistics.reset_requests[player_name] then
            local request_time = atl_server_statistics.reset_requests[player_name]
            if current_time - request_time <= atl_server_statistics.time_before_end_request then
                atl_server_statistics.reset_player_stats(player_name)
                atl_server_statistics.reset_requests[player_name] = nil
                if atl_server_statistics.is_player_online(player_name) then
                    atl_server_statistics.update_playtime_on_stats(player_name)
                end
            else
                minetest.chat_send_player(player_name, minetest.colorize(atl_server_statistics.reset_color_message, "-!- Reset request has expired. Please try again."))
            end
        else
            atl_server_statistics.reset_requests[player_name] = current_time
            minetest.chat_send_player(player_name, minetest.colorize(atl_server_statistics.reset_color_message, "-!- To confirm the reset of your statistics, type /reset again within the next 30 seconds."))
        end
    end,
})
