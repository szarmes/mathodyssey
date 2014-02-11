---------------------------------------------------------------------------------
--
-- exponentialenergyhard.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
storyboard.purgeAll()
require "dbFile"
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY
first = true
local round = -1
questionCount = 0
local instructions = "In this next area, you will be required to find the multiplication statement that represents the exponent."
local instructions1 = "Remember, exponents represent how many times a number appears in a repeated multiplication of itself."
local instructions2
local instructions3 = "Watch your step, and stay focused. You're our only hope."
local exponent
local number
local equals

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	storyboard.purgeScene("exponentialenergy")
	bg = display.newImage("images/eebg.png", centerX,centerY+30*yscale)
	bg:scale(0.8*xscale,0.8*yscale)
	screenGroup:insert(bg)
	if (first) then

		bubble = display.newImage("images/bubble.png", centerX-20*xscale,centerY+100*yscale)
		bubble:scale(0.74*xscale,0.43*yscale)
		bubble.alpha = 0.7
		screenGroup:insert(bubble)
		dog = display.newImage(companionText, centerX-260*xscale, centerY+118*yscale)
		dog:scale(0.2*xscale, 0.2*yscale)
		dog:rotate(30)
		screenGroup:insert(dog)
		myText = display.newText( instructions, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
		myText:setFillColor(0)
		screenGroup:insert(myText)
	end


	
	--ee1displayNumbers(screenGroup)
	--background = display.newImage("images/cat.jpg",centerX,centerY)
	--Runtime:addEventListener("touch",moveCatListener)
	--screenGroup:insert( background )

	home = display.newImage("images/home.png",display.contentWidth-20*xscale,22*yscale)
	home:scale(0.3*xscale,0.3*yscale)
	home:addEventListener("tap", ee1goHome)
	screenGroup:insert(home)

	refreshbutton = display.newImage("images/refresh.png",display.contentWidth-20*xscale,70*yscale)
	refreshbutton:scale(0.4*xscale,0.4*yscale)
	refreshbutton:addEventListener("tap",refresh)
	screenGroup:insert(refreshbutton)

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
		ee1generateAnswers()
		ee1generateAnswerText()
		ee1displayNumbers(screenGroup)
		numberText = ""..number
		numcount = 1
		while numcount<exponent do
			numberText = numberText.."x"..number
			numcount = numcount + 1
		end
		instructions2 = "In this case, the correct equation is "..numberText..", since  "..exponent.. " is the exponent."	
		ee1newQuestion(screenGroup)
	end
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	
end
function ee1goHome()
	first = true
	round = -1
	questionCount = 0
	storyboard.purgeScene("exponentialenergy1")
	storyboard.gotoScene( "menu")
end

function ee1newQuestion(n)
	local screenGroup = n

	if (first) then
		continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
		continue:scale(0.3*xscale,0.3*yscale)
		local myFunction = function() ee1makeFirstDisappear(screenGroup) end
		continue:addEventListener("tap", myFunction)
		screenGroup:insert(continue)
	else 
		ee1showChoices(screenGroup)
	end

end

function ee1makeFirstDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( instructions1, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 16 )
	myText:setFillColor(0)
	screenGroup:insert(myText)
	local myFunction = function() ee1makeSecondDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)
	screenGroup:insert(continue)
	continue:addEventListener("tap", myFunction)
	--showAnswer(screenGroup)
end
function ee1makeSecondDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)
	screenGroup:remove(valueText)
	myText = display.newText( instructions2, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 16 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	solution = display.newText(answerText, centerX+130*xscale, centerY-40*yscale, "Comic Relief", 30)
	solution:setFillColor(0)
	screenGroup:insert(solution)

	local myFunction = function() ee1makeThirdDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
	--showAnswer(screenGroup)
end

function ee1makeThirdDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( instructions3, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	first = false
	go = display.newImage("images/go.png", centerX+200*xscale, centerY+120*yscale)
	go:scale(0.5*xscale,0.5*yscale)
	go:addEventListener("tap", ee1newSceneListener)
	screenGroup:insert(go)

	--showAnswer(screenGroup)
end

function ee1newSceneListener()
	storyboard.purgeScene("exponentialenergy1")
	storyboard.reloadScene()
end

function ee1generateAnswers()
	number = math.random(2,10)
	exponent = math.random(1,4)
	if exponent == 1 then
		number = number + 1
	end
	equals = number

	
end

function ee1showChoices(n)
	local screenGroup = n
	startTime = system.getTimer()
	questionText =display.newText( "What is the correct equation?", centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
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
	
	answer = display.newText(answerText,b[1],centerY+100*yscale, 125*xscale,0, "Comic Relief", 20)
	answer:setFillColor(0)
	function ee1listener()
		ee1correctResponseListener(screenGroup)
	end
	answer:addEventListener("tap", ee1listener)
	screenGroup:insert(answer)

	answer1 = nil
	answer1 = display.newText(answer1Text,b[2],centerY+100*yscale,125*xscale,0, "Comic Relief", 20)
	answer1:setFillColor(0,0,0)
	local function listener1()
		ee1incorrectResponseListener1(screenGroup)
	end
	answer1:addEventListener("tap", listener1)
	screenGroup:insert(answer1)

	answer2 = nil
	answer2 = display.newText(answer2Text,b[3],centerY+100*yscale,125*xscale,0, "Comic Relief", 20)
	answer2:setFillColor(0,0,0)
	local function listener2()
		ee1incorrectResponseListener2(screenGroup)
	end
	answer2:addEventListener("tap", listener2)
	screenGroup:insert(answer2)

	answer3 = nil
	answer3 = display.newText(answer3Text,b[4],centerY+100*yscale,125*xscale,0, "Comic Relief", 20)
	answer3:setFillColor(0,0,0)
	local function listener3()
		ee1incorrectResponseListener3(screenGroup)
	end
	answer3:addEventListener("tap", listener3)
	screenGroup:insert(answer3)

end

function ee1generateAnswerText()

	if exponent == 4 then
		answerText = number.."x"..number.."x"..number.."x"..number
		answer1Text = number.."x"..number.."x"..number
		answer2Text = number.."x"..number
		answer3Text = number
	end
	if exponent == 3 then
		answer1Text = number.."x"..number.."x"..number.."x"..number
		answerText = number.."x"..number.."x"..number
		answer2Text = number.."x"..number
		answer3Text = number
	end
	if exponent == 2 then
		answer2Text = number.."x"..number.."x"..number.."x"..number
		answer1Text = number.."x"..number.."x"..number
		answerText = number.."x"..number
		answer3Text = number
	end
	if exponent == 1 then
		answer3Text = number.."x"..number.."x"..number.."x"..number
		answer1Text = number.."x"..number.."x"..number
		answer2Text = number.."x"..number
		answerText = number
	end

end

function ee1displayNumbers(n)
	local screenGroup = n
	qLtemp = display.newText(equals,-100,-100,"Comic Relief",30)
	screenGroup:insert(qLtemp)

	qR =display.newText( " = ", centerX, centerY-40*yscale, "Comic Relief", 30 )
	

	qL = display.newText(equals,centerX-(qLtemp.width+100)*xscale,centerY-40*yscale,"Comic Relief",30)
	questionMarkText =display.newText( exponent, (qL.x+qL.width/2)+5*xscale, centerY-50*yscale, "Comic Relief", 24 )
	valueText = display.newText( "?", centerX+100*xscale, centerY-40*yscale, "Comic Relief", 24 )
	valueText:setFillColor(0)
	qL:setFillColor(0)
	qR:setFillColor(0)
	questionMarkText:setFillColor(0)
	screenGroup:insert(questionMarkText)
	screenGroup:insert(qL)
	screenGroup:insert(qR)
	screenGroup:insert(valueText)	
end

function ee1correctResponseListener(n)
	local screenGroup = n
	screenGroup:remove(valueText)
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	storeEE1(1,totalTime,answerText,answerText,round,2)
	questionCount = questionCount + 1

	solution = display.newText(answerText, centerX+130*xscale, centerY-40*yscale, "Comic Relief", 30)
	solution:setFillColor(0)
	screenGroup:insert(solution)

	ee1removeAnswers(screenGroup)
	local reward = display.newText("Good Job!", centerX+70*xscale,centerY+50,300,0,"Comic Relief", 30)
	reward:setFillColor(0)
	screenGroup:insert(reward)

	local myFunction = function() ee1newSceneListener() end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)

end


function ee1incorrectResponseListener1(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	questionCount = questionCount + 1
	storeEE1(0,totalTime,answerText,answer1Text,round,2)
	ee1wrongAnswer(screenGroup)
	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end

function ee1incorrectResponseListener2(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	questionCount = questionCount + 1
	storeEE1(0,totalTime,answerText,answer2Text,round,2)
	ee1wrongAnswer(screenGroup)

	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end

function ee1incorrectResponseListener3(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	questionCount = questionCount + 1
	storeEE1(0,totalTime,answerText,answer3Text,round,2)
	ee1wrongAnswer(screenGroup)
	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end


function ee1removeAnswers(n)
	local screenGroup = n
	--screenGroup:remove(answer)
	screenGroup:remove(valueText)
	screenGroup:remove(answer1)
	screenGroup:remove(answer2)
	screenGroup:remove(answer3)
	screenGroup:remove(questionText)
	answer:removeEventListener("tap",ee1listener)
	

end

function ee1wrongAnswer(n)
	local screenGroup = n
	ee1removeAnswers(screenGroup)

	solution = display.newText(answerText, centerX+130*xscale, centerY-40*yscale, "Comic Relief", 30)
	solution:setFillColor(0)
	screenGroup:insert(solution)

	questionText =display.newText( "Oops, the correct answer was", centerX, centerY+140*yscale,450*xscale,200*yscale, "Comic Relief", 18 )
	questionText:setFillColor(0)
	screenGroup:insert(questionText)

	local myFunction = function() ee1newSceneListener() end
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