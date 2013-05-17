----------------------------------------------------------------
-- Copyright (c) 2010-2011 Zipline Games, Inc. 
-- All Rights Reserved. 
-- http://getmoai.com
----------------------------------------------------------------

require 'middleclass'
require 'library.init'
require 'shader.init'
require 'actor.init'
require 'playground.maintest'
require 'config'

RUNMODE = 'SCENETEST'
if RUNMODE == 'UNITTEST' then
require 'unittest.init'
return
elseif RUNMODE == 'GFXTEST' then
	require 'test.gfxtest'()
	return
elseif RUNMODE == 'CMDTEST' then
elseif RUNMODE == 'SCENETEST' then
	require 'test.scenetest'()
	return
end

MOAISim.openWindow ( "test", 1024, 600 )

viewport = MOAIViewport.new ()
viewport:setSize ( 1024, 600 )
viewport:setScale ( 1024, 600 )

layer = MOAILayer2D.new ()
layer:setViewport ( viewport )
MOAISim.pushRenderPass ( layer )

gfxQuad = MOAIGfxQuad2D.new ()
gfxQuad:setTexture ( "banner.png" )
gfxQuad:setRect ( -468, -144, 468, 144 )

prop = MOAIProp2D.new ()
prop:setDeck ( gfxQuad )
prop:setLoc ( 0, 80 )
layer:insertProp ( prop )

font = MOAIFont.new ()
font:loadFromTTF ( "arialbd.ttf", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789,.?!", 12, 163 )

textbox = MOAITextBox.new ()
textbox:setFont ( font )
textbox:setRect ( -160, -80, 160, 80 )
textbox:setLoc ( 0, -100 )
textbox:setYFlip ( true )
textbox:setAlignment ( MOAITextBox.CENTER_JUSTIFY )
layer:insertProp ( textbox )

textbox:setString ( "Path of Eternity is running!\n<c:0F0>Success.<c>" )
textbox:spool ()

function twirlingTowardsFreedom ()
	while true do
		MOAIThread.blockOnAction ( prop:moveRot ( 360, 1.5 ))
		MOAIThread.blockOnAction ( prop:moveRot ( -360, 1.5 ))
	end
end

thread = MOAIThread.new ()
thread:run ( twirlingTowardsFreedom )
