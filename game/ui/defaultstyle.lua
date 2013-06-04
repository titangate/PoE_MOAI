local style = {}

local chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .,:;!?()&/-'
style.font = MOAIFont.new()
style.font:loadFromTTF('asset/NeoSans.otf',chars,32,72)

style.Widget = {}

style.Table = {
	titleHeight = 20,
	horizontalMargin = 10,
	verticalMargin = 10,
	spacing = 5,

	text = {
		textSize = 16,
		dpi = 72,
		alignmentHorz = 'center',
		alignmentVert = 'right',
		font = style.font,
		color = {1,1,1}
	},

	titleStyle = {
		Button = {
			text = {
				textSize = 20,
				dpi = 72,
				alignmentHorz = 'center',
				alignmentVert = 'right',
				font = style.font,
				color = {1,1,1}
			}
		}
	}
}

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

style.TextBox = {
	text = {
		textSize = 32,
		dpi = 72,
		alignmentHorz = 'left',
		alignmentVert = 'right',
		font = style.font,
		color = {1,1,1}
	},
	editButton = {
		w = 40,
		h = 40,
		img = 'asset/ui/editbutton.png'
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