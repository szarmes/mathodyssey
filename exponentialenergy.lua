---------------------------------------------------------------------------------
--
-- exponentialenergy.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local first = true
local round = -1
questionCount = 0
local instructions = "Welcome to Exponential Energy! In this level, you're required to either determine the exponent of the equation or solve an equation involving an exponent."
local instructions1 = "Recall that an exponent is positioned near the top right of a number, and denotes how many times the number appears in a repeated multiplication."
local instructions2 = "Note that when an exponent of a number is 0, the new value of that number is always 1. And when an exponent of a number is 1, the value of that number does not change."
local insturcionts3

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	display.setDefault( "background", 1, 1, 1 )
	if (first) then
		myText = display.newText( instructions, centerX, centerY+120,500,200, "Comic Relief", 20 )
		myText:setFillColor(0)
		screenGroup:insert(myText)
	end
	newQuestion(screenGroup)
	--displayNumbers(screenGroup)
	--background = display.newImage("images/cat.jpg",centerX,centerY)
	--Runtime:addEventListener("touch",moveCatListener)
	--screenGroup:insert( background )

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local screenGroup = self.view
	generateAnswers()
	displayNumbers(screenGroup)
	instructions3 = "In this case the exponent (represented by ?) is "..exponent..", since  "..number.. " appears in this repeated multiplication of itself "..exponent.." times."	
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	
end

function newQuestion(n)
	local screenGroup = n

	if (first) then
		continue = display.newImage("images/continue.png", centerX+200, centerY+140)
		continue:scale(0.3,0.3)
		local myFunction = function() makeFirstDisappear(screenGroup) end
		continue:addEventListener("tap", myFunction)
		screenGroup:insert(continue)
		first = false
	else 
		showChoices(screenGroup)
	end

end

function makeFirstDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( instructions1, centerX, centerY+120,500,200, "Comic Relief", 20 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myFunction = function() makeSecondDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200, centerY+140)
	continue:scale(0.3,0.3)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
	--showAnswer(screenGroup)
end
function makeSecondDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( instructions2, centerX, centerY+120,500,200, "Comic Relief", 20 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myFunction = function() makeThirdDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200, centerY+140)
	continue:scale(0.3,0.3)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
	--showAnswer(screenGroup)
end

function makeThirdDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( instructions3, centerX, centerY+120,500,200, "Comic Relief", 20 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	first = false
	go = display.newImage("images/go.png", centerX+200, centerY+120)
	go:scale(0.5,0.5)
	go:addEventListener("tap", newSceneListener)
	screenGroup:insert(go)

	--showAnswer(screenGroup)
end

function newSceneListener()
	storyboard.purgeScene("exponentialenergy")
	storyboard.reloadScene()
end

function generateAnswers()
	number = math.random(1,5)
	exponent = math.random(1,3)
end

function showChoices(n)
	local screenGroup = n
	startTime = system.getTimer()
	questionText =display.newText( "What is the exponent?", centerX, centerY+120,500,200, "Comic Relief", 20 )
	questionText:setFillColor(0)
	screenGroup:insert(questionText)
	
	a={centerX-85,centerX+40,centerX+165}
	b = {}
	count = 3

	while (count>0) do --randomize the array of x values
		local r = math.random(1,count)
		b[count] = a[r]
		table.remove(a, r)
		count=count-1
	end
	generateAnswerText()

	answer = display.newText(exponent,b[1],centerY+100, 125,0, "Comic Relief", 16)
	answer:setFillColor(0)
	answer:addEventListener("tap", correctResponseListener)
	screenGroup:insert(answer)

	answer1 = nil
	answer1 = display.newText(answer1Text,b[2],centerY+100,125,0, "Comic Relief", 16)
	answer1:setFillColor(0,0,0)
	answer1:addEventListener("tap", incorrectResponseListener1)
	screenGroup:insert(answer1)

	answer2 = nil
	answer2 = display.newText(answer2Text,b[3],centerY+100,125,0, "Comic Relief", 16)
	answer2:setFillColor(0,0,0)
	answer2:addEventListener("tap", incorrectResponseListener2)
	screenGroup:insert(answer2)


end

function generateAnswerText()

	if exponent == 3 then
		answer1Text = 2
		answer2Text = 1
	end
	if exponent == 2 then
		answer1Text = 3
		answer2Text = 1
	end
	if exponent == 1 then
		answer1Text = 2
		answer2Text = 3
	end

end

function displayNumbers(n)
	local screenGroup = n
	if exponent==3 then
		questionText =display.newText( ""..number.."x"..number.."x"..number.." = "..number.."", centerX, centerY-40, "Comic Relief", 20 )
	elseif exponent==2 then
		questionText =display.newText( ""..number.."x"..number.." = "..number.."", centerX, centerY-40, "Comic Relief", 20 )
	else
		questionText =display.newText( ""..number.." = "..number.."", centerX, centerY-40, "Comic Relief", 20 )
	end
	questionMarkText =display.newText( "?", centerX+questionText.width/2 + 5, centerY-50, "Comic Relief", 16 )
	questionText:setFillColor(0)
	questionMarkText:setFillColor(0)
	screenGroup:insert(questionMarkText)
	screenGroup:insert(questionText)
end

function correctResponseListener()
end

function incorrectResponseListener1()
	-- body
end

function incorrectResponseListener2()
	-- body
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