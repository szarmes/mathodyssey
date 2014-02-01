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
local tt1
local tt2
local tt3

local function goTott1() --play timetrials
	storyboard.purgeAll()
	storyboard.gotoScene("telltime")
end

local function goTott2() --play timetrials
	storyboard.purgeAll()
	storyboard.gotoScene("timetrials")
end

local function goTott3() --play exponential energy
	storyboard.purgeAll()
	storyboard.gotoScene( "timetrialshard" )
end

local function goHome() --go back to the menu
	storyboard.gotoScene(storyboard.getPrevious())
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view

	bg = display.newImage("images/ttmap.png", centerX,centerY+30*yscale)
	bg:scale(0.8*xscale,0.8*yscale)
	screenGroup:insert(bg)

	tt1 = display.newImage("images/incomplete.png", -10*xscale,centerY+120*yscale)
	tt1:scale(0.5*xscale,0.5*yscale)
	tt1:addEventListener("tap", goTott1)
	tt1.anchorX = 0
	screenGroup:insert(tt1)

	tt2 = display.newImage("images/incomplete.png", 160*xscale,centerY-90*yscale)
	tt2:scale(0.5*xscale,0.5*yscale)
	tt2:addEventListener("tap", goTott2)
	tt2.anchorX = 0
	screenGroup:insert(tt2)
	
	tt3 = display.newImage("images/incomplete.png", 450*xscale,centerY-10*yscale)
	tt3:scale(0.5*xscale,0.5*yscale)
	tt3:addEventListener("tap", goTott3)
	tt3.anchorX = 0
	screenGroup:insert(tt3)


	home = display.newImage("images/home.png",display.contentWidth-20*xscale,22*yscale)
	home:scale(0.3*xscale,0.3*yscale)
	home:addEventListener("tap", goHome)
	screenGroup:insert(home)

	ttLockLocations(screenGroup)
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

function ttLockLocations(n)
	local screenGroup = n
	local lock1check = false
	for row in db:nrows("SELECT * FROM mapUnlocks;") do
		if row.location == "tt2" then
			lock1check = true
			break
		end
	end
	if lock1check==false then 
		lock1 = display.newImage("images/lock.png",tt2.x+30*xscale,tt2.y+15*yscale)
		lock1:scale(0.08*xscale,0.08*yscale)
		screenGroup:insert(lock1)
		tt2:removeEventListener("tap",goTott2)
	end

	local lock2check = false
	for row in db:nrows("SELECT * FROM mapUnlocks;") do
		if row.location == "tt3" then
			lock2check = true
			break
		end
	end
	if lock2check==false then 
		lock1 = display.newImage("images/lock.png",tt3.x+30*xscale,tt3.y+15*yscale)
		lock1:scale(0.08*xscale,0.08*yscale)
		screenGroup:insert(lock1)
		tt3:removeEventListener("tap",goTott3)
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