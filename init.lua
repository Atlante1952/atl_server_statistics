atl_server_statistics = {
    mod_storage = minetest.get_mod_storage(),
    modpath = minetest.get_modpath("atl_server_statistics"),
    statistics = {"Messages Count", "Deaths Count", "Kills Count", "Nodes Dug", "Nodes Placed", "Items Crafted", "PlayTime"},
    color_message = "#bce712",
    reset_color_message = "#bce712",
    time_before_end_request = 30,
    reset_requests = {}
}

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
        "script/api.lua",

    }
    for _, file in ipairs(files_to_load) do
        atl_server_statistics.load_file(atl_server_statistics.modpath .. "/" .. file)
    end
else
    minetest.log("error", "-!- Files in " .. atl_server_statistics.modpath .. " mod are not set or valid.")
end
