export type webhookGuildBody = {
	guildId: string,
	channelId: string
}

export type webhookParameters = {
	url: string
}

export type webhookBody = {
	guild : webhookGuildBody,
	name: string,
	token: string,
	webhookType: number,
	url: string,
	id: string
}

export type messageFlags = {
	suppressEmbeds: boolean,
	suppressNotifs: boolean
}

export type webhookSendQuery = {
	content: string,
	embeds: {},
	avatar: string,
	name: string,
	flags: messageFlags,
	threadName: string
}

export type embedProperties = {
	title: string,
	description: string,
	url: string,
	color: Color3
}

export type imageProperties = {
	image: string,
	thumbnail: string
}

export type author = {
	name: string,
	imageUrl: string,
	url: string
}

export type fieldProperties = {
	name: string,
	value: string,
	inline: boolean
}

return {}
