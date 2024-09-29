local S = minetest.get_translator("atl_server_news")

function atl_server_news.ensure_news_file_exists()
    if atl_server_news.mod_storage:get_string("news_content") == "" then
        atl_server_news.mod_storage:set_string("news_content", "")
        minetest.log("action", "Created news content in mod_storage.")
    else
        minetest.log("action", "News content already exists in mod_storage.")
    end
end

function atl_server_news.read_news_file()
    return atl_server_news.mod_storage:get_string("news_content")
end

function atl_server_news.has_read_news(player_name)
    local player = minetest.get_player_by_name(player_name)
    if not player then return false end
    local player_meta = player:get_meta()
    local last_news_read = player_meta:get_string("last_news_read")
    local current_news = atl_server_news.read_news_file()
    return last_news_read == current_news
end

function atl_server_news.set_news_read(player_name)
    local player = minetest.get_player_by_name(player_name)
    if not player then return end
    local player_meta = player:get_meta()
    local current_news = atl_server_news.read_news_file()
    player_meta:set_string("last_news_read", current_news)
end

function atl_server_news.send_news_notification(player_name)
    minetest.chat_send_player(player_name, S("-!- There are new features on the server! Type /news to read them."))
end

function atl_server_news.notify_new_news(player_name)
    if not atl_server_news.has_read_news(player_name) then
        atl_server_news.send_news_notification(player_name)
    end
end

function atl_server_news.save_news(content)
    if not content then
        minetest.log("error", "Content is nil. Cannot save news content.")
        return
    end
    atl_server_news.mod_storage:set_string("news_content", content)
    minetest.log("action", "Saved news content in mod_storage.")
end

function atl_server_news.init()
    atl_server_news.ensure_news_file_exists()
end

atl_server_news.init()