function atl_server_statistics.get_value(player_name, key)
    local pname = atl_server_statistics.get_player_name_safe(player_name)
    if not pname then return 0 end
    return atl_server_statistics.mod_storage:get_int(pname .. "_" .. key)
end

function atl_server_statistics.increment_value(player_name, key, amount)
    local pname = atl_server_statistics.get_player_name_safe(player_name)
    if not pname then return 0 end
    local new_value = atl_server_statistics.get_value(pname, key) + (amount or 0)
    atl_server_statistics.mod_storage:set_int(pname .. "_" .. key, new_value)
    return new_value
end

function atl_server_statistics.player_has_stats(player_name)
    local pname = atl_server_statistics.get_player_name_safe(player_name)
    if not pname then return false end
    local all_keys = atl_server_statistics.mod_storage:to_table().fields
    for _, stat in ipairs(atl_server_statistics.statistics) do
        if all_keys[pname .. "_" .. stat] ~= nil then
            return true
        end
    end
    return false
end

function atl_server_statistics.reset_player_stats(player_name)
    local pname = atl_server_statistics.get_player_name_safe(player_name)
    if not pname then return end
    for _, stat in ipairs(atl_server_statistics.statistics) do
        atl_server_statistics.mod_storage:set_int(pname .. "_" .. stat, 0)
    end
    atl_server_statistics.mod_storage:set_int(pname .. "_connect_time", os.time())
end

function atl_server_statistics.format_playtime(seconds)
    return string.format("%02d:%02d:%02d", math.floor(seconds / 3600), math.floor((seconds % 3600) / 60), seconds % 60)
end

function atl_server_statistics.update_playtime_on_stats(player_name)
    local pname = atl_server_statistics.get_player_name_safe(player_name)
    if not pname then return end
    local connect_time = atl_server_statistics.mod_storage:get_int(pname .. "_connect_time")
    if connect_time > 0 then
        atl_server_statistics.increment_value(pname, "PlayTime", os.time() - connect_time)
        atl_server_statistics.mod_storage:set_int(pname .. "_connect_time", os.time())
    end
end
