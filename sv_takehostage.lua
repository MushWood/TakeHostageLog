function sendToDiscord(field1, field2, field3) -- Code to & Embed to webhook
	local embed = {
		{
			["title"] = '**TakeHostage**',
			["fields"] = {
			  {
				["name"] = "Triggered By",
				["value"] = field1,
				["inline"] = "true"
			  },
			  {
				["name"] = "Target",
				["value"] = field2,
				["inline"] = "true"
			  }
			},
			["description"] = field3,
			["footer"] = {
			  ["text"] = "Extra Life Roleplay",
		},
		}
	}
  
	PerformHttpRequest("Webhook URL Goes here!", function(err, text, headers) end, 'POST', json.encode({username = "Extra Life Roleplay", embeds = embed}), { ['Content-Type'] = 'application/json' })
  end

  function SecondsToClock(seconds)
	local days = math.floor(seconds / 86400)
	seconds = seconds - days * 86400
	local hours = math.floor(seconds / 3600)
	seconds = seconds - hours * 3600
	local minutes = math.floor(seconds / 60)
	seconds = seconds - minutes * 60
	return {days = days, hours = hours, minutes = minutes, seconds = seconds}
  end
  

local takingHostage = {}
--takingHostage[source] = targetSource, source is takingHostage targetSource
local takenHostage = {}
--takenHostage[targetSource] = source, targetSource is being takenHostage by source

RegisterServerEvent("TakeHostage:sync")
AddEventHandler("TakeHostage:sync", function(targetSrc)
	local source = source
	TriggerClientEvent("TakeHostage:syncTarget", targetSrc, source)
	takingHostage[source] = targetSrc
	takenHostage[targetSrc] = source
	sendToDiscord(GetPlayerName(source) .. " (" .. source .. ")", GetPlayerName(targetSrc) .. " (" .. targetSrc .. ")", "Hostage Taken")
end)

RegisterServerEvent("TakeHostage:releaseHostage")
AddEventHandler("TakeHostage:releaseHostage", function(targetSrc)
	local source = source
	if takenHostage[targetSrc] then 
		TriggerClientEvent("TakeHostage:releaseHostage", targetSrc, source)
		takingHostage[source] = nil
		takenHostage[targetSrc] = nil
		sendToDiscord(GetPlayerName(source) .. " (" .. source .. ")", GetPlayerName(targetSrc) .. " (" .. targetSrc .. ")", "Hostage Released")
	end
end)

RegisterServerEvent("TakeHostage:killHostage")
AddEventHandler("TakeHostage:killHostage", function(targetSrc)
	local source = source
	if takenHostage[targetSrc] then 
		TriggerClientEvent("TakeHostage:killHostage", targetSrc, source)
		takingHostage[source] = nil
		takenHostage[targetSrc] = nil
		sendToDiscord(GetPlayerName(source) .. " (" .. source .. ")", GetPlayerName(targetSrc) .. " (" .. targetSrc .. ")", "Hostage Killed")
	end
end)

RegisterServerEvent("TakeHostage:stop")
AddEventHandler("TakeHostage:stop", function(targetSrc)
	local source = source

	if takingHostage[source] then
		TriggerClientEvent("TakeHostage:cl_stop", targetSrc)
		takingHostage[source] = nil
		takenHostage[targetSrc] = nil
	elseif takenHostage[source] then
		TriggerClientEvent("TakeHostage:cl_stop", targetSrc)
		takenHostage[source] = nil
		takingHostage[targetSrc] = nil
	end
end)

AddEventHandler('playerDropped', function(reason)
	local source = source
	
	if takingHostage[source] then
		TriggerClientEvent("TakeHostage:cl_stop", takingHostage[source])
		takenHostage[takingHostage[source]] = nil
		takingHostage[source] = nil
	end

	if takenHostage[source] then
		TriggerClientEvent("TakeHostage:cl_stop", takenHostage[source])
		takingHostage[takenHostage[source]] = nil
		takenHostage[source] = nil
	end
end)

