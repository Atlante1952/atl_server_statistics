function atl_server_statistics.generate_stats_table(stats_name, player_name)
    local players_stats = {}
    local mod_storage = atl_server_statistics.mod_storage
    local all_keys = mod_storage:to_table().fields

    for key, _ in pairs(all_keys) do
        if key:find("_" .. stats_name) then
            local name = key:sub(1, -(#stats_name + 2))
            local stat_value = mod_storage:get_int(key)
            table.insert(players_stats, {name = name, value = stat_value})
        end
    end

    table.sort(players_stats, function(a, b)
        return a.value > b.value
    end)

    local result_lines = ""
    local player_rank = nil
    local player_stat_in_list = nil

    for i = 1, #players_stats do
        local player_stat = players_stats[i]
        if player_stat.name == player_name then
            player_rank = i
            player_stat_in_list = player_stat
        end
        if i <= 5 then
            local row_color = i == 1 and "#363d4b" or "#434c5e"
            local formatted_value

            if stats_name == "PlayTime" then
                formatted_value = atl_server_statistics.format_playtime(player_stat.value)
            else
                formatted_value = tostring(player_stat.value)
            end

            result_lines = result_lines ..
                "box[0," .. (i - 0.15) .. ";5.75,0.8;" .. row_color .. "]" ..
                "label[0.5," .. (i) .. ";" .. i .. "]" ..
                "label[2," .. (i) .. ";" .. player_stat.name .. "]" ..
                "label[4.65," .. (i) .. ";" .. formatted_value .. "]"
        end
    end

    if player_stat_in_list then
        local row_color = "#434c5e"
        local formatted_value

        if stats_name == "PlayTime" then
            formatted_value = atl_server_statistics.format_playtime(player_stat_in_list.value)
        else
            formatted_value = tostring(player_stat_in_list.value)
        end

        result_lines = result_lines ..
            "box[0,7.1;5.75,0.8;" .. row_color .. "]" ..
            "label[0.5,7.25;" .. player_rank .. "]" ..
            "label[2,7.25;" .. player_stat_in_list.name .. "]" ..
            "label[4.65,7.25;" .. formatted_value .. "]"
    end
    return result_lines
end

function atl_server_statistics.create_base_formspec(stats_list, selected_tab, player_name)
    local formspec = "size[6,8]" ..
                     "tabheader[0,0;tabs;Messages, Deaths, Kills, Mined, Placed, Craft, Playtime;" .. selected_tab .. ";true;false]" ..
                     "label[0.25,0;Rank]" ..
                     "label[2,0;Player Name]" ..
                     "label[4.5,0;Stats]" ..
                     "label[0,6.5;Your Rank]" ..
                     "label[1.75,6.5;Your Player Name]" ..
                     "label[4.25,6.5;Your Stats]"
    return formspec
end

function atl_server_statistics.handle_leaderboard_command(name)
    local stats_list = atl_server_statistics.statistics
    local formspec = atl_server_statistics.create_base_formspec(stats_list, 1, name)
    formspec = formspec .. atl_server_statistics.generate_stats_table(stats_list[1], name)
    minetest.show_formspec(name, "leaderboard:form", formspec)
end
