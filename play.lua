---------------------------------------------------------------------------------
--
-- splash.lua
--This scene is the splash screen and will transition to the menu scene after 3 seconds
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
require "menu"

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY

local function goTott() --play timetrials
	storyboard.purgeAll()
	cancelMeteorTimers()
	storyboard.gotoScene("ttselection")
end

local function goToee() --play exponential energy
	storyboard.purgeAll()
	cancelMeteorTimers()
	storyboard.gotoScene( "eeselection" )
end

local function goTomm() --play exponential energy
	storyboard.purgeAll()
	cancelMeteorTimers()
	storyboard.gotoScene( "mmselection" )
end

local function goTommmoon() --play exponential energy
	storyboard.purgeAll()
	cancelMeteorTimers()
	storyboard.gotoScene( "mmmoonselection" )
end

local function goTobb() --play exponential energy
	storyboard.purgeAll()
	cancelMeteorTimers()
	storyboard.gotoScene( "bbselection" )
end

local function goTodd() --play exponential energy
	storyboard.purgeAll()
	cancelMeteorTimers()
	storyboard.gotoScene( "ddselection" )
end

local function goHome() --go back to the menu
	storyboard.gotoScene("menu")
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view

	bg = display.newImage("images/galaxybg.png", centerX,centerY+30*yscale)
	bg:scale(0.8*xscale,0.8*yscale)
	screenGroup:insert(bg)

	tt = display.newImage("images/timeplanet.png", 25*xscale,centerY-20*yscale)
	tt:scale(0.5*xscale,0.5*yscale)
	tt:addEventListener("tap", goTott)
	tt.anchorX = 0
	screenGroup:insert(tt)

	ee = display.newImage("images/expplanet.png", 250*xscale,centerY-90*yscale)
	ee:scale(0.6*xscale,0.6*yscale)
	ee:addEventListener("tap", goToee)
	ee.anchorX = 0
	screenGroup:insert(ee)

	mm = display.newImage("images/lavaplanet.png", centerX-70*xscale,centerY+10*yscale)
	mm:scale(0.2*xscale,0.2*yscale)
	mm:addEventListener("tap", goTomm)
	mm.anchorX = 0
	screenGroup:insert(mm)

	mmmoon = display.newImage("images/mmmoon.png", centerX-100*xscale,centerY+50*yscale)
	mmmoon:scale(0.06*xscale,0.06*yscale)
	mmmoon:addEventListener("tap", goTommmoon)
	mmmoon.anchorX = 0
	screenGroup:insert(mmmoon)

	bb = display.newImage("images/bbplanet.png", centerX+130*xscale,centerY+40*yscale)
	bb:scale(0.1*xscale,0.1*yscale)
	bb:addEventListener("tap", goTobb)
	bb.anchorX = 0
	screenGroup:insert(bb)


	dd = display.newImage("images/ddplanet.png", centerX+140*xscale,centerY-60*yscale)
	dd:scale(0.14*xscale,0.14*yscale)
	dd:addEventListener("tap", goTodd)
	dd.anchorX = 0
	screenGroup:insert(dd)

	home = display.newImage("images/home.png",display.contentWidth-20*xscale,22*yscale)
	home:scale(0.3*xscale,0.3*yscale)
	home:addEventListener("tap", goHome)
	screenGroup:insert(home)

	playLockLocations(screenGroup)

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local screenGroup = self.view	
	spawnMeteor(screenGroup)
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local screenGroup = self.view	
	screenGroup:remove(meteor)
	cancelMeteorTimers()
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