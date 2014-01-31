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
	bubble:scale(0.8*xscale,0.5*yscale)
	bubble.alpha = 0.7
	screenGroup:insert(bubble)


	dog = display.newImage("images/astronaut.png", centerX-240*xscale, centerY+118*yscale)
	dog:scale(0.2*xscale, 0.2*yscale)
	--dog:rotate(30)
	screenGroup:insert(dog)

	home = display.newImage("images/home.png",display.contentWidth-20*xscale,22*yscale)
	home:scale(0.3*xscale,0.3*yscale)
	home:addEventListener("tap", goHome)
	screenGroup:insert(home)

	tutorial1(screenGroup)
	
end


function goHome()
	storyboard.purgeScene("howtoplay")
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



function tutorial1(n)
	local screenGroup = n

	myText = display.newImage( "images/tutorialtext1.png", centerX, centerY)
	myText:scale(0.5*xscale,0.5*yscale)
	screenGroup:insert(myText)
	local myFunction = function() 
		screenGroup:remove(myText)
		screenGroup:remove(continue)
		tutorial2(screenGroup) 
	end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)

end

function tutorial2(n)
	local screenGroup = n

	myText = display.newImage( "images/tutorialtext2.png", centerX, centerY)
	myText:scale(0.5*xscale,0.5*yscale)
	screenGroup:insert(myText)
	local myFunction = function() 
		screenGroup:remove(back)
		screenGroup:remove(continue)
		screenGroup:remove(myText)
		tutorial3(screenGroup) 
	end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)

	local myFunction1 = function()
	 screenGroup:remove(back)
	 screenGroup:remove(continue)
	 screenGroup:remove(myText)
	 tutorial1(screenGroup) 
	end
	back = display.newImage("images/continue.png", centerX+120*xscale, centerY+130*yscale)
	back:scale(-0.3*xscale,0.3*yscale)

	back:addEventListener("tap", myFunction1)
	screenGroup:insert(back)

end


function tutorial3(n)
	local screenGroup = n

	myText = display.newImage( "images/tutorialtext3.png", centerX, centerY)
	myText:scale(0.5*xscale,0.5*yscale)
	screenGroup:insert(myText)

	local myFunction1 = function()
	 screenGroup:remove(back)
	 screenGroup:remove(myText)
	 tutorial2(screenGroup) 
	end
	back = display.newImage("images/continue.png", centerX+120*xscale, centerY+130*yscale)
	back:scale(-0.3*xscale,0.3*yscale)

	back:addEventListener("tap", myFunction1)
	screenGroup:insert(back)

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