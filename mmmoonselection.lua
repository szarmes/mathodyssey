---------------------------------------------------------------------------------
--
-- splash.lua
--This scene is the splash screen and will transition to the menu scene after 3 seconds
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
storyboard.removeAll()

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local mm1

local function goTommmoon() --play timetrials
	storyboard.purgeAll()
	storyboard.gotoScene("perimeter")
end

local function goTommmoon1() --play timetrials
	storyboard.purgeAll()
	storyboard.gotoScene("area")
end


local function goHome() --go back to the menu
	storyboard.gotoScene(storyboard.getPrevious())
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view

	bg = display.newImage("images/mmmoonbg.png", centerX,centerY+30*yscale)
	bg:scale(0.8*xscale,0.8*yscale)
	screenGroup:insert(bg)

	mmmoon = display.newImage("images/incomplete.png", -10*xscale,centerY+120*yscale)
	mmmoon:scale(0.5*xscale,0.5*yscale)
	mmmoon:addEventListener("tap", goTommmoon)
	mmmoon.anchorX = 0
	screenGroup:insert(mmmoon)

	mmmoon1 = display.newImage("images/incomplete.png", 140*xscale,centerY+10*yscale)
	mmmoon1:scale(0.5*xscale,0.5*yscale)
	mmmoon1:addEventListener("tap", goTommmoon1)
	mmmoon1.anchorX = 0
	screenGroup:insert(mmmoon1)

	home = display.newImage("images/home.png",display.contentWidth-20*xscale,22*yscale)
	home:scale(0.3*xscale,0.3*yscale)
	home:addEventListener("tap", goHome)
	screenGroup:insert(home)

	mmmoonLockLocations(screenGroup)
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	
end

function mmmoonLockLocations(n)
	local screenGroup = n
	local lock1check = false
	local lock2check = false
	for row in db:nrows("SELECT * FROM mapUnlocks;") do
		if row.location == "area" then
			lock1check = true
		end
	end
	if lock1check==false then 
		lock1 = display.newImage("images/lock.png",mmmoon1.x+30*xscale,mmmoon1.y+15*yscale)
		lock1:scale(0.08*xscale,0.08*yscale)
		screenGroup:insert(lock1)
		mmmoon1:removeEventListener("tap",goTommmoon1)
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