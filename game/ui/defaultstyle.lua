local style = {}

local chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .,:;!?()&/-'
style.font = MOAIFont.new()
style.font:loadFromTTF('asset/NeoSans.otf',chars,24,72)

style.Button = {
	text = {
		textSize = 24,
		dpi = 72,
		alignmentHorz = 'center',
		alignmentVert = 'center',
		font = style.font,
	}
}

style.GlowBoxActor = {
	edgeimage = 'asset/ui/glowboxedge.png',
	margin = 36
}


return style