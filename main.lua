-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
--basic setup stuff
require "dbFile"

audio.setSessionProperty(audio.MixMode, audio.AmbientMixMode)  --allows device audio to continue uninterrupted 
display.setStatusBar( display.HiddenStatusBar )  --hides the status bar on the top of the device

physics = require "physics"	 --need physics to handle collisions. start/stop with physics.start() and physics.stop()
physics.start()
physics.setGravity(0,0) --dont want gravity... might want it later but not yet 
--physics.setDrawMode( "debug" ) --turns on debug view, will let us debug physics objects

local storyboard = require( "storyboard" )
storyboard.gotoScene( "tutorialtt", "fade", 1000 ) --start the splash screen with a 2 second fade animation



--[[for row in db:nrows("SELECT * FROM timeTrialsScore ORDER BY id DESC;") do
  local text = row.id.." "..row.correct.." "..row.time.." "..row.correctHa.." "..row.chosenHa.." "..row.round
  local t = display.newText(text, 20, -1200 + (20 * row.id), native.systemFont, 16)
  t:setFillColor(1,1,1)
end]]



