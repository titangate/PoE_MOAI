require 'ui.widget'
return function()
	local base = Widget.init(0,0,screenWidth,screenHeight)
    local b = Widget()
    b.x,b.y = 0,0
    b.w,b.h = 128,128
    b:load()
    b:setBackgroundImage("Icon_128.png")
    base:addWidget(b)
    assert(POE_CONTROLSCHEME == 'mobile',"not running on mobile device")
    local tg = TransformGestureRecognizer()

    base:addWidget(b)
    base:addGestureRecognizer(tg)
    tg.delegate = base
    MOAIInputMgr.device.touch:setCallback(function(eventType,id,x,y,touchCount)
        x,y = translateCoordinatesFormInput(x,y)
        tg:touchEvent(eventType,id,x,y,touchCount)
    end)
    function base:gestureRecognizerFinished()
        print 'gesture finished'
    end

    function base:gestureRecognizerFailed()
        print 'gesture failed'
    end

    function base:gestureRecognizerChanged(recognizer)
        print('Position',recognizer:getPosition())
        print('Angle',recognizer:getAngle())
        print('Scale',recognizer:getScale())
        b:setPosition(recognizer:getPosition())
        b:setAngle(recognizer:getAngle())
        b:setScale(recognizer:getScale(),recognizer:getScale())
        b:updateBackgroundImage()
    end

MOAIRenderMgr.pushRenderPass(base.layer)
end