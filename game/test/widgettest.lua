return function()
	local base = Widget.init(0,0,screenWidth,screenHeight)
    local b = Widget()
    b.x,b.y = 0,0
    b.w,b.h = 960,338
    b:load()
    b:setBackgroundImage("banner.png")

    base:addWidget(b)

    local c = Widget()
    c.x,c.y = 300,0
    c.w,c.h = 128,128
    c:load()
    c:setBackgroundImage("Icon_128.png")

    b:addWidget(c)

    MOAIRenderMgr.pushRenderPass(base.layer)
    base:enableDebugProp(true)
end