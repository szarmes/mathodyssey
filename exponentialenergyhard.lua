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
local ee2instructions = "New orders have just come in from Star Command. You are now required to solve equations with exponents."
local ee2instructions1 = "Now that you've seen the power of exponents, you can apply multiplication and figure out the value they change a number to."
local ee2instructions2
local ee2instructions3 = "Remember, failure is not an option. We are counting on you to succeed."
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
		myText = display.newText( ee2instructions, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
		myText:setFillColor(0)
		screenGroup:insert(myText)
	end


	
	--ee2displayNumbers(screenGroup)
	--background = display.newImage("images/cat.jpg",centerX,centerY)
	--Runtime:addEventListener("touch",moveCatListener)
	--screenGroup:insert( background )

	home = display.newImage("images/home.png",display.contentWidth-20*xscale,22*yscale)
	home:scale(0.3*xscale,0.3*yscale)
	home:addEventListener("tap", ee2goHome)
	screenGroup:insert(home)

	if first==false then
		hintbutton = display.newImage(companionText,display.contentWidth-20*xscale,90*yscale)
		hintbutton:scale(-0.14*xscale,0.14*yscale)

		local function ee2hint()
			hintbutton:removeEventListener("tap",ee2hint)
			provideHint(screenGroup,ee2instructions1)
		end
		hintbutton:addEventListener("tap",ee2hint)
		screenGroup:insert(hintbutton)
	end

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
		ee2generateAnswers()
		ee2generateAnswerText()
		ee2displayNumbers(screenGroup)
		ee2instructions2 = "In this case the value is "..number^exponent..", since  "..number.. " appears in this repeated multiplication of itself "..exponent.." times."	
		if exponent == 0 then
			ee2instructions2 = "In this case the value is 1, since any number with an exponent of 0 equals 1."
		end
		if exponent == 1 then
			ee2instructions2 = "In this case the value is "..number..", since numbers with an exponent of 1 do not change."
		end
		ee2newQuestion(screenGroup)
	end
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	
end
function ee2goHome()
	first = true
	round = -1
	questionCount = 0
	storyboard.purgeScene("exponentialenergyhard")
	storyboard.gotoScene( "eeselection")
end

function ee2newQuestion(n)
	local screenGroup = n

	if (first) then
		continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
		continue:scale(0.3*xscale,0.3*yscale)
		local myFunction = function() ee2makeFirstDisappear(screenGroup) end
		continue:addEventListener("tap", myFunction)
		screenGroup:insert(continue)
	else 
		ee2showChoices(screenGroup)
	end

end

function ee2makeFirstDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( ee2instructions1, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 16 )
	myText:setFillColor(0)
	screenGroup:insert(myText)
	local myFunction = function() ee2makeSecondDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)
	screenGroup:insert(continue)
	continue:addEventListener("tap", myFunction)
	--showAnswer(screenGroup)
end
function ee2makeSecondDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)
	screenGroup:remove(valueText)
	myText = display.newText( ee2instructions2, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 16 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	solution = display.newText(answerText, centerX+110*xscale, centerY-40*yscale, "Comic Relief", 30)
	solution:setFillColor(0)
	screenGroup:insert(solution)

	local myFunction = function() ee2makeThirdDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
	--showAnswer(screenGroup)
end

function ee2makeThirdDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( ee2instructions3, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	first = false
	go = display.newImage("images/go.png", centerX+200*xscale, centerY+120*yscale)
	go:scale(0.5*xscale,0.5*yscale)
	go:addEventListener("tap", ee2newSceneListener)
	screenGroup:insert(go)

	--showAnswer(screenGroup)
end

function ee2newSceneListener()
	storyboard.purgeScene("exponentialenergyhard")
	storyboard.reloadScene()
end

function ee2generateAnswers()
	number = math.random(2,10)
	exponent = math.random(0,3)
	if exponent == 1 then
		number = number + 1
	end
	equals = number
	if exponent == 0 then
		equals = math.random(1, 20)
	end
	answerText = number^exponent
	
end

function ee2showChoices(n)
	local screenGroup = n
	startTime = system.getTimer()
	questionText =display.newText( "What is the value of this expression?", centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
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
	
	answer = display.newText(answerText,b[1],centerY+100*yscale, "Comic Relief", 30)
	answer:setFillColor(0)
	function ee2listener()
		ee2correctResponseListener(screenGroup)
	end
	answer:addEventListener("tap", ee2listener)
	screenGroup:insert(answer)

	answer1 = nil
	answer1 = display.newText(answer1Text,b[2],centerY+100*yscale, "Comic Relief", 30)
	answer1:setFillColor(0,0,0)
	local function listener1()
		ee2incorrectResponseListener1(screenGroup)
	end
	answer1:addEventListener("tap", listener1)
	screenGroup:insert(answer1)

	answer2 = nil
	answer2 = display.newText(answer2Text,b[3],centerY+100*yscale,"Comic Relief", 30)
	answer2:setFillColor(0,0,0)
	local function listener2()
		ee2incorrectResponseListener2(screenGroup)
	end
	answer2:addEventListener("tap", listener2)
	screenGroup:insert(answer2)

	answer3 = nil
	answer3 = display.newText(answer3Text,b[4],centerY+100*yscale, "Comic Relief", 30)
	answer3:setFillColor(0,0,0)
	local function listener3()
		ee2incorrectResponseListener3(screenGroup)
	end
	answer3:addEventListener("tap", listener3)
	screenGroup:insert(answer3)

end

function ee2generateAnswerText()

	if exponent == 3 then
		answer1Text = number^2
		answer2Text = number^1
		answer3Text = number^0
	end
	if exponent == 2 then
		answer1Text = number^3
		answer2Text = number^1
		answer3Text = number^0
	end
	if exponent == 1 then
		answer1Text = number^2
		answer2Text = number^3
		answer3Text = number^0
	end
	if exponent == 0 then
		answer1Text = number^2
		answer2Text = number^3
		answer3Text = number^1
	end

end

function ee2displayNumbers(n)
	local screenGroup = n
	qLtemp = display.newText(equals,-100,-100,"Comic Relief",30)
	screenGroup:insert(qLtemp)

	if exponent==3 then
		qR =display.newText( " = "..number.."x"..number.."x"..number.." =", centerX-35*xscale, centerY-40*yscale, "Comic Relief", 30 )
	elseif exponent==2 then
		qR =display.newText( " = "..number.."x"..number.." =", centerX-35*xscale, centerY-40*yscale, "Comic Relief", 30 )
	else
		qR =display.newText( " = ", centerX-40*xscale, centerY-35*yscale, "Comic Relief", 30 )
	end

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

function ee2correctResponseListener(n)
	local screenGroup = n
	screenGroup:remove(valueText)
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	storeEE2(1,totalTime,answerText,answerText,round,3)
	questionCount = questionCount + 1

	solution = display.newText(answerText, centerX+110*xscale, centerY-40*yscale, "Comic Relief", 30)
	solution:setFillColor(0)
	screenGroup:insert(solution)

	ee2removeAnswers(screenGroup)
	local reward = display.newText("Good Job!", centerX+70*xscale,centerY+50,300,0,"Comic Relief", 30)
	reward:setFillColor(0)
	screenGroup:insert(reward)

	local myFunction = function() ee2newSceneListener() end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)

end


function ee2incorrectResponseListener1(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	questionCount = questionCount + 1
	storeEE2(0,totalTime,answerText,answer1Text,round,3)
	ee2wrongAnswer(screenGroup)
	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end

function ee2incorrectResponseListener2(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	questionCount = questionCount + 1
	storeEE2(0,totalTime,answerText,answer2Text,round,3)
	ee2wrongAnswer(screenGroup)

	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end

function ee2incorrectResponseListener3(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	questionCount = questionCount + 1
	storeEE2(0,totalTime,answerText,answer3Text,round,3)
	ee2wrongAnswer(screenGroup)
	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end


function ee2removeAnswers(n)
	local screenGroup = n
	--screenGroup:remove(answer)
	screenGroup:remove(valueText)
	screenGroup:remove(answer1)
	screenGroup:remove(answer2)
	screenGroup:remove(answer3)
	screenGroup:remove(questionText)
	answer:removeEventListener("tap",ee2listener)
	

end

function ee2wrongAnswer(n)
	local screenGroup = n
	ee2removeAnswers(screenGroup)

	solution = display.newText(answerText, centerX+110*xscale, centerY-40*yscale, "Comic Relief", 30)
	solution:setFillColor(0)
	screenGroup:insert(solution)

	questionText =display.newText( "Oops, the correct answer was", centerX, centerY+140*yscale,450*xscale,200*yscale, "Comic Relief", 18 )
	questionText:setFillColor(0)
	screenGroup:insert(questionText)

	local myFunction = function() ee2newSceneListener() end
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