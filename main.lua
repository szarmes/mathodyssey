-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
--basic setup stuff
require "dbFile"
local parse = require "mod_parse"

audio.setSessionProperty(audio.MixMode, audio.AmbientMixMode)  --allows device audio to continue uninterrupted 
display.setStatusBar( display.HiddenStatusBar )  --hides the status bar on the top of the device

physics = require "physics"	 --need physics to handle collisions. start/stop with physics.start() and physics.stop()
physics.start()
physics.setGravity(0,0) --dont want gravity... might want it later but not yet 
widget = require("widget")

--physics.setDrawMode( "debug" ) --turns on debug view, will let us debug physics objects
bgmusic = audio.loadStream("sounds/space.wav")
thrustSound = audio.loadStream("sounds/shipsound.wav")
launchSound = audio.loadStream("sounds/launch.wav")
companionText=""
hintOn=false

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
		xscale = xscale*1.4
		yscale = yscale*1.4
	end
	if string.sub(system.getInfo("model"),1,9) == "Nexus One" then
		xscale = xscale*1.4
		yscale = yscale*1.4
	end
	if string.sub(system.getInfo("model"),1,2) == "GT" then
		xscale = xscale*0.9
		yscale = yscale*0.9
	end
	if string.sub(system.getInfo("model"),1,9) == "Sensation" then
		xscale = xscale*1.2
		yscale = yscale*1.2
	end
end
toScale()


function provideHint(n,str)
	local screenGroup = n

	hintbutton:removeSelf()
	
	hintOn=true
	hintbubble =  display.newImage("images/bubble.png", centerX-20*xscale,centerY)
	hintbubble:scale(0.8*xscale,0.5*yscale)
	screenGroup:insert(hintbubble)

	hinttext = display.newText("Hint! "..str,centerX,centerY+40*yscale,400*xscale,200*yscale,"Comic Relief",18)
	hinttext:setFillColor(0)
	screenGroup:insert(hinttext)

	closebutton = display.newText("Close",centerX+180*xscale,centerY+50*yscale,"Comic Relief",18)
	closebutton:setFillColor(0)
	local function closeHint()
		screenGroup:remove(hintbubble)
		screenGroup:remove(hinttext)
		screenGroup:remove(closebutton)
		local function myFunction()
			hintbutton:removeSelf()
			provideHint(screenGroup, str)
		end
		hintOn=false
		hintbutton = display.newImage(companionText,display.contentWidth-20*xscale,90*yscale)
		hintbutton:scale(-0.14*xscale,0.14*yscale)
		hintbutton:addEventListener("tap", myFunction)
		screenGroup:insert(hintbutton)


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

local tablesetup8 = [[CREATE TABLE IF NOT EXISTS createdQuestions (id INTEGER PRIMARY KEY, correct INTEGER,
	time INTEGER, left INTEGER, right INTEGER, answer INTEGER, operator STRING );]]
db:exec( tablesetup8 )

local tablesetup9 = [[CREATE TABLE IF NOT EXISTS answeredQuestions (id INTEGER PRIMARY KEY, correct INTEGER,
	time INTEGER, left INTEGER, right INTEGER, answer INTEGER, operator STRING );]]
db:exec( tablesetup9 )

local tablesetup10 = [[CREATE TABLE IF NOT EXISTS lastPlanet (id INTEGER PRIMARY KEY, location STRING);]]
db:exec( tablesetup10 )

local tablesetup11 = [[CREATE TABLE IF NOT EXISTS coins (id INTEGER PRIMARY KEY, amount INTEGER);]]
db:exec( tablesetup11 )

local tablesetup12 = [[CREATE TABLE IF NOT EXISTS lastPulled (id INTEGER PRIMARY KEY, operator INTEGER, date DATETIME);]]
db:exec( tablesetup12 )

local tablesetup13 = [[CREATE TABLE IF NOT EXISTS shipSelect (id INTEGER PRIMARY KEY, ship INTEGER );]]
db:exec( tablesetup13)

local tablesetup14 = [[CREATE TABLE IF NOT EXISTS itemUnlocks (id INTEGER PRIMARY KEY, name INTEGER );]]
db:exec( tablesetup14)

--local drop = [[drop table itemUnlocks]]
--db:exec( drop )
--local drop1 = [[drop table eeScore]]

--db:exec( drop1 ) 
--unlockMap("ee1")
--storeShip(3)
storyboard.gotoScene( "splash")
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


function formatDate(date)
	local month = date.month
	if month<10 then
		month = "0"..month
	end
	local day = date.day
	if day<10 then
		day = "0"..day
	end
	local hour = date.hour
	if hour<10 then
		hour = "0"..hour
	end
	local min = date.min
	if min<10 then
		min = "0"..min
	end
	local sec = date.sec
	if sec<10 then
		sec = "0"..sec
	end
	print(date.year.."-"..month.."-"..day.."T"..hour..":"..min..":"..sec..".000Z")

	return date.year.."-"..month.."-"..day.."T"..hour..":"..min..":"..sec..".000Z"
end

--formatDate(os.date("*t"))

