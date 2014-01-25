---------------------------------------------------------------------------------
--
-- timetrials.lua
--This scene is the time trial mini game
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
local instructions = "Welcome to the Time Trials! In this level, your task is to figure out the amount of time that has passed from clock 1 to clock 2, using your addition and subtraction skills!"

local function continue()
	storyboard.gotoScene( "menu", "fade", 2000 )
end


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	
	display.setDefault( "background", 1, 1, 1 )
	local myText = display.newText( instructions, centerX, centerY+140,500,200, "Komika Display", 20 )
	myText:setFillColor(0)
	screenGroup:insert(myText)
	
	--image.touch = onSceneTouch
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	--endSceneTimer = timer.performWithDelay( 1000, continue, 1 )	--after 4 seconds, go to menu
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