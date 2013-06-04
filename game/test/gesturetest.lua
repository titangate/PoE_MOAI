require 'ui.widget'
return function()
    --MOAIGfxDevice.setClearColor(1,0.41,0.70,1)
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
    c:load(b)
    c:setBackgroundImage("Icon_128.png")
    --c:setPosition(300,200)

    b:addWidget(c)

    assert(POE_CONTROLSCHEME == 'mobile',"not running on mobile device")
    local tg = TransformGestureRecognizer()

    b:addGestureRecognizer(tg)
    tg:registerEventHandler('GestureFinished',function()
        print 'gesture finished'
    end)

    tg:registerEventHandler('GestureFailed',function()
        print 'gesture failed'
    end)

    tg:registerEventHandler('GestureChanged',function(recognizer)
        b:setPosition(recognizer:getPosition())
        b:setAngle(recognizer:getAngle())
        b:setScale(recognizer:getScale(),recognizer:getScale())
    end)

    local tgtap = TapGestureRecognizer()
    b:addGestureRecognizer(tgtap)
    tgtap:requireGesturesToFail(tg)

    function tgtap:onGestureRecognizerChangedState(state)
        print (state)
    end

    function tgtap.onGestureRecognizerFailed()
        print 'gesture failed'
    end

    local function renderTest(frameBuffer)

    gfxQuad = MOAIGfxQuad2D.new ()
    gfxQuad:setTexture ( 'banner.png' )
    gfxQuad:setRect ( -128, -128, 128, 128 )
    gfxQuad:setUVRect ( 0, 0, 1, 1 )

    viewport = MOAIViewport.new ()
    viewport:setSize ( 320, 480 )
    viewport:setScale ( 320, -480 )

    layer = MOAILayer2D.new ()
    layer:setViewport ( viewport )
    MOAISim.pushRenderPass ( layer )

    prop = MOAIProp2D.new ()
    prop:setDeck ( gfxQuad )
    layer:insertProp ( prop )
    prop:moveRot ( -180, 1.5 )

        MOAIThread.blockOnAction ( prop:moveRot ( 360, 1.5 ))
        MOAIThread.blockOnAction ( prop:moveRot ( -360, 1.5 ))
        print 'hmm'
    end

    MOAIRenderMgr.pushRenderPass(base.layer)
    base:enableDebugProp(true)
        local d = Widget()
        d.x,d.y = 100,100
        d.w,d.h = 960,338
        d:load(base)
        base:addWidget(d)
    t = 0
    tgtap:registerEventHandler('GestureFinished',function(recognizer,event)
        --renderTest()
        b:vibrateIn()
        --b:transitionIn()
    end)
    
end