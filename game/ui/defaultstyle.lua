local style = {}

local chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .,:;!?()&/-'
style.font = MOAIFont.new()
style.font:loadFromTTF('asset/NeoSans.otf',chars,32,72)

style.Button = {
	text = {
		textSize = 32,
		dpi = 72,
		alignmentHorz = 'center',
		alignmentVert = 'right',
		font = style.font,
		color = {1,1,1}
	}
}

style.GlowBoxActor = {
	edgeimage = {
		box = 'asset/ui/glowbox-poe.png',
		edge = 'asset/ui/glowboxedge.png'
	},
	margin = 12
}


return style