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
bgmusic = audio.loadStream("sounds/space.wav")
sfxmuted = false
musicmuted = false

function mutesfx()
	if sfxmuted == false then
		audio.pause(2)
		sfxmuted = true
	else
		audio.resume(2)
		sfxmuted = false
	end
end

function mutemusic()
	if musicmuted == false then
		audio.pause(1)
		musicmuted = true
	else
		audio.resume(1)
		musicmuted = false
	end
end




local storyboard = require( "storyboard" )
--storyboard.gotoScene( "splash", "fade", 1000 ) --start the splash screen with a 2 second fade animation
--Setup the table if it doesn't exist
local tablesetup = [[CREATE TABLE IF NOT EXISTS timeTrialsScore (id INTEGER PRIMARY KEY, correct INTEGER, 
		time INTEGER, correctHa INTEGER, correctMa INTEGER, chosenHa INTEGER, chosenMa INTEGER, 
		r1 INTEGER, r2 INTEGER, round INTEGER, level INTEGER);]]
db:exec( tablesetup )

--Setup the table if it doesn't exist
local tablesetup1 = [[CREATE TABLE IF NOT EXISTS eeScore (id INTEGER PRIMARY KEY, correct INTEGER, 
	time INTEGER, correcte INTEGER, chosene INTEGER, correctnum INTEGER, chosennum INTEGER, round INTEGER, level INTEGER);]]
db:exec( tablesetup1 )


--local drop = [[drop table timeTrialsScore]]
--local drop1 = [[drop table eeScore]]
--db:exec( drop )
--db:exec( drop1 )


--storyboard.gotoScene( "telltime")
storyboard.gotoScene( "splash","fade",500)



--[[for row in db:nrows("SELECT * FROM timeTrialsScore ORDER BY id DESC;") do
  local text = row.id.." "..row.correct.." "..row.time.." "..row.correctHa.." "..row.chosenHa.." "..row.round
  local t = display.newText(text, 20, -1200 + (20 * row.id), native.systemFont, 16)
  t:setFillColor(1,1,1)
end]]



