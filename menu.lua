---------------------------------------------------------------------------------
--
-- menu.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()


local buttonXOffset = 130


---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY


function goToPlay()
	storyboard.gotoScene("play")
end


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view

	play = display.newImage("images/play.png", centerX+buttonXOffset,centerY-100)
	play:scale(0.7,0.7)
	play:addEventListener("tap",goToPlay)
	screenGroup:insert(play)

	about = display.newImage("images/about.png", centerX+buttonXOffset,centerY-30)
	about:scale(0.6,0.6)
	screenGroup:insert(about)

	create = display.newImage("images/create.png", centerX+buttonXOffset,centerY+40)
	create:scale(0.6,0.6)
	screenGroup:insert(create)

	settings = display.newImage("images/settings.png", centerX+buttonXOffset,centerY+110)
	settings:scale(0.6,0.6)
	screenGroup:insert(settings)

	title = display.newImage("images/splash.png", centerX-buttonXOffset,centerY-100)
	title:scale(0.3,0.3)
	screenGroup:insert(title)

	--background = display.newImage("images/cat.jpg",centerX,centerY)
	--Runtime:addEventListener("touch",moveCatListener)
	--screenGroup:insert( background )

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