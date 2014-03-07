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

local function goTobb() --play timetrials
	storyboard.purgeAll()
	storyboard.gotoScene("balanceboard")
end

local function goTobb1() --play timetrials
	storyboard.purgeAll()
	storyboard.gotoScene("balanceboard1")
end

local function goTobb2() --play timetrials
	storyboard.purgeAll()
	storyboard.gotoScene("balanceboard2")
end


local function goHome() --go back to the menu
	storyboard.gotoScene("play")
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view

	bg = display.newImage("images/bbbg.png", centerX,centerY+30*yscale)
	bg:scale(0.8*xscale,0.8*yscale)
	screenGroup:insert(bg)

	bb = display.newImage("images/incomplete.png", centerX-200*xscale,centerY-120*yscale)
	bb:scale(0.5*xscale,0.5*yscale)
	bb:addEventListener("tap", goTobb)
	bb.anchorX = 0
	screenGroup:insert(bb)

	bb1 = display.newImage("images/incomplete.png", centerX+10*xscale,centerY+30*yscale)
	bb1:scale(0.5*xscale,0.5*yscale)
	bb1:addEventListener("tap", goTobb1)
	bb1.anchorX = 0
	screenGroup:insert(bb1)

	bb2 = display.newImage("images/incomplete.png", centerX+85*xscale,centerY-80*yscale)
	bb2:scale(0.5*xscale,0.5*yscale)
	bb2:addEventListener("tap", goTobb2)
	bb2.anchorX = 0
	screenGroup:insert(bb2)
	
	home = display.newImage("images/home.png",display.contentWidth-20*xscale,22*yscale)
	home:scale(0.3*xscale,0.3*yscale)
	home:addEventListener("tap", goHome)
	screenGroup:insert(home)

	bbLockLocations(screenGroup)
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

function bbLockLocations(n)
	local screenGroup = n
	local lock1check = false
	local lock2check = false
	for row in db:nrows("SELECT * FROM mapUnlocks;") do
		if row.location == "bb1" then
			lock1check = true
		end
		if row.location == "bb2" then
			lock2check = true
		end
	end
	if lock1check==false then 
		lock1 = display.newImage("images/lock.png",bb1.x+30*xscale,bb1.y+15*yscale)
		lock1:scale(0.08*xscale,0.08*yscale)
		screenGroup:insert(lock1)
		bb1:removeEventListener("tap",goTobb1)
	end

	if lock2check==false then 
		lock2 = display.newImage("images/lock.png",bb2.x+30*xscale,bb2.y+15*yscale)
		lock2:scale(0.08*xscale,0.08*yscale)
		screenGroup:insert(lock2)
		bb2:removeEventListener("tap",goTobb2)
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