
--===========================<When a Player Die Or Killed By Other Player>=====================================--
minetest.register_on_dieplayer(function(player, reason)
    if player then
        local player_name = player:get_player_name()
        atl_server_statistics.increment_event_stat(player_name, "Deaths Count", 1)
        if reason.type == "punch" then
            if reason.object and reason.object:is_player() then
                local killer_name = reason.object:get_player_name()
                atl_server_statistics.increment_event_stat(killer_name, "Kills Count", 1)
            end
        end
    else
        atl_server_statistics.log_error("Player is nil in on_dieplayer callback")
    end
end)

--===========================<When a Player Craft Items>=====================================--
minetest.register_on_craft(function(itemstack, player, old_craft_grid, craft_inv)
    if player then
        local amount = itemstack:get_count()
        atl_server_statistics.increment_event_stat(player:get_player_name(), "Items Crafted", amount)
    else
        atl_server_statistics.log_error("Player is nil in on_craft callback")
    end
end)

--===========================<When a Player Place Nodes>=====================================--
minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
    if placer then
        atl_server_statistics.increment_event_stat(placer:get_player_name(), "Nodes Placed", 1)
    else
        atl_server_statistics.log_error("Placer is nil in on_placenode callback")
    end
end)


--===========================<When a Player Dig Nodes>=====================================--
minetest.register_on_dignode(function(pos, oldnode, digger)
    if digger then
        atl_server_statistics.increment_event_stat(digger:get_player_name(), "Nodes Dug", 1)
    else
        atl_server_statistics.log_error("Digger is nil in on_dignode callback")
    end
end)

--===========================<When a Player Send a Messages>=====================================--
minetest.register_on_chat_message(function(player_name, message)
    atl_server_statistics.increment_event_stat(player_name, "Messages Count", 1)
end)