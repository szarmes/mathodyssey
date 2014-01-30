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
	storyboard.gotoScene("menu")
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view

	bg = display.newImage("images/bg.png", centerX,centerY+30)
	bg:scale(0.7,0.7)
	screenGroup:insert(bg)

	local tt1 = display.newImage("images/time-trials.png", -20,centerY-120)
	tt1:scale(0.3,0.3)
	tt1:addEventListener("tap", goTott1)
	tt1.anchorX = 0
	screenGroup:insert(tt1)

	local tt2 = display.newImage("images/time-trials.png", -20,centerY-90)
	tt2:scale(0.3,0.3)
	tt2:addEventListener("tap", goTott2)
	tt2.anchorX = 0
	screenGroup:insert(tt2)
	
	local tt3 = display.newImage("images/time-trials.png", -20,centerY-60)
	tt3:scale(0.3,0.3)
	tt3:addEventListener("tap", goTott3)
	tt3.anchorX = 0
	screenGroup:insert(tt3)


	home = display.newImage("images/home.png",display.contentWidth,30)
	home:scale(0.3,0.3)
	home:addEventListener("tap", goHome)
	screenGroup:insert(home)
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