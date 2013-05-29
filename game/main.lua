----------------------------------------------------------------
-- Copyright (c) 2010-2011 Zipline Games, Inc. 
-- All Rights Reserved. 
-- http://getmoai.com
----------------------------------------------------------------

require 'middleclass'
require 'library.init'
require 'shader.init'
require 'actor.init'
require 'ui.init'
require 'playground.maintest'
require 'config'

if MOAIFileSystem.checkFileExists('runtest.lua') then
	require 'runtest'
else
	require 'test.scenetest'()
end