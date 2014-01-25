-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
--basic setup stuff
require "splash"

audio.setSessionProperty(audio.MixMode, audio.AmbientMixMode)  --allows device audio to continue uninterrupted 
display.setStatusBar( display.HiddenStatusBar )  --hides the status bar on the top of the device

physics = require "physics"	 --need physics to handle collisions. start/stop with physics.start() and physics.stop()
physics.start()
physics.setGravity(0,0) --dont want gravity... might want it later but not yet 
--physics.setDrawMode( "debug" ) --turns on debug view, will let us debug physics objects

local storyboard = require( "storyboard" )


--instance data
images = display.newGroup() --use an image group to layer properly.


storyboard.gotoScene( "splash", "fade", 2000 ) --start the splash screen










