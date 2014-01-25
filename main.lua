-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
--basic setup stuff
--require "filename" is how we link other files to this one (can't now, only got 1 file)
audio.setSessionProperty(audio.MixMode, audio.AmbientMixMode)  --allows device audio to continue uninterrupted 
display.setStatusBar( display.HiddenStatusBar )  --hides the status bar on the top of the device

physics = require "physics"	 --need physics to handle collisions. start/stop with physics.start() and physics.stop()
physics.start()
physics.setGravity(0,0) --dont want gravity... might want it later but not yet 
--physics.setDrawMode( "debug" ) --turns on debug view, will let us debug physics objects


--instance data
images = display.newGroup() --use an image group to layer properly.

--functions
function start() --sample function
	background = display.newImage("images/cat.jpg")
	Runtime:addEventListener("touch",moveCatListener)
	images:insert(background)
	physics.addBody(background,{radius=10}) --uncomment the debug line above to see what this line does.
end

function moveCatListener(event) --sample listener
	background.xOrigin =event.x
	background.yOrigin = event.y
end

start()











