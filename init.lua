atl_server_news = {}
atl_server_news.modpath = minetest.get_modpath("atl_server_news")
atl_server_news.mod_storage = minetest.get_mod_storage()

function atl_server_news.load_file(path)
    local status, err = pcall(dofile, path)
    if not status then
        minetest.log("error", "-!- Failed to load file: " .. path .. " - Error: " .. err)
    else
        minetest.log("action", "-!- Successfully loaded file: " .. path)
    end
end

if atl_server_news.modpath then
    local files_to_load = {
        "script/api.lua",
        "script/events.lua",
        "script/commands.lua",
        "script/interface.lua",
    }

    for _, file in ipairs(files_to_load) do
        atl_server_news.load_file(atl_server_news.modpath .. "/" .. file)
    end
else
    minetest.log("error", "-!- Files in " .. atl_server_news.modpath .. " mod are not set or valid.")
end
