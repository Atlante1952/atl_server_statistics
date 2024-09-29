minetest.register_on_dieplayer(function(player, reason)
    local player_name = player:get_player_name()
    atl_server_statistics.increment_value(player_name, "Deaths Count", 1)
    if reason.type == "punch" and reason.object and reason.object:is_player() then
        local killer_name = reason.object:get_player_name()
        atl_server_statistics.increment_value(killer_name, "Kills Count", 1)
    end
end)

minetest.register_on_craft(function(itemstack, player)
    local amount = itemstack:get_count()
    atl_server_statistics.increment_value(player:get_player_name(), "Items Crafted", amount)
end)

minetest.register_on_placenode(function(_, _, placer)
    atl_server_statistics.increment_value(placer:get_player_name(), "Nodes Placed", 1)
end)

minetest.register_on_dignode(function(_, _, digger)
    atl_server_statistics.increment_value(digger:get_player_name(), "Nodes Dug", 1)
end)

minetest.register_on_chat_message(function(player_name)
    atl_server_statistics.increment_value(player_name, "Messages Count", 1)
end)

minetest.register_on_joinplayer(function(player) atl_server_statistics.on_player_join(player) end)
minetest.register_on_shutdown(function() atl_server_statistics.on_shutdown() end)
minetest.register_on_leaveplayer(function(player) atl_server_statistics.on_player_leave(player) end)
