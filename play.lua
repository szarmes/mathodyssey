---------------------------------------------------------------------------------
--
-- splash.lua
--This scene is the splash screen and will transition to the menu scene after 3 seconds
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
require "menu"
require "dbFile"
local currentPlanet
local ship
local destinationx
local destinationy
local thrustTimer
local endGroup
local inMotion = false
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local shipSrc = "images/ship2.png"


local function goTott() --play timetrials
	--cancelMeteorTimers()
	storeLastPlanet("tt")
	storyboard.gotoScene("ttselection")
	storyboard.removeScene("play")
end

local function goToee() --play exponential energy
	--cancelMeteorTimers()
	storeLastPlanet("ee")
	storyboard.gotoScene( "eeselection" )
		storyboard.removeScene("play")

end

local function goTomm() --play exponential energy
	--cancelMeteorTimers()
	storeLastPlanet("mm")
	storyboard.gotoScene( "mmselection" )
		storyboard.removeScene("play")

end

local function goTommmoon() --play exponential energy
	--cancelMeteorTimers()
	storeLastPlanet("mmmoon")
	storyboard.gotoScene( "mmmoonselection" )
		storyboard.removeScene("play")

end

local function goTobb() --play exponential energy
	--cancelMeteorTimers()
	storeLastPlanet("bb")
	storyboard.gotoScene( "bbselection" )
		storyboard.removeScene("play")

end

local function goTodd() --play exponential energy
	--cancelMeteorTimers()
	storeLastPlanet("dd")
	storyboard.gotoScene( "ddselection" )
		storyboard.removeScene("play")

end

local function goToddmoon() --play exponential energy
	--cancelMeteorTimers()
	storeLastPlanet("ddmoon")
	storyboard.gotoScene( "ddmoonselection" )
		storyboard.removeScene("play")

end

local function goHome(n) --go back to the menu
	if thrustTimer~=nil then
		timer.cancel(thrustTimer)
	end
	land(destinationx,destinationy,n)
	--cancelMeteorTimers()
	storyboard.gotoScene("menu")
		storyboard.removeScene("play")

end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view

	bg = display.newImage("images/spacebg.png", centerX,centerY+30*yscale)
	bg:scale(0.8*xscale,0.8*yscale)
	screenGroup:insert(bg)

	tt = display.newImage("images/timeplanet.png", 25*xscale,centerY-20*yscale)
	tt:scale(0.08*xscale,0.08*yscale)

	local function thrusttt()
		if inMotion==false then
			thrust(screenGroup,"tt")
		end
	end
	tt:addEventListener("tap", thrusttt)
	tt.anchorX = 0
	screenGroup:insert(tt)

	ee = display.newImage("images/expplanet.png", 250*xscale,centerY-90*yscale)
	ee:scale(0.13*xscale,0.13*yscale)
	local function thrustee()
		if inMotion==false then
			thrust(screenGroup,"ee")
		end
	end
	ee:addEventListener("tap", thrustee)
	ee.anchorX = 0
	screenGroup:insert(ee)

	mm = display.newImage("images/lavaplanet.png", centerX-70*xscale,centerY+10*yscale)
	mm:scale(0.11*xscale,0.11*yscale)
	local function thrustmm()
		if inMotion==false then
			thrust(screenGroup,"mm")
		end
	end
	mm:addEventListener("tap", thrustmm)
	mm.anchorX = 0
	screenGroup:insert(mm)

	mmmoon = display.newImage("images/mmmoon.png", centerX-100*xscale,centerY+50*yscale)
	mmmoon:scale(0.06*xscale,0.06*yscale)
	local function thrustmmmoon()
		if inMotion==false then
			thrust(screenGroup,"mmmoon")
		end
	end
	mmmoon:addEventListener("tap", thrustmmmoon)
	mmmoon.anchorX = 0
	screenGroup:insert(mmmoon)

	bb = display.newImage("images/bbplanet.png", centerX+130*xscale,centerY+40*yscale)
	bb:scale(0.1*xscale,0.1*yscale)
	local function thrustbb()
		if inMotion==false then
			thrust(screenGroup,"bb")
		end
	end
	bb:addEventListener("tap", thrustbb)
	bb.anchorX = 0
	screenGroup:insert(bb)


	dd = display.newImage("images/ddplanet.png", centerX+140*xscale,centerY-60*yscale)
	dd:scale(0.08*xscale,0.08*yscale)
	local function thrustdd()
		if inMotion==false then
			thrust(screenGroup,"dd")
		end
	end
	dd:addEventListener("tap", thrustdd)
	dd.anchorX = 0
	screenGroup:insert(dd)

	ddmoon = display.newImage("images/mmmoon.png", centerX+120*xscale,centerY-100*yscale)
	ddmoon:scale(0.06*xscale,0.06*yscale)
	local function thrustddmoon()
		if inMotion==false then
			thrust(screenGroup,"ddmoon")
		end
	end
	ddmoon:addEventListener("tap", thrustddmoon)
	ddmoon.anchorX = 0
	screenGroup:insert(ddmoon)

	home = display.newImage("images/home.png",display.contentWidth-20*xscale,22*yscale)
	home:scale(0.3*xscale,0.3*yscale)
	home:addEventListener("tap", goHome)
	screenGroup:insert(home)

	playLockLocations(screenGroup)

	--spawnMeteor(screenGroup)
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local screenGroup = self.view	
	showShip(screenGroup)

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local screenGroup = self.view	
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	
end

function playLockLocations(n)
	local screenGroup = n
	local lock1check = false
	local lock2check = false
	local lock3check = false
	local lock4check = false
	local lock5check = false
	local lock6check = false
	for row in db:nrows("SELECT * FROM mapUnlocks;") do
		if row.location == "mmplanet" then
			lock1check = true
		end
		if row.location == "mmmoon" then
			lock2check = true
		end
		if row.location == "ttplanet" then
			lock3check = true
		end
		if row.location == "eeplanet" then
			lock4check = true
		end
		if row.location == "ddplanet" then
			lock5check = true
		end
		if row.location == "ddmoon" then
			lock6check = true
		end
	end
	if lock1check==false then 
		lock1 = display.newImage("images/lock.png",mm.x+30*xscale,mm.y+15*yscale)
		lock1:scale(0.08*xscale,0.08*yscale)
		screenGroup:insert(lock1)
		mm:removeEventListener("tap",goTomm)
	end

	if lock2check==false then 
		lock2 = display.newImage("images/lock.png",mmmoon.x+30*xscale,mmmoon.y+15*yscale)
		lock2:scale(0.08*xscale,0.08*yscale)
		screenGroup:insert(lock2)
		mmmoon:removeEventListener("tap",goTommmoon)
	end
	if lock3check==false then 
		lock2 = display.newImage("images/lock.png",tt.x+30*xscale,tt.y+15*yscale)
		lock2:scale(0.08*xscale,0.08*yscale)
		screenGroup:insert(lock2)
		tt:removeEventListener("tap",goTott)
	end
	if lock4check==false then 
		lock2 = display.newImage("images/lock.png",ee.x+30*xscale,ee.y+15*yscale)
		lock2:scale(0.08*xscale,0.08*yscale)
		screenGroup:insert(lock2)
		ee:removeEventListener("tap",goToee)
	end
	if lock5check==false then 
		lock2 = display.newImage("images/lock.png",dd.x+30*xscale,dd.y+15*yscale)
		lock2:scale(0.08*xscale,0.08*yscale)
		screenGroup:insert(lock2)
		dd:removeEventListener("tap",goTodd)
	end
	if lock6check==false then 
		lock2 = display.newImage("images/lock.png",ddmoon.x+30*xscale,ddmoon.y-15*yscale)
		lock2:scale(0.08*xscale,0.08*yscale)
		screenGroup:insert(lock2)
		ddmoon:removeEventListener("tap",goToddmoon)
	end
end


function addThrusters(n)
	local screenGroup = n
	local shipx = ship.x
	local shipy = ship.y

	screenGroup:remove(ship)

	ship = display.newImage("images/ship2thrust.png",shipx,shipy)
	ship:scale(0.15*xscale,0.15*yscale)
	screenGroup:insert(ship)

	if sfxmuted == false then
		audio.play(thrustSound,{loops = -1,channel=3})
		audio.resume(3)
	end

end

local function goToNewPlanet(dest)

	if dest == "mm" then
		goTomm()
	end
	if dest == "bb" then
		goTobb()
	end
	if dest == "ee" then
		goToee()
	end
	if dest == "mmmoon" then
		goTommmoon()
	end
	if dest == "dd" then
		goTodd()
	end
	if dest == "ddmoon" then
		goToddmoon()
	end
	if dest == "tt" then
		goTott()
	end

end


function thrust(n,dest)
	local screenGroup = n

	if dest == "mm" then
		destinationx = mm.x+40*xscale
		destinationy = mm.y
	end
	if dest == "bb" then
		destinationx = bb.x+20*xscale
		destinationy = bb.y
	end
	if dest == "ee" then
		destinationx = ee.x
		destinationy = ee.y
	end
	if dest == "mmmoon" then
		destinationx = mmmoon.x
		destinationy = mmmoon.y
	end
	if dest == "dd" then
		destinationx = dd.x+20*xscale
		destinationy = dd.y
	end
	if dest == "ddmoon" then
		destinationx = ddmoon.x
		destinationy = ddmoon.y
	end
	if dest == "tt" then
		destinationx = tt.x+20*xscale
		destinationy = tt.y
		
	end
	if dest~=currentPlanet then
		currentPlanet = dest
		addThrusters(screenGroup)
		rotateShip(destinationx,destinationy,screenGroup)
		inMotion=true
	else
		goToNewPlanet(currentPlanet)
	end


end

function rotateShip(destx,desty,n)
	local angle
	local lengthx = destx-ship.x
	local lengthy = desty-ship.y

	local radians = math.atan2(lengthy,lengthx)
	local degrees = radians*57.3
	ship:rotate(degrees+90)
	physics.addBody(ship,"kinematic")
	ship:setLinearVelocity(3*lengthx/10,3*lengthy/10)

	local function arriveCheck()
		if math.abs(ship.x-destx)<20 and math.abs(ship.y-desty)<20 then
			timer.cancel(thrustTimer)
			land(destx,desty,n)
		end
	end

	thrustTimer = timer.performWithDelay(300,arriveCheck,-1)

end

function land(destx,desty,n)
	local screenGroup = n
	ship:removeSelf()
	audio.pause(3)
	goToNewPlanet(currentPlanet)
end


function showShip(n)
	local screenGroup = n
	local ship1check = false
	local ship2check = false
	local ship3check = false
	local ship4check = false
	local ship5check = false
	local ship6check = false
	local ship7check = false
	for row in db:nrows("SELECT * FROM lastPlanet;") do
		if row.location == "mm" then
			ship1check = true
			currentPlanet="mm"
		end
		if row.location == "mmmoon" then
			ship2check = true
			currentPlanet="mmmoon"
		end
		if row.location == "tt" then
			ship3check = true
			currentPlanet="tt"
		end
		if row.location == "ee" then
			ship4check = true
			currentPlanet="ee"
		end
		if row.location == "dd" then
			ship5check = true
			currentPlanet="dd"
		end
		if row.location == "ddmoon" then
			ship6check = true
			currentPlanet="ddmoon"
		end
		if row.location == "bb" then
			ship7check = true
			currentPlanet="bb"
		end
	end
	if ship1check==true then 
		ship = display.newImage(shipSrc,mm.x+30*xscale,mm.y+15*yscale)
		ship:scale(0.15*xscale,0.15*yscale)
		screenGroup:insert(ship)
	elseif ship2check==true then 
		ship = display.newImage(shipSrc,mmmoon.x+30*xscale,mmmoon.y+15*yscale)
		ship:scale(0.15*xscale,0.15*yscale)
		screenGroup:insert(ship)	
	elseif ship3check==true  then
		ship = display.newImage(shipSrc,tt.x+30*xscale,tt.y+15*yscale)
		ship:scale(0.15*xscale,0.15*yscale)
		screenGroup:insert(ship)
	
	elseif ship4check==true  then
		ship = display.newImage(shipSrc,ee.x+30*xscale,ee.y+15*yscale)
		ship:scale(0.15*xscale,0.15*yscale)
		screenGroup:insert(ship)
	
	elseif ship5check==true  then
		ship = display.newImage(shipSrc,dd.x+30*xscale,dd.y+15*yscale)
		ship:scale(0.15*xscale,0.15*yscale)
		screenGroup:insert(ship)
	
	elseif ship6check==true  then
		ship = display.newImage(shipSrc,ddmoon.x+30*xscale,ddmoon.y-15*yscale)
		ship:scale(0.15*xscale,0.15*yscale)
		screenGroup:insert(ship)
	elseif ship7check==true  then
		ship = display.newImage(shipSrc,bb.x+30*xscale,bb.y-15*yscale)
		ship:scale(0.15*xscale,0.15*yscale)
		screenGroup:insert(ship)
	end
	--physics.addBody(ship,"kinematic")
end



---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene