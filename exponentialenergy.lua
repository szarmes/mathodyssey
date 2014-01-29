---------------------------------------------------------------------------------
--
-- exponentialenergy.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
require "dbFile"
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local first = true
local round = -1
questionCount = 0
local instructions = "Welcome to Exponential Energy! In this level, you're required to determine the exponent of the equation."
local instructions1 = "Recall that an exponent is positioned near the top right of a number, and represents how many times the number appears in a repeated multiplication."
local instructions2 = "Note that when an exponent of any number is 0, the new value of that number is always 1. And when an exponent of a number is 1, the value of that number does not change."
local insturcionts3
local exponent
local number
local equals

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	display.setDefault( "background", 1, 1, 1 )
	if (first) then
		myText = display.newText( instructions, centerX, centerY+120,500,200, "Comic Relief", 20 )
		myText:setFillColor(0)
		screenGroup:insert(myText)
	end


	
	--displayNumbers(screenGroup)
	--background = display.newImage("images/cat.jpg",centerX,centerY)
	--Runtime:addEventListener("touch",moveCatListener)
	--screenGroup:insert( background )

	home = display.newImage("images/home.png",display.contentWidth,30)
	home:scale(0.3,0.3)
	home:addEventListener("tap", goHome)
	screenGroup:insert(home)

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	if questionCount>=3 then
		round = -1
		questionCount = 0
		storyboard.gotoScene("showeescore" )
	end

	if round == -1 then
		for row in db:nrows("SELECT * FROM eeScore ORDER BY id DESC") do
		  round = row.round+1
		  break
		end
	end

	local screenGroup = self.view
	generateAnswers()
	generateAnswerText()
	displayNumbers(screenGroup)
	instructions3 = "In this case the exponent is "..exponent..", since  "..number.. " appears in this repeated multiplication of itself "..exponent.." times."	
	if exponent == 0 then
		number = 1
		instructions3 = "In this case the exponent is "..exponent..", since any number with an exponent of 0 equals 1."
	end
	if exponent == 1 then
		number = math.random(2,5)
		instructions3 = "In this case the exponent is "..exponent..", since numbers with an exponent of 1 do not change."
	end
	newQuestion(screenGroup)
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	
end
function goHome()
	round = -1
	questionCount = 0
	storyboard.gotoScene( "menu")
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

	pointer = display.newImage("images/exppointer.png",centerX+qL.width+50,centerY-70)
	screenGroup:insert(pointer)

	local myFunction = function() makeSecondDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200, centerY+140)
	continue:scale(0.3,0.3)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
	local zoomOutFunction = function() timer2 = timer.performWithDelay(50,zoomQout,4) end
	local zoomInFunction = function() timer3 = timer.performWithDelay(50,zoomQin,5) 
	timer4 = timer.performWithDelay(500,zoomOutFunction) end 
	zoomInFunction()
	timer1 = timer.performWithDelay(1000,zoomInFunction,2)
	--showAnswer(screenGroup)
end
function makeSecondDisappear(n)
	local screenGroup = n
	cancelZoomTimers()
	screenGroup:remove(questionMarkText)
	questionMarkText =display.newText( "?", qL.x+qL.width/2 + 5, centerY-50, "Comic Relief", 24 )
	screenGroup:insert(questionMarkText)
	screenGroup:remove(myText)
	screenGroup:remove(continue)
	screenGroup:remove(pointer)
	qL:setFillColor(0,0,0,0)
	qR:setFillColor(0,0,0,0)
	questionMarkText:setFillColor(0,0,0,0)

	myText = display.newText( instructions2, centerX, centerY+120,500,200, "Comic Relief", 20 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	zeroLeft =display.newText( "Number", centerX-70, centerY-80, "Comic Relief", 30 )
	zeroLeft:setFillColor(0)
	zeroQuestionMark =display.newText( "0", zeroLeft.x+zeroLeft.width/2 + 5, centerY-90, "Comic Relief", 24 )
	zeroQuestionMark:setFillColor(0)
	zeroRight = display.newText( " = 1", centerX-70+zeroLeft.width/2 + 30, centerY-80, "Comic Relief", 30 )
	zeroRight:setFillColor(0)

	screenGroup:insert(zeroLeft)
	screenGroup:insert(zeroQuestionMark)
	screenGroup:insert(zeroRight)

	oneLeft =display.newText( "Number", centerX-100, centerY-20, "Comic Relief", 30 )
	oneLeft:setFillColor(0)
	oneQuestionMark =display.newText( "1", oneLeft.x+oneLeft.width/2 + 5, centerY-30, "Comic Relief", 24 )
	oneQuestionMark:setFillColor(0)
	oneRight = display.newText( " = Number", centerX-100+oneLeft.width/2 + 80, centerY-20, "Comic Relief", 30 )
	oneRight:setFillColor(0)

	screenGroup:insert(oneLeft)
	screenGroup:insert(oneQuestionMark)
	screenGroup:insert(oneRight)

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

	screenGroup:remove(oneLeft)
	screenGroup:remove(oneQuestionMark)
	screenGroup:remove(oneRight)
	screenGroup:remove(zeroLeft)
	screenGroup:remove(zeroQuestionMark)
	screenGroup:remove(zeroRight)
	screenGroup:remove(questionMarkText)

	qL:setFillColor(0)
	qR:setFillColor(0)

	questionMarkText =display.newText( exponent, qL.x+qL.width/2 + 5, centerY-50, "Comic Relief", 24 )
	questionMarkText:setFillColor(0)
	screenGroup:insert(questionMarkText)




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
	number = math.random(2,10)
	exponent = math.random(0,3)
	if exponent == 0 then
		number = 1
	elseif exponent == 1 then
		number = number + 1
	end
	equals = number
	if exponent == 0 then
		equals = math.random(1, 20)
	end
	
end

function showChoices(n)
	local screenGroup = n
	startTime = system.getTimer()
	questionText =display.newText( "What is the exponent?", centerX, centerY+120,500,200, "Comic Relief", 20 )
	questionText:setFillColor(0)
	screenGroup:insert(questionText)
	
	a={75,200,320,450}
	b = {}
	count = 4

	while (count>0) do --randomize the array of x values
		local r = math.random(1,count)
		b[count] = a[r]
		table.remove(a, r)
		count=count-1
	end
	
	answer = display.newText(exponent,b[1],centerY+100, 125,0, "Comic Relief", 36)
	answer:setFillColor(0)
	local function listener()
		correctResponseListener(screenGroup)
	end
	answer:addEventListener("tap", listener)
	screenGroup:insert(answer)

	answer1 = nil
	answer1 = display.newText(answer1Text,b[2],centerY+100,125,0, "Comic Relief", 36)
	answer1:setFillColor(0,0,0)
	local function listener1()
		incorrectResponseListener1(screenGroup)
	end
	answer1:addEventListener("tap", listener1)
	screenGroup:insert(answer1)

	answer2 = nil
	answer2 = display.newText(answer2Text,b[3],centerY+100,125,0, "Comic Relief", 36)
	answer2:setFillColor(0,0,0)
	local function listener2()
		incorrectResponseListener2(screenGroup)
	end
	answer2:addEventListener("tap", listener2)
	screenGroup:insert(answer2)

	answer3 = nil
	answer3 = display.newText(answer3Text,b[4],centerY+100,125,0, "Comic Relief", 36)
	answer3:setFillColor(0,0,0)
	local function listener3()
		incorrectResponseListener3(screenGroup)
	end
	answer3:addEventListener("tap", listener3)
	screenGroup:insert(answer3)


end

function generateAnswerText()

	if exponent == 3 then
		answer1Text = 2
		answer2Text = 1
		answer3Text = 0
	end
	if exponent == 2 then
		answer1Text = 3
		answer2Text = 1
		answer3Text = 0
	end
	if exponent == 1 then
		answer1Text = 2
		answer2Text = 3
		answer3Text = 0
	end
	if exponent == 0 then
		answer1Text = 2
		answer2Text = 3
		answer3Text = 1
	end

end

function displayNumbers(n)
	local screenGroup = n
	qLtemp = display.newText(equals,-100,-100,"Comic Relief",30)
	screenGroup:insert(qLtemp)

	qL = display.newText(equals,centerX-qLtemp.width-20,centerY-40,"Comic Relief",30)
	if exponent==3 then
		qR =display.newText( " = "..number.."x"..number.."x"..number, centerX+qL.width/2 + 5, centerY-40, "Comic Relief", 30 )
	elseif exponent==2 then
		qR =display.newText( " = "..number.."x"..number, centerX+qL.width/2 + 25, centerY-40, "Comic Relief", 30 )
	else
		qR =display.newText( " = "..number, centerX+qL.width/2 + 25, centerY-40, "Comic Relief", 30 )
	end
	questionMarkText =display.newText( "?", qL.x+qL.width/2 + 5, centerY-50, "Comic Relief", 24 )
	if first == false then
		solution = display.newText(" = "..number ^ exponent, centerX + qL.width/2 +25 + qR.width, centerY-40, "Comic Relief", 30)
		solution:setFillColor(0)
		screenGroup:insert(solution)
	end
	qL:setFillColor(0)
	qR:setFillColor(0)
	questionMarkText:setFillColor(0)
	screenGroup:insert(questionMarkText)
	screenGroup:insert(qL)
	screenGroup:insert(qR)
	
end

function correctResponseListener()
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	--storeEE1(1,totalTime,exponent,exponent,nil,nil,round)
	questionCount = questionCount + 1
	storyboard.purgeScene("exponentialenergy")
	storyboard.gotoScene("goodjob")
end

function incorrectResponseListener1(n)
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	questionCount = questionCount + 1
	--storeEE1(0,totalTime,exponent,answer1Text,nil,nil,round)
	answer1:setFillColor(1,0,0)
	storyboard.purgeScene("exponentialenergy")
	storyboard.gotoScene("tryagain")
end

function incorrectResponseListener2(n)
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	questionCount = questionCount + 1
	--storeEE1(0,totalTime,exponent,answer2Text,nil,nil,round)
	answer2:setFillColor(1,0,0)

	storyboard.purgeScene("exponentialenergy")
	storyboard.gotoScene("tryagain")
end

function incorrectResponseListener3(n)
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	questionCount = questionCount + 1
	--storeEE1(0,totalTime,exponent,answer3Text,nil,nil,round)
	answer3:setFillColor(1,0,0)
	storyboard.purgeScene("exponentialenergy")
	storyboard.gotoScene("tryagain")
end

function zoomQin()
	questionMarkText:scale(1.2,1.2)
end
function zoomQout()
	questionMarkText:scale(0.8,0.8)
end

function cancelZoomTimers()
	if timer1~=nil then
		timer.cancel(timer1)
	end
	if timer2~=nil then
		timer.cancel(timer2)
	end
	if timer3~=nil then
		timer.cancel(timer3)
	end
	if timer4~=nil then
		timer.cancel(timer4)
	end

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