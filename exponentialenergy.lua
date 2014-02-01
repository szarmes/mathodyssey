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
first = true
local round = -1
questionCount = 0
local instructions = "Welcome to Exponential Energy. On this planet your orders are to determine the exponent of the equation."
local instructions1 = "Recall that an exponent is positioned near the top right of a number, and represents how many times the number appears in a repeated multiplication."
local instructions2 = "Note that when an exponent of any number is 0, the new value of that number is always 1. And when an exponent of a number is 1, the value of that number does not change."
local instrucions3
local instructions4 = "Watch your back out there, exponents contain a lot of power."
local exponent
local number
local equals

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	bg = display.newImage("images/eebg.png", centerX,centerY+30*yscale)
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
		myText = display.newText( instructions, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
		myText:setFillColor(0)
		screenGroup:insert(myText)
	end


	
	--displayNumbers(screenGroup)
	--background = display.newImage("images/cat.jpg",centerX,centerY)
	--Runtime:addEventListener("touch",moveCatListener)
	--screenGroup:insert( background )

	home = display.newImage("images/home.png",display.contentWidth-20*xscale,22*yscale)
	home:scale(0.3*xscale,0.3*yscale)
	home:addEventListener("tap", goHome)
	screenGroup:insert(home)

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	if questionCount>=10 then
		round = -1
		questionCount = 0
		storyboard.gotoScene("showeescore", "fade", 200)
	else

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
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	
end
function goHome()
	first = true
	round = -1
	questionCount = 0
	cancelZoomTimers()
	storyboard.purgeScene("exponentialenergy")
	storyboard.gotoScene( "menu")
end

function newQuestion(n)
	local screenGroup = n

	if (first) then
		continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
		continue:scale(0.3*xscale,0.3*yscale)
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

	myText = display.newText( instructions1, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 16 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	pointer = display.newImage("images/exppointer.png",centerX+(qL.width+50)*xscale,centerY-70*yscale)
	screenGroup:insert(pointer)

	local myFunction = function() makeSecondDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

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
	questionMarkText =display.newText( "?", centerX-(qLtemp.width+20)*xscale, centerY-50*yscale, "Comic Relief", 24 )
	screenGroup:insert(questionMarkText)
	screenGroup:remove(myText)
	screenGroup:remove(continue)
	screenGroup:remove(pointer)
	qL:setFillColor(0,0,0,0)
	qR:setFillColor(0,0,0,0)
	questionMarkText:setFillColor(0,0,0,0)

	myText = display.newText( instructions2, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 16 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	zeroLeft =display.newText( "Number", centerX-70*xscale, centerY-80*yscale, "Comic Relief", 30 )
	zeroLeft:setFillColor(0)
	zeroQuestionMark =display.newText( "0", centerX, centerY-90*yscale, "Comic Relief", 24 )
	zeroQuestionMark:setFillColor(0)
	zeroRight = display.newText( " = 1", centerX+20*xscale, centerY-80*yscale, "Comic Relief", 30 )
	zeroRight:setFillColor(0)

	screenGroup:insert(zeroLeft)
	screenGroup:insert(zeroQuestionMark)
	screenGroup:insert(zeroRight)

	oneLeft =display.newText( "Number", centerX-70*xscale, centerY-20*yscale, "Comic Relief", 30 )
	oneLeft:setFillColor(0)
	oneQuestionMark =display.newText( "1", centerX, centerY-30*yscale, "Comic Relief", 24 )
	oneQuestionMark:setFillColor(0)
	oneRight = display.newText( " = Number", centerX+80*xscale, centerY-20*yscale, "Comic Relief", 30 )
	oneRight:setFillColor(0)

	screenGroup:insert(oneLeft)
	screenGroup:insert(oneQuestionMark)
	screenGroup:insert(oneRight)

	local myFunction = function() makeThirdDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

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

	questionMarkText =display.newText( exponent, centerX-(qLtemp.width+20)*xscale, centerY-50*yscale, "Comic Relief", 24 )
	questionMarkText:setFillColor(0)
	screenGroup:insert(questionMarkText)




	myText = display.newText( instructions3, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myFunction = function() makeFourthDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)

	--showAnswer(screenGroup)
end

function makeFourthDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( instructions4, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	first = false
	go = display.newImage("images/go.png", centerX+200*xscale, centerY+120*yscale)
	go:scale(0.5*xscale,0.5*yscale)
	go:addEventListener("tap", newSceneListener)
	screenGroup:insert(go)

	--showAnswer(screenGroup)
end

function newSceneListener()
	cancelZoomTimers()
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
	questionText =display.newText( "What is the exponent?", centerX, centerY+140,400*xscale,200*yscale, "Comic Relief", 18 )
	questionText:setFillColor(0)
	screenGroup:insert(questionText)
	
	a={-175,-50,75,200}
	b = {}
	count = 4

	while (count>0) do --randomize the array of x values
		local r = math.random(1,count)
		b[count] = centerX+a[r]*xscale
		table.remove(a, r)
		count=count-1
	end
	generateAnswerText()
	
	answer = display.newText(exponent,b[1],centerY+100*yscale, 125*xscale,0, "Comic Relief", 30)
	answer:setFillColor(0)
	function listener()
		correctResponseListener(screenGroup)
	end
	answer:addEventListener("tap", listener)
	screenGroup:insert(answer)

	answer1 = nil
	answer1 = display.newText(answer1Text,b[2],centerY+100*yscale,125*xscale,0, "Comic Relief", 30)
	answer1:setFillColor(0,0,0)
	local function listener1()
		incorrectResponseListener1(screenGroup)
	end
	answer1:addEventListener("tap", listener1)
	screenGroup:insert(answer1)

	answer2 = nil
	answer2 = display.newText(answer2Text,b[3],centerY+100*yscale,125*xscale,0, "Comic Relief", 30)
	answer2:setFillColor(0,0,0)
	local function listener2()
		incorrectResponseListener2(screenGroup)
	end
	answer2:addEventListener("tap", listener2)
	screenGroup:insert(answer2)

	answer3 = nil
	answer3 = display.newText(answer3Text,b[4],centerY+100*yscale,125*xscale,0, "Comic Relief", 30)
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

	qL = display.newText(equals,centerX-(qLtemp.width+40)*xscale,centerY-40*yscale,"Comic Relief",30)
	if exponent==3 then
		qR =display.newText( " = "..number.."x"..number.."x"..number, (centerX+qL.width/2 + 50)*xscale, centerY-40*yscale, "Comic Relief", 30 )
	elseif exponent==2 then
		qR =display.newText( " = "..number.."x"..number, (centerX+qL.width/2 + 25)*xscale, centerY-40*yscale, "Comic Relief", 30 )
	else
		qR =display.newText( " = "..number, (centerX+qL.width/2 + 25)*xscale, centerY-40*yscale, "Comic Relief", 30 )
	end
	questionMarkText =display.newText( "?", centerX-(qLtemp.width+20)*xscale, centerY-50*yscale, "Comic Relief", 24 )
	if first == false and exponent>1 then
		solution = display.newText(" = "..number ^ exponent, (centerX +qL.width/2 +25 + qR.width)*xscale, centerY-40*yscale, "Comic Relief", 30)
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

function correctResponseListener(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	storeEE1(1,totalTime,exponent,exponent,round,1)
	questionCount = questionCount + 1

	screenGroup:remove(questionMarkText)
	questionMarkText =display.newText( exponent, centerX-(qLtemp.width+20)*xscale, centerY-50*yscale, "Comic Relief", 24 )
	questionMarkText:setFillColor(0)
	screenGroup:insert(questionMarkText)

	local zoomOutFunction = function() timer2 = timer.performWithDelay(50,zoomQout,4) end
	local zoomInFunction = function() timer3 = timer.performWithDelay(50,zoomQin,5) 
	timer4 = timer.performWithDelay(500,zoomOutFunction) end 
	zoomInFunction()

	removeAnswers(screenGroup)
	local reward = display.newText("Good Job!", centerX+70*xscale,centerY+50,300,0,"Comic Relief", 30)
	reward:setFillColor(0)
	screenGroup:insert(reward)

	local myFunction = function() newSceneListener() end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)

	
end


function incorrectResponseListener1(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	questionCount = questionCount + 1
	storeEE1(0,totalTime,exponent,answer1Text,round,1)
	wrongAnswer(screenGroup)
	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end

function incorrectResponseListener2(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	questionCount = questionCount + 1
	storeEE1(0,totalTime,exponent,answer2Text,round,1)
	wrongAnswer(screenGroup)

	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end

function incorrectResponseListener3(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	questionCount = questionCount + 1
	storeEE1(0,totalTime,exponent,answer3Text,round,1)
	wrongAnswer(screenGroup)
	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
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
	if timer5~=nil then
		timer.cancel(timer5)
	end

end


function removeAnswers(n)
	local screenGroup = n
	--screenGroup:remove(answer)
	
	screenGroup:remove(answer1)
	screenGroup:remove(answer2)
	screenGroup:remove(answer3)
	screenGroup:remove(questionText)
	answer:removeEventListener("tap",listener)
	

end

function wrongAnswer(n)
	local screenGroup = n
	removeAnswers(screenGroup)
	questionText =display.newText( "Oops, the correct answer was", centerX, centerY+140*yscale,450*xscale,200*yscale, "Comic Relief", 18 )
	questionText:setFillColor(0)
	screenGroup:insert(questionText)

	local myFunction = function() newSceneListener() end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
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