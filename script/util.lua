-- util.lua for atl_server_statistics
-- Contains helper functions for player name handling and event statistics.

-- Safely convert an argument to a player name string.
-- Accepts either a string (player name) or a player object (userdata).
-- Returns the player name as a string, or nil if conversion fails.
function atl_server_statistics.get_player_name_safe(arg)
    if type(arg) == "string" then
        return arg
    elseif type(arg) == "userdata" then
        -- Assume it's a player object; attempt to get the name.
        return arg:get_player_name()
    else
        core.log("warning", "atl_server_statistics: invalid player name argument type: " .. type(arg))
        return nil
    end
end

-- Legacy function for backward compatibility.
-- Converts a player object to name, otherwise returns the argument as is.
function atl_server_statistics.get_player_name(player)
    return type(player) == "userdata" and player:get_player_name() or player
end

-- Increment a statistic for an event.
-- player_name can be a string or player object.
-- event_key: the statistic name (e.g., "Deaths Count")
-- amount: number to increment by (default 1)
function atl_server_statistics.increment_event_stat(player_name, event_key, amount)
    local pname = atl_server_statistics.get_player_name_safe(player_name)
    if pname then
        atl_server_statistics.increment_value(pname, event_key, amount)
    end
end

-- Check if a player is currently online.
-- player_name can be a string or player object.
-- Returns true if the player is connected, false otherwise.
function atl_server_statistics.is_player_online(player_name)
    local pname = atl_server_statistics.get_player_name_safe(player_name)
    if not pname then return false end
    for _, player in ipairs(core.get_connected_players()) do
        if player:get_player_name() == pname then
            return true
        end
    end
    return false
end
