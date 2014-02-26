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

local function goToddmoon() --play timetrials
	storyboard.purgeAll()
	storyboard.gotoScene("fraction")
end

local function goToddmoon1() --play timetrials
	storyboard.purgeAll()
	storyboard.gotoScene("fraction1")
end


local function goHome() --go back to the menu
	storyboard.gotoScene("play")
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view

	bg = display.newImage("images/mmmoonbg.png", centerX,centerY+30*yscale)
	bg:scale(0.8*xscale,0.8*yscale)
	screenGroup:insert(bg)

	ddmoon = display.newImage("images/incomplete.png", centerX-110*xscale,centerY-90*yscale)
	ddmoon:scale(0.5*xscale,0.5*yscale)
	ddmoon:addEventListener("tap", goToddmoon)
	ddmoon.anchorX = 0
	screenGroup:insert(ddmoon)

	ddmoon1 = display.newImage("images/incomplete.png", centerX+40*xscale,centerY+10*yscale)
	ddmoon1:scale(0.5*xscale,0.5*yscale)
	ddmoon1:addEventListener("tap", goToddmoon1)
	ddmoon1.anchorX = 0
	screenGroup:insert(ddmoon1)

	home = display.newImage("images/home.png",display.contentWidth-20*xscale,22*yscale)
	home:scale(0.3*xscale,0.3*yscale)
	home:addEventListener("tap", goHome)
	screenGroup:insert(home)

	ddmoonLockLocations(screenGroup)
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

function ddmoonLockLocations(n)
	local screenGroup = n
	local lock1check = false
	local lock2check = false
	for row in db:nrows("SELECT * FROM mapUnlocks;") do
		if row.location == "fraction1" then
			lock1check = true
		end
	end
	if lock1check==false then 
		lock1 = display.newImage("images/lock.png",ddmoon1.x+30*xscale,ddmoon1.y+15*yscale)
		lock1:scale(0.08*xscale,0.08*yscale)
		screenGroup:insert(lock1)
		ddmoon1:removeEventListener("tap",goToddmoon1)
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