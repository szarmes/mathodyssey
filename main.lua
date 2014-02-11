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
xscale = 1
yscale = 1

local centerX = display.contentCenterX
local centerY = display.contentCenterY

local storyboard = require( "storyboard" )

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

function toScale()
	local iphone5x = 640
	local iphone5y = 1136
	local x = display.pixelWidth
	local y = display.pixelHeight
	xscale = y/iphone5y		--opposite since this game is letterbox
	yscale = x/iphone5x

	if string.sub(system.getInfo("model"),1,4) == "iPad" and display.pixelHeight>1500 then
		xscale = xscale/2
		yscale = yscale/2
	end
	if string.sub(system.getInfo("model"),1,5) == "Droid" then
		xscale = xscale*1.5
		yscale = yscale*1.5
	end
	if string.sub(system.getInfo("model"),1,9) == "Nexus One" then
		xscale = xscale*1.5
		yscale = yscale*1.5
	end
end
toScale()


function provideHint(n,str)
	local screenGroup = n
	
	hintbubble =  display.newImage("images/bubble.png", centerX-20*xscale,centerY)
	hintbubble:scale(0.8*xscale,0.5*yscale)
	screenGroup:insert(hintbubble)

	hinttext = display.newText(str,centerX,centerY+40*yscale,400*xscale,200*yscale,"Comic Relief",18)
	hinttext:setFillColor(0)
	screenGroup:insert(hinttext)

	closebutton = display.newText("Close",centerX+180*xscale,centerY+50*yscale,"Comic Relief",18)
	closebutton:setFillColor(0)
	local function closeHint()
		screenGroup:remove(hintbubble)
		screenGroup:remove(hinttext)
		screenGroup:remove(closebutton)
	end
	closebutton:addEventListener("tap",closeHint)
	screenGroup:insert(closebutton)


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

local tablesetup2 = [[CREATE TABLE IF NOT EXISTS mapUnlocks (id INTEGER PRIMARY KEY,location STRING);]]
db:exec( tablesetup2 )

local tablesetup3 = [[CREATE TABLE IF NOT EXISTS bbScore (id INTEGER PRIMARY KEY, correct INTEGER, 
	time INTEGER, correctsign STRING, chosensign STRING, lval INTEGER, rval INTEGER, round INTEGER, level INTEGER);]]
db:exec( tablesetup3 )

local tablesetup4 = [[CREATE TABLE IF NOT EXISTS mmScore (id INTEGER PRIMARY KEY, correct INTEGER, 
	time INTEGER, correctanswer STRING, chosenanswer STRING, corectequation INTEGER, chosenequation INTEGER, round INTEGER, level INTEGER);]]
db:exec( tablesetup4 )

local tablesetup5 = [[CREATE TABLE IF NOT EXISTS firstTime (id INTEGER PRIMARY KEY, first INTEGER );]]
db:exec( tablesetup5 )

local tablesetup6 = [[CREATE TABLE IF NOT EXISTS companionSelect (id INTEGER PRIMARY KEY, companion INTEGER );]]
db:exec( tablesetup6 )

local tablesetup7 = [[CREATE TABLE IF NOT EXISTS ddScore (id INTEGER PRIMARY KEY, correct INTEGER,
	time INTEGER, numerator INTEGER, denominator INTEGER, chosennum INTEGER, round INTEGER, level INTEGER );]]
db:exec( tablesetup7 )
--local drop = [[drop table companionSelect]]
--db:exec( drop )
--local drop1 = [[drop table eeScore]]

--db:exec( drop1 )
--unlockMap("ee1")

storyboard.gotoScene( "menu")
--storyboard.gotoScene( "splash","fade",500)

--[[for row in db:nrows("SELECT * FROM timeTrialsScore ORDER BY id DESC;") do
  local text = row.id.." "..row.correct.." "..row.time.." "..row.correctHa.." "..row.chosenHa.." "..row.round
  local t = display.newText(text, 20, -1200 + (20 * row.id), native.systemFont, 16)
  t:setFillColor(1,1,1)
end


local t = display.newText(display.pixelHeight, 100, 100 , native.systemFont, 16)
  t:setFillColor(1,1,1)

  local t = display.newText(display.pixelWidth, 100, 140 , native.systemFont, 16)
  t:setFillColor(1,1,1)

  local t = display.newText(system.getInfo("model"), 100, 100 , native.systemFont, 16)
  t:setFillColor(1,1,1)

]]
--[[for row in db:nrows("SELECT * FROM mmScore ORDER BY id DESC;") do
	print ("I will print the row")
	print (row)

  local text = row.id.." "..row.correct.." "..row.time.." "..row.correctanswer.." "..row.round.." "..row.level
  local t = display.newText(text, 100, 100+row.id*20, native.systemFont, 16)
  t:setFillColor(1,1,1)
end
]]




