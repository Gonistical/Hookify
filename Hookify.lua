--[[

	------------------------------------------------------------------------- 
	
  	 _    _             _    _  __       
 	| |  | |           | |  (_)/ _|      
 	| |__| | ___   ___ | | ___| |_ _   _ 
 	|  __  |/ _ \ / _ \| |/ / |  _| | | |
 	| |  | | (_) | (_) |   <| | | | |_| |
 	|_|  |_|\___/ \___/|_|\_\_|_|  \__, |
                                    __/ |
                                   |___/ 
                                                                 
    -------------------------------------------------------------------------  
    
	Hookify.lua
	A Module that makes webhooks as easy as possible!
	
	------------------------------------------------------------------------- 
	
	Featuring: Built-in Embed Builder
	Created by @Gonistical / Date: 6/21/2024
	
	------------------------------------------------------------------------- 
	 
	DEVFORUM POST: https://devforum.roblox.com/t/hookblox-module-for-discord-webhooks/3032693
	
	------------------------------------------------------------------------- 
--]]


local hooks = {}
hooks.__index = hooks

local HttpService = game:GetService("HttpService")
local types = require(script.Types)
local embedBuilder = script.EmbedBuilder
hooks.EmbedBuilder = require(embedBuilder)

function hooks.new(webhook : string)
	assert(webhook, 'No webhook was provided?')
	assert(HttpService.HttpEnabled, 'HttpRequests are disabled!')
	assert(type(webhook) == "string", 'The webhook URL must be a string.')

	local WebhookParameters = HttpService:RequestAsync({
		Url = webhook,
		Method = "GET"
	})
	local WebhookData = HttpService:JSONDecode(WebhookParameters["Body"])
	if WebhookData.message then
		assert(WebhookData.message ~= "Unknown Webhook", 'Webhook URL is invalid')
	end

	local WebhookBody : types.webhookBody = {
		guild = {
			guildId = WebhookData.guild_id,
			channelId = WebhookData.channel_id
		},
		name = WebhookData.name,
		token = WebhookData.token,
		webhookType = WebhookData["type"],
		url = WebhookData.url,
		id = WebhookData.id
	}

	setmetatable(WebhookBody, hooks)
	return WebhookBody
end

function hooks:Destroy()
	local Deletion = HttpService:RequestAsync({
		Method = "DELETE",
		Url = self.url
	})
	self = {}
end

function hooks:SendJSON(json : {})
	assert(json, 'No data was provided')

	local Response = HttpService:RequestAsync({
		Url = self.url,
		Method = "POST",
		Body = json,
		Headers = {
			["Content-Type"] = "application/json"
		}
	})
end

function hooks:Send(content : types.webhookSendQuery)
	assert(content, 'No data was provided')

	local luaContent = {}
	if type(content) == 'string' then
		luaContent.content = content
		local encoded = HttpService:JSONEncode(luaContent)
		local Response = HttpService:RequestAsync({
			Url = self.url,
			Method = "POST",
			Body = encoded,
			Headers = {
				["Content-Type"] = "application/json"
			}
		})
		return
	end

	local avatarURL = content.avatar
	local username = content.name
	local contentString = content.content

	luaContent.content = contentString
	luaContent.username = username
	luaContent.avatar_url = avatarURL
	luaContent.thread_name = content.threadName
	luaContent.embeds = content.embeds

	if content.flags then
		if content.flags.suppressEmbeds and content.flags.suppressNotifs then
			luaContent.flags = 4100
		elseif content.flags.suppressEmbeds then
			luaContent.flags = 4096
		elseif content.flags.suppressNotifs then
			luaContent.flags = 4
		end
	end

	local encoded = HttpService:JSONEncode(luaContent)
	local Response = HttpService:RequestAsync({
		Url = self.url,
		Method = "POST",
		Body = encoded,
		Headers = {
			["Content-Type"] = "application/json"
		}
	})

	return Response
end

return hooks
