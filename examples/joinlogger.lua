local Webhook = ""
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local HookBlox = require(script.HookBlox)
local EmbedBuilder = HookBlox.EmbedBuilder
local WebhookClient = HookBlox.new(Webhook)

local function LogPlayer(player: Player)
	warn("Player named "..player.Name.." has joined the experience.")
	local JoinEmbed = EmbedBuilder.new()
	JoinEmbed:setProperties({
		title = "USER LOGGER",
		url = "https://www.roblox.com/users/"..player.UserId.."/profile",
	})
	JoinEmbed:createField({
		name = "👤 User",
		value = "**"..player.DisplayName.."** (@"..player.Name..")",
		inline = true
	})
	local response = WebhookClient:sendContent({
		content = 'A new user has been logged!',
		embeds = {JoinEmbed},
	})
end

for i,v in ipairs(Players:GetPlayers()) do
	LogPlayer(v)
end
Players.PlayerAdded:Connect(LogPlayer)
