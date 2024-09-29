local S = minetest.get_translator("atl_server_news")

minetest.register_chatcommand("news", {
    description = "Show server news",
    privs = {shout = true},
    func = function(name)
        local player = minetest.get_player_by_name(name)
        if not player then
            return false, S("-!- Player does not exist")
        end
        atl_server_news.show_news_form(name)
        if not atl_server_news.has_read_news(name) then
            atl_server_news.set_news_read(name)
        end
        return true
    end,
})