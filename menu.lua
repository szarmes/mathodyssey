---------------------------------------------------------------------------------
--
-- menu.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()


local buttonXOffset = 100


---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY


function goToPlay()


	storyboard.gotoScene("play")
end


function goToTutorials()
	storyboard.gotoScene("howtoplay")
end

function goToSettings()
	storyboard.gotoScene("settings")
end


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view

	bg = display.newImage("images/bg.png", centerX,centerY+(30*yscale))
	bg:scale(0.8*xscale,0.8*yscale)
	screenGroup:insert(bg)

	play = display.newImage("images/play.png", centerX-200*xscale ,centerY)
	play:scale(0.7*xscale,0.6*yscale)
	play:addEventListener("tap",goToPlay)
	play.anchorX = 0
	screenGroup:insert(play)

	howtoplay = display.newImage("images/tutorial.png", centerX - 240*xscale ,centerY+70*yscale)
	howtoplay:scale(0.6*xscale,0.6*yscale)
	howtoplay:addEventListener("tap",goToTutorials)
	howtoplay.anchorX = 0
	screenGroup:insert(howtoplay)


	create = display.newImage("images/create.png", centerX+240*xscale ,centerY)
	create:scale(0.6*xscale,0.6*yscale)
	create.anchorX = 1
	screenGroup:insert(create)

	about = display.newImage("images/about.png", centerX+225*xscale ,centerY+70*yscale)
	about:scale(0.6*xscale,0.6*yscale)
	about.anchorX = 1
	screenGroup:insert(about)

	

	title = display.newImage("images/splash.png", centerX,centerY-100*yscale)
	title:scale(0.8*xscale,0.8*yscale)
	screenGroup:insert(title)

	settings = display.newImage("images/settings.png",20*xscale,centerY+130*yscale)
	settings:scale(0.6*xscale,0.6*yscale)
	settings:addEventListener("tap",goToSettings)
	screenGroup:insert(settings)

	audio.play(bgmusic,{loops = -1,channel=1})

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