---------------------------------------------------------------------------------
--
-- goodjob.lua
--This scene will flash "Good Job" then return to the previous scene
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

local function continue()
	storyboard.purgeAll()
	storyboard.gotoScene( storyboard.getPrevious() )
end



-- Called when the scene's view does not exist:
function scene:createScene( event )
	storyboard.purgeScene("menu")
	storyboard.reloadScene()
	local screenGroup = self.view
	
	bg = display.newImage("images/bg.png", centerX*xscale,centerY+30*yscale)
	bg:scale(0.8*xscale,0.8*yscale)
	screenGroup:insert(bg)

	bubble = display.newImage("images/bubble.png", centerX-20*xscale,centerY)
	bubble:scale(0.8*xscale,1*yscale)
	bubble.alpha = 0.7
	screenGroup:insert(bubble)

	home = display.newImage("images/home.png",display.contentWidth-20*xscale,22*yscale)
	home:scale(0.3*xscale,0.3*yscale)
	home:addEventListener("tap", goHome)
	screenGroup:insert(home)

	showcredits(screenGroup)
	
end


function goHome()
	storyboard.purgeScene("credits")
	storyboard.gotoScene("menu")
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



function showcredits(n)
	local screenGroup = n

	myText = display.newText( "Developers: Matthew Bojey & Duncan Szarmes\nGraphics: Matthew Bojey, Chris Chanin, & Duncan Szarmes\nNarrator: Nyomi Wolfe\nComposer: Tate Kindrick \nText: textcraft.net", centerX, centerY,1000*xscale,400*yscale,"Comic Relief",32)
	myText:setFillColor(0)
	myText:scale(0.5*xscale,0.5*yscale)
	screenGroup:insert(myText)
	

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