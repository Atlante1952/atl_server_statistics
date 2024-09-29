function atl_server_news.show_news_form(player_name)
    atl_server_news.ensure_news_file_exists()
    local news_content = atl_server_news.read_news_file()
    local formspec = "size[6,8]" ..
                     "tabheader[0,0;tabs;   Server News   ,   Edit News (Admin Only)   ;1;false;false]" ..
                     "box[0,0;5.80,8.1;#000000]" ..
                     "hypertext[0.5,0.15;5.7,8.65;news;" .. minetest.formspec_escape(news_content) .. "]"
    minetest.show_formspec(player_name, "server_news", formspec)
end

function atl_server_news.show_edit_news_form(player_name)
    local news_content = atl_server_news.read_news_file()
    local formspec = "size[6,8]" ..
                          "tabheader[0,0;tabs;   Server News   ,   Edit News (Admin Only)   ;2;false;false]" ..
                          "textarea[0.5,0.5;5.5,7.5;news_content;Edit News:;" .. news_content .. "]" ..
                          "button[2,7;2,1;save;Save]"
    minetest.show_formspec(player_name, "server_news_edit", formspec)
end