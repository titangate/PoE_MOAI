require 'ui.widget'
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
    --c:setPosition(300,200)

    b:addWidget(c)

    assert(POE_CONTROLSCHEME == 'mobile',"not running on mobile device")
    local tg = TransformGestureRecognizer()

    base:addGestureRecognizer(tg)
    function tg.onGestureRecognizerFinished()
        print 'gesture finished'
    end

    function tg.onGestureRecognizerFailed()
        print 'gesture failed'
    end

    function tg.onGestureRecognizerChanged(recognizer)
        b:setPosition(recognizer:getPosition())
        b:setAngle(recognizer:getAngle())
        b:setScale(recognizer:getScale(),recognizer:getScale())
        --b:updateBackgroundImage()
    end

    local tgtap = TapGestureRecognizer()
    base:addGestureRecognizer(tgtap)
    tgtap:requireGesturesToFail(tg)

    function tgtap:onGestureRecognizerFinished()
        print 'tapped'
        if b:inBound(self:getPosition()) then
            b.backgroundImage:loadShader(Shader.vibrate(b.backgroundImage))
        end
    end
    function tgtap:onGestureRecognizerChangedState(state)
        print (state)
    end

    function tgtap.onGestureRecognizerFailed()
        print 'gesture failed'
    end

    MOAIRenderMgr.pushRenderPass(base.layer)
    base:enableDebugProp(true)
end