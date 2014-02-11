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
local ee
local ee1

local function goToee() --play timetrials
	storyboard.purgeAll()
	storyboard.gotoScene("exponentialenergy")
end

local function goToee1() --play exponential energy
	storyboard.purgeAll()
	storyboard.gotoScene( "exponentialenergy1" )
end


local function goToee2() --play exponential energy
	storyboard.purgeAll()
	storyboard.gotoScene( "exponentialenergyhard" )
end

local function goHome() --go back to the menu
	storyboard.gotoScene(storyboard.getPrevious())
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view

	bg = display.newImage("images/eemap.png", centerX,centerY+30*yscale)
	bg:scale(0.6*xscale,0.6*yscale)
	screenGroup:insert(bg)

	ee = display.newImage("images/incomplete.png", centerX-190*xscale,centerY+80*yscale)
	ee:scale(0.5*xscale,0.5*yscale)
	ee:addEventListener("tap", goToee)
	ee.anchorX = 0
	screenGroup:insert(ee)

	ee1 = display.newImage("images/incomplete.png", centerX,centerY-40*yscale)
	ee1:scale(0.5*xscale,0.5*yscale)
	ee1:addEventListener("tap", goToee1)
	ee1.anchorX = 0
	screenGroup:insert(ee1)

	ee2 = display.newImage("images/incomplete.png", centerX+130*xscale,centerY+90*yscale)
	ee2:scale(0.5*xscale,0.5*yscale)
	ee2:addEventListener("tap", goToee2)
	ee2.anchorX = 0
	screenGroup:insert(ee2)
	
	home = display.newImage("images/home.png",display.contentWidth-20*xscale,22*yscale)
	home:scale(0.3*xscale,0.3*yscale)
	home:addEventListener("tap", goHome)
	screenGroup:insert(home)

	eeLockLocations(screenGroup)
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

function eeLockLocations(n)
	local screenGroup = n
	local lock1check = false
	local lock2check = false
	for row in db:nrows("SELECT * FROM mapUnlocks;") do
		if row.location == "ee1" then
			lock1check = true
		end
		if row.location == "ee2" then
			lock2check = true
		end
	end
	if lock1check==false then 
		lock1 = display.newImage("images/lock.png",ee1.x+30*xscale,ee1.y+15*yscale)
		lock1:scale(0.08*xscale,0.08*yscale)
		screenGroup:insert(lock1)
		ee1:removeEventListener("tap",goToee1)
	end

	if lock2check==false then 
		lock2 = display.newImage("images/lock.png",ee2.x+30*xscale,ee2.y+15*yscale)
		lock2:scale(0.08*xscale,0.08*yscale)
		screenGroup:insert(lock2)
		ee2:removeEventListener("tap",goToee2)
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