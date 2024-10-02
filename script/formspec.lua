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
        if i <= 10 then
            local row_color = i == 1 and "#363d4b" or "#434c5e"
            local formatted_value

            if stats_name == "PlayTime" then
                formatted_value = atl_server_statistics.format_playtime(player_stat.value)
            else
                formatted_value = tostring(player_stat.value)
            end

            result_lines = result_lines ..
                "box[0," .. (i - 0.1) * 0.65 .. ";5.75,0.5;" .. row_color .. "]" ..
                "box[4.25," .. (i - 0.1) * 0.65 .. ";1.5,0.5;#6dafb7]" ..
                "box[0," .. (i - 0.1) * 0.65 .. ";0.55,0.5;#4a606c]" ..
                "label[0.225," .. (i - 0.08) * 0.65 .. ";" .. i .. "]" ..
                "label[1.75," .. (i - 0.08) * 0.65 .. ";" .. player_stat.name .. "]" ..
                "label[4.45," .. (i - 0.08) * 0.65 .. ";" .. formatted_value .. "]"
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
            "box[4.25,7.75;1.5,0.5;#6dafb7]" ..
            "box[0,7.75;0.85,0.5;#4a606c]" ..
            "box[0,7.75;4.25,0.5;" .. row_color .. "]" ..
            "label[0.225,7.75;" .. player_rank .. "]" ..
            "label[1.75,7.75;" .. player_stat_in_list.name .. "]" ..
            "label[4.45,7.75;" .. formatted_value .. "]"
    end
    return result_lines
end

function atl_server_statistics.create_base_formspec(stats_list, selected_tab, player_name)
    local formspec = "size[6,8]" ..
                     "tabheader[0,0;leaderboard_tabs;Messages, Deaths, Kills, Mined, Placed, Craft, Playtime;" .. selected_tab .. ";true;false]" ..
                     "label[0.25,0;Rank]" ..
                     "label[1.75,0;Player Name]" ..
                     "label[4.5,0;Stats]" ..
                     "label[0,7.25;Your Rank]" ..
                     "label[1.5,7.25;Your Player Name]" ..
                     "label[4.25,7.25;Your Stats]"
    return formspec
end
