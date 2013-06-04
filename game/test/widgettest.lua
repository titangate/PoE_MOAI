local function buttonTestPanel(base)
    local panelbase = Widget()
    panelbase.w,panelbase.h = 600,600
    panelbase.x,panelbase.y = 100,0
    panelbase:load(base)
    panelbase:setBorderStyle'box'
    base:addWidget(panelbase)
    local panel = Table()
    panel.w,panel.h = 600,600
    panel.x,panel.y = 0,0
    panel:load(panelbase)
    panelbase:addWidget(panel)
    panel:setTitle'BUTTON TEST'
    local button = Button()
    button.x,button.y = -0,-0
    button.w,button.h = 300,38
    button:load(panel)
    panel:addWidget(button)
    button:setBorderStyle'edge'
    button:setTitle'COME AT ME BRO'
    button:registerEventHandler('Click',function( )
            print 'button pressed'
        end)

    local textbox = TextBox()
    textbox.x,textbox.y = 0,100
    textbox.w,textbox.h = 300,48
    textbox:load(panel)
    panel:addWidget(textbox)
    panel:vibrateIn()
    --panel:setPosition(0,0,2)
    --panelbase:setContentOffset(-300,0,3)
    --panelbase:transitionIn()
    --panelbase:setPosition(-300,0,10)
end

return function()
	local base = Widget.init(0,0,screenWidth,screenHeight)
    buttonTestPanel(base)
    base.layer:setClearColor(1,1,1,1)
    MOAIRenderMgr.pushRenderPass(base.layer)
    --base:enableDebugProp(true)
end