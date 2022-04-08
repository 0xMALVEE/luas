local http = require "gamesense/http" or error("Sub to https://gamesense.pub/forums/viewtopic.php?id=19253 on the lua workshop.")


-- Set default values
if(database.read("should_set_default") == nill) then
    database.write("mol_webhook_link", "ENTER_LINK")
    database.write("mol_brand_name", "ENTER_BRAND_NAME")
 
end

print(database.read("mol_webhook_link"))

client.set_event_callback("console_input", function(text)
	print(text)

    if string.find(text, "/set_webhook_link") then
        local webhook_link = string.sub(text, 19,string.len(text) )
        
        database.write("mol_webhook_link", webhook_link)
        database.write('should_set_default',"false")
    end

    -- Set brand name
    if string.find(text, "/set_brand_name") then
        local brand_name = string.sub(text, 17,string.len(text) )
        
        database.write("mol_brand_name", brand_name)
    end
 
    -- Check all data
    if string.find(text, "/check_all_info") then
        local brand_link = string.sub(text, 19,string.len(text) )
        
        print("WEEBHOOK URL: ".. database.read("mol_webhook_link"))
        print("BRAND NAME: ".. database.read("mol_brand_name"))
    end

end)

local chance,bt
local hitgroup_names = {"Body", "Head", "Chest", "Stomach", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "Neck", "?", "Gear"}


local function aim_fire(e)
    chance = math.floor(e.hit_chance)
    bt = globals.tickcount() - e.tick
end

client.set_event_callback("aim_fire", aim_fire)

local function aim_hit(e)
        local group = hitgroup_names[e.hitgroup + 1] or "?"
        local name = entity.get_player_name(e.target)
        local damage = e.damage
        local hp_left = entity.get_prop(e.target, "m_iHealth")
        local js = panorama.open()
        local persona_api = js.MyPersonaAPI
        local username = persona_api.GetName()  
        local targetname = name;
        local hitbox = group;
        local dmg = damage;
        local hc = chance;
        local backtrack = bt;
        local boost = boosted and "Yes" or "No";

        http.get("https://gamesense-pub.herokuapp.com/api/discord-logs/hit?username="..username .. "&targetname="..targetname.. "&hitbox="..hitbox.."&dmg="..damage.. "&hc="..hc .. "&backtrack="..backtrack.. "&boost="..boost .. "&webhooklink="..        database.read("mol_webhook_link").. "&brandname="..database.read("mol_brand_name") , function(success, response) 
            if success then
            else
                --NOTHING
                print("Wrong Info!")
            end
        end)
 
end
client.set_event_callback("aim_hit", aim_hit)

local function aim_miss(e)
        local group = hitgroup_names[e.hitgroup + 1] or "?"
        local name = entity.get_player_name(e.target)
        local damage = e.damage
        local hp_left = entity.get_prop(e.target, "m_iHealth")
        local js = panorama.open()
        local persona_api = js.MyPersonaAPI
        local username = persona_api.GetName()  
        local targetname = name;
        local hitbox = group;
        local hc = chance;
        local backtrack = bt;
        local boost = boosted and "Yes" or "No";
        local reason = e.reason

        http.get("https://gamesense-pub.herokuapp.com/api/discord-logs/miss?username="..username .. "&targetname="..targetname.. "&hitbox="..hitbox.."&dmg=".."Zero".. "&hc="..hc .. "&backtrack="..backtrack.. "&boost="..boost.."&reason="..reason .. "&webhooklink="..        database.read("mol_webhook_link") .. "&brandname="..database.read("mol_brand_name"), function(success, response) 
            if success then
            else
                --NOTHING
                print("Wrong Info!")
            end
        end)
  
end
client.set_event_callback("aim_miss", aim_miss)
