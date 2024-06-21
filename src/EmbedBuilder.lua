local builder = {}
local types = require(script.Parent.Types)
builder.__index = builder

function builder.new()
	local newEmbed = {}
	setmetatable(newEmbed, builder)
	newEmbed.fields = {}
	newEmbed.image = {}
	newEmbed.thumbnail = {}
	return newEmbed
end

function builder:setProperties(properties: types.embedProperties)
	local content = self
	if not properties.color then
		properties.color = Color3.fromRGB(0,0,0):ToHex()
	end
	
	self.title = properties.title
	self.description = properties.description
	self.url = properties.url
	self.color = properties.color
end

function builder:setTimestamp(timestamp: string)
	self.timestamp = timestamp
end

function builder:setImages(imageProperties: types.imageProperties)
	if imageProperties.image then
		self.image.url = imageProperties.image
	end
	
	if imageProperties.thumbnail then
		self.thumbnail.url = imageProperties.thumbnail
	end
end

function builder:setAuthor(author: types.author)
	self.author = {
		name = author.name;
		url = author.url;
		icon_url = author.imageUrl;
	}
end

function builder:createField(fieldProperties : types.fieldProperties)
	local field = {
		name = fieldProperties.name,
		value = fieldProperties.value,
		inline = fieldProperties.inline
	}
	table.insert(self.fields, field)
end

return builder
