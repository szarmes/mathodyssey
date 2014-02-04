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
local patterninstructions = "On this planet you will be learning about multiplication, which is a term for repeated addition."
local patterninstructions1 = "Your first task will be to find patterns in groups of numbers."
local patterninstructions2 = "You will be given a number and your job will be to find its multiples."
local patterninstructions3 = "You will see that the multiples of a given number form a pattern."
local patterninstructions4 = "In this example you would select every"
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
		patternShowNumbers(screenGroup)
		patternShowMultiple(screenGroup)
	end
	patternnewQuestion(screenGroup)

	home = display.newImage("images/home.png",display.contentWidth-20*xscale,22*yscale)
	home:scale(0.3*xscale,0.3*yscale)
	home:addEventListener("tap", patternsgoHome)
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
	multiple = math.random(3,10)
	numbers = {}
	bubbles = {}
	for j = 0 , 5, 1 do
		for i =1, 10, 1  do
			bubbles[(10*j)+i] = display.newImage("images/bubble.png",((i*38)+15)*xscale, (20+(j*31))*yscale)
			bubbles[(10*j)+i]:scale(0.05*xscale, 0.1*yscale)
			screenGroup:insert(bubbles[(10*j)+i])
			numbers[(10*j)+i] = display.newText((10*j)+i, ((i*38)+15)*xscale, (19+(j*31))*yscale, "Comic Relief", 16)
			numbers[(10*j)+i]:setFillColor(0)
			screenGroup:insert(numbers[(10*j)+i])
		end
	end
end

function patternShowMultiple(n)
	local screenGroup = n
	bubble = display.newImage("images/bubble.png", 475*xscale, 90*yscale)
	bubble:scale(0.1*xscale, 0.2*yscale)
	bubble:setFillColor(.83,.32,.32)
	screenGroup:insert(bubble)
	multipleText = display.newText(multiple, 477*xscale, 80*yscale, "Comic Relief", 36)
	multipleText:setFillColor(0)
	screenGroup:insert(multipleText)
end

function patternShowAnswer(n)
	local screenGroup = n
	for j = 0 , 5, 1 do
		for i =1, 10, 1  do
			if (i+(j*10))%multiple == 0 then
				screenGroup:remove(bubbles[(10*j)+i])
				bubbles[(10*j)+i] = display.newImage("images/bubble.png",((i*38)+15)*xscale, (20+(j*31))*yscale)
				bubbles[(10*j)+i]:scale(0.05*xscale, 0.1*yscale)
				bubbles[(10*j)+i]:setFillColor(.83,.32,.32)
				screenGroup:insert(bubbles[(10*j)+i])
				numbers[(10*j)+i] = display.newText((10*j)+i, ((i*38)+15)*xscale, (19+(j*31))*yscale, "Comic Relief", 16)
				numbers[(10*j)+i]:setFillColor(0)
				screenGroup:insert(numbers[(10*j)+i])
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
	if multiple == 2 then patterninstructions4 = patterninstructions4.." second number, like this."
	elseif multiple == 3 then patterninstructions4 = patterninstructions4.." third number, like this."
	elseif multiple == 4 then patterninstructions4 = patterninstructions4.." fourth number, like this."
	elseif multiple == 5 then patterninstructions4 = patterninstructions4.." fifth number, like this."
	elseif multiple == 6 then patterninstructions4 = patterninstructions4.." sixth number, like this."
	elseif multiple == 7 then patterninstructions4 = patterninstructions4.." seventh number, like this."
	elseif multiple == 8 then patterninstructions4 = patterninstructions4.." eigth number, like this."
	elseif multiple == 9 then patterninstructions4 = patterninstructions4.." ninth number, like this."
	elseif multiple == 10 then patterninstructions4 = patterninstructions4.." tenth number, like this."
	end

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