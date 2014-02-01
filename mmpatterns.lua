---------------------------------------------------------------------------------
--
-- menu.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
require "dbFile"


local buttonXOffset = 100


---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY
first = true
local patterninstructions = "On this planet you will be learning about multiplication which is just repeated addition."
local patterninstructions1 = "Your first task will be to find patterns in groups of numbers."
local patterninstructions2 = "You will see groups of numbers like these,"
local patterninstructions3 = "and your job will be to select the numbers that form a pattern."
local patterninstructions4 = "In this example you would select every fourth number, like this."
local multiple
local function patternsgoHome()
	first = true
	round = -1
	mmcorrectCount = 0
	storyboard.gotoScene( "menu" )
end


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	bg = display.newImage("images/lavabg.png", centerX,centerY+(30*yscale))
	bg:scale(0.8*xscale,0.8*yscale)
	screenGroup:insert(bg)
	if (first) then
		bubble = display.newImage("images/bubble.png", centerX-20*xscale,centerY+100*yscale)
		bubble:scale(0.74*xscale,0.43*yscale)
		bubble.alpha = 0.7
		screenGroup:insert(bubble)

		dog = display.newImage("images/astronaut.png", centerX-260*xscale, centerY+118*yscale)
		dog:scale(0.2*xscale, 0.2*yscale)
		dog:rotate(30)
		screenGroup:insert(dog)

		myText = display.newText(patterninstructions, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
		myText:setFillColor(0)
		screenGroup:insert(myText)
	end
	patternnewQuestion(screenGroup)
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

function patternnewQuestion(n) -- this will make a new question
	local screenGroup = n
	if (first) then
		local myfunction = function() patternmakeFirstDisappear(screenGroup) end
		continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
		continue:scale(0.3*xscale,0.3*yscale)
		continue:addEventListener("tap", myfunction)
		screenGroup:insert(continue)
	else 
		--DO SOME STUFF HERE ABOUT MAKING THE GAME WORK
	end
end

function patternShowNumbers(n)
	local screenGroup = n
	multiple = math.random(10)
	numbers = {}
	for j = 0 , 5, 1 do
		for i =1, 15, 1  do
			numbers[(15*j)+i] = display.newText((15*j)+i, ((i*30)-25)*xscale, (10+(j*30))*yscale, "Comic Relief", 16)
			screenGroup:insert(numbers[(15*j)+i])
		end
	end
end

function patternShowMultiple(n)
	local screenGroup = n
	multipleText = display.newText(multiple, 475*xscale, 90*yscale, "Comic Relief", 36)
	screenGroup:insert(multipleText)
end

function patternShowAnswer(n)
	local screenGroup = n
	for j = 0 , 5, 1 do
		for i =1, 15, 1  do
			if (i+(j*15))%multiple == 0 then
				screenGroup:remove(numbers[(15*j)+i])
				numbers[(15*j)+i] = display.newText((15*j)+i, ((i*30)-25)*xscale, (10+(j*30))*yscale, "Comic Relief", 16)
				numbers[(15*j)+i]:setFillColor(0,0,1)
				screenGroup:insert(numbers[(15*j)+i])
			end
		end
	end
end

function patternmakeFirstDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText(patterninstructions1, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myfunction = function() patternmakeSecondDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myfunction)
	screenGroup:insert(continue)
end

function patternmakeSecondDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText(patterninstructions2, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myfunction = function() patternmakeThirdDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myfunction)
	screenGroup:insert(continue)
	patternShowNumbers(screenGroup)
	multiple = 4
	patternShowMultiple(screenGroup)
end

function patternmakeThirdDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText(patterninstructions3, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myfunction = function() patternmakeFourthDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myfunction)
	screenGroup:insert(continue)

end

function patternmakeFourthDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText(patterninstructions4, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	first = false
	go = display.newImage("images/go.png", centerX+200*xscale, centerY+120*yscale)
	go:scale(0.5*xscale,0.5*yscale)
	go:addEventListener("tap", patternnewSceneListener)
	screenGroup:insert(go)

	patternShowAnswer(screenGroup)
end

function patternnewSceneListener()
	storyboard.purgeScene("mmpatterns")
	storyboard.reloadScene()
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