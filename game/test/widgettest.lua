return function()
	local base = Widget.init(0,0,screenWidth,screenHeight)
    local b = Widget()
    b.x,b.y = 0,0
    b.w,b.h = 960,338
    b:load(base)
    b:setBackgroundImage("banner.png")

    base:addWidget(b)

    local c = Widget()
    c.x,c.y = 300,0
    c.w,c.h = 128,128
    c:load(base)
    c:setBackgroundImage("Icon_128.png")

    b:addWidget(c)

    local button = Button()
    button.x,button.y = -0,-0
    button.w,button.h = 400,50
    button:load(base)
    button:setTitle'<c:00ffaa>COME AT ME BRO<>'

    base:addWidget(button)

    MOAIRenderMgr.pushRenderPass(base.layer)
    base:enableDebugProp(true)
end