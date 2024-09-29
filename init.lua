atl_server_statistics = {}
atl_server_statistics.mod_storage = minetest.get_mod_storage()
atl_server_statistics.modpath = minetest.get_modpath("atl_server_statistics")
atl_server_statistics.color_message = ""
atl_server_statistics.reset_requests = {}
atl_server_statistics.statistics = {"Messages Count", "Deaths Count", "Kills Count", "Nodes Dug", "Nodes Placed", "Items Crafted", "PlayTime"}

function atl_server_statistics.load_file(path)
    local status, err = pcall(dofile, path)
    if not status then
        minetest.log("error", "-!- Failed to load file: " .. path .. " - Error: " .. err)
    else
        minetest.log("action", "-!- Successfully loaded file: " .. path)
    end
end

if atl_server_statistics.modpath then
    local files_to_load = {
        --=== <Api> ===--
        "script/api.lua",
        --=== <Events> ===--
        "script/simple_events.lua",
        "script/playtimes.lua",
        --=== <Commands> ===--
        "script/commands.lua",
        "script/reset.lua",
    }
    for _, file in ipairs(files_to_load) do
        atl_server_statistics.load_file(atl_server_statistics.modpath .. "/" .. file)
    end
else
    minetest.log("error", "-!- Files in " .. atl_server_statistics.modpath .. " mod are not set or valid.")
end
