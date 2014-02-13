---------------------------------------------------------------------------------
--
-- firstTime.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
require "dbFile"


local buttonXOffset = 100
local companionText = ""

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY


function goToStory(n)
	storyboard.gotoScene("howtoplay")
end

function firstyes()
storeFirst(1)
goToStory()
end

function firstno()
storeFirst(0)
goToStory()
end

function storeDog(n)
	local screenGroup = n
	storeCompanion(0)
	companionText = "images/dog.png"
	consent(screenGroup)
end

function storeAstro(n)
	local screenGroup = n
	storeCompanion(1)
	companionText = "images/astronaut.png"
	consent(screenGroup)
end


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view

	bg = display.newImage("images/bg.png", centerX*xscale,centerY+30*yscale)
	bg:scale(0.8*xscale,0.8*yscale)
	screenGroup:insert(bg)

	bubble = display.newImage("images/bubble.png", centerX-20*xscale,centerY)
	bubble:scale(0.8*xscale,0.5*yscale)
	bubble.alpha = 0.7
	screenGroup:insert(bubble)


	chooseAnimal(screenGroup)
	--audio.play(bgmusic,{loops = -1,channel=1})

	--background = display.newImage("images/cat.jpg",centerX,centerY)
	--Runtime:addEventListener("touch",moveCatListener)
	--screenGroup:insert( background )

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local screenGroup = self.view	
	first = true
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	
end


function consent(n)
	local screenGroup = n 

	screenGroup:remove(dog)
	screenGroup:remove(astronaut)
	screenGroup:remove(prompt)

	dog = display.newImage(companionText, centerX-240*xscale, centerY+118*yscale)
	dog:scale(0.2*xscale, 0.2*yscale)
	--dog:rotate(30)
	screenGroup:insert(dog)

	local promptText = "Will you allow us to use your game data for educational purposes?"

	prompt = display.newText(promptText, centerX,centerY+30*yscale, 400*xscale,200*yscale, "Comic Relief",20 )
	prompt:setFillColor(0)
	screenGroup:insert(prompt)

	local yes = display.newText("YES", centerX+60*xscale,centerY+30*yscale, "Comic Relief",24 )
	yes:setFillColor(0)
	yes:addEventListener("tap",firstyes)
	screenGroup:insert(yes)
	local no = display.newText("NO", centerX-60*xscale,centerY+30*yscale, "Comic Relief",24 )
	no:setFillColor(0)
	no:addEventListener("tap",firstno)
	screenGroup:insert(no)

end

function chooseAnimal(n)
	local screenGroup = n 

	bubble:scale(1,1.7)

	dog = display.newImage("images/dog.png", centerX+140*xscale, centerY+30*yscale)
	dog:scale(0.2*xscale, 0.2*yscale)
	local myFunction = function()
		storeDog(screenGroup)
	end
	dog:addEventListener("tap",myFunction)
	screenGroup:insert(dog)

	astronaut = display.newImage("images/astronaut.png", centerX-140*xscale, centerY+30*yscale)
	astronaut:scale(0.2*xscale, 0.2*yscale)
	local myFunction1 = function()
		storeAstro(screenGroup)
	end
	astronaut:addEventListener("tap",myFunction1)
	screenGroup:insert(astronaut)

	local promptText = "Choose Your Companion"

	prompt = display.newText(promptText, centerX,centerY, 400*xscale,200*yscale, "Comic Relief",20 )
	prompt:setFillColor(0)
	screenGroup:insert(prompt)


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