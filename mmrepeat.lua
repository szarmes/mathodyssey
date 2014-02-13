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
local repeatinstructions = "In this next area, you will be required to find the addition statement that represents the given multiplication."
local repeatinstructions1 = "Remember, multiplication represent how many times a number appears in a repeated addtion of itself."
local repeatinstructions2
local repeatinstructions3 = "Watch your step out there, it can be tricky."
local exponent
local number
local equals

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	bg = display.newImage("images/lavabg.png", centerX,centerY+30*yscale)
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
		myText = display.newText( repeatinstructions, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
		myText:setFillColor(0)
		screenGroup:insert(myText)
	end

	home = display.newImage("images/home.png",display.contentWidth-20*xscale,22*yscale)
	home:scale(0.3*xscale,0.3*yscale)
	home:addEventListener("tap", mmrepeatgoHome)
	screenGroup:insert(home)

	if first==false then
		hintbutton = display.newImage(companionText,display.contentWidth-20*xscale,90*yscale)
		hintbutton:scale(-0.14*xscale,0.14*yscale)

		local function repeathint()
			hintbutton:removeEventListener("tap",repeathint)
			provideHint(screenGroup,repeatinstructions1)
		end
		hintbutton:addEventListener("tap",repeathint)
		screenGroup:insert(hintbutton)
	end

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	if questionCount>=10 then
		round = -1
		questionCount = 0
		storyboard.gotoScene("showmmscore", "fade", 200)
	else

		if round == -1 then
			for row in db:nrows("SELECT * FROM mmScore ORDER BY id DESC") do
			  round = row.round+1
			  break
			end
		end

		local screenGroup = self.view
		mmrepeatgenerateAnswers()
		mmrepeatgenerateAnswerText()
		mmrepeatdisplayNumbers(screenGroup)
		numberText = ""..number
		numcount = 1
		while numcount<multiplier do
			numberText = numberText.."+"..number
			numcount = numcount + 1
		end
		repeatinstructions2 = "In this case, the correct equation is "..numberText	
		mmrepeatnewQuestion(screenGroup)
	end
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	
end
function mmrepeatgoHome()
	first = true
	round = -1
	questionCount = 0
	storyboard.purgeScene("mmrepeat")
	storyboard.gotoScene( "mmselection")
end

function mmrepeatnewQuestion(n)
	local screenGroup = n

	if (first) then
		continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
		continue:scale(0.3*xscale,0.3*yscale)
		local myFunction = function() mmrepeatmakeFirstDisappear(screenGroup) end
		continue:addEventListener("tap", myFunction)
		screenGroup:insert(continue)
	else 
		mmrepeatshowChoices(screenGroup)
	end

end

function mmrepeatmakeFirstDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( repeatinstructions1, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 16 )
	myText:setFillColor(0)
	screenGroup:insert(myText)
	local myFunction = function() mmrepeatmakeSecondDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)
	screenGroup:insert(continue)
	continue:addEventListener("tap", myFunction)
	--showAnswer(screenGroup)
end
function mmrepeatmakeSecondDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)
	screenGroup:remove(valueText)
	myText = display.newText( repeatinstructions2, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 16 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	solution = display.newText(answerText.."="..number*multiplier, centerX-20*xscale, centerY-40*yscale, "Comic Relief", 30)
	solution.anchorX = 0
	solution:setFillColor(0)
	screenGroup:insert(solution)

	local myFunction = function() mmrepeatmakeThirdDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
end

function mmrepeatmakeThirdDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( repeatinstructions3, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	first = false
	go = display.newImage("images/go.png", centerX+200*xscale, centerY+120*yscale)
	go:scale(0.5*xscale,0.5*yscale)
	go:addEventListener("tap", mmrepeatnewSceneListener)
	screenGroup:insert(go)
end

function mmrepeatnewSceneListener()
	storyboard.purgeScene("mmrepeat")
	storyboard.reloadScene()
end

function mmrepeatgenerateAnswers()
	number = math.random(2,9)
	multiplier = math.random(2,5)
	if multiplier == 1 then
		number = number + 1
	end	
end

function mmrepeatshowChoices(n)
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
	function mmrepeatlistener()
		mmrepeatcorrectResponseListener(screenGroup)
	end
	answer:addEventListener("tap", mmrepeatlistener)
	screenGroup:insert(answer)

	answer1 = nil
	answer1 = display.newText(answer1Text,b[2],centerY+100*yscale,125*xscale,0, "Comic Relief", 20)
	answer1:setFillColor(0)
	local function listener1()
		mmrepeatincorrectResponseListener1(screenGroup)
	end
	answer1:addEventListener("tap", listener1)
	screenGroup:insert(answer1)

	answer2 = nil
	answer2 = display.newText(answer2Text,b[3],centerY+100*yscale,125*xscale,0, "Comic Relief", 20)
	answer2:setFillColor(0)
	local function listener2()
		mmrepeatincorrectResponseListener2(screenGroup)
	end
	answer2:addEventListener("tap", listener2)
	screenGroup:insert(answer2)

	answer3 = nil
	answer3 = display.newText(answer3Text,b[4],centerY+100*yscale,125*xscale,0, "Comic Relief", 20)
	answer3:setFillColor(0)
	local function listener3()
		mmrepeatincorrectResponseListener3(screenGroup)
	end
	answer3:addEventListener("tap", listener3)
	screenGroup:insert(answer3)

end

function mmrepeatgenerateAnswerText()

	if multiplier == 5 then
		answerText = number.."+"..number.."+"..number.."+"..number.."+"..number
		answer1Text = number.."+"..number.."+"..number.."+"..number
		answer2Text = number.."+"..number.."+"..number
		answer3Text = number.."+"..number
	end
	if multiplier == 4 then
		answer1Text = number.."+"..number.."+"..number.."+"..number.."+"..number
		answerText = number.."+"..number.."+"..number.."+"..number
		answer2Text = number.."+"..number.."+"..number
		answer3Text = number.."+"..number
	end
	if multiplier == 3 then
		answer2Text = number.."+"..number.."+"..number.."+"..number.."+"..number
		answer1Text = number.."+"..number.."+"..number.."+"..number
		answerText = number.."+"..number.."+"..number
		answer3Text = number.."+"..number
	end
	if multiplier == 2 then
		answer3Text = number.."+"..number.."+"..number.."+"..number.."+"..number
		answer1Text = number.."+"..number.."+"..number.."+"..number
		answer2Text = number.."+"..number.."+"..number
		answerText = number.."+"..number
	end

end

function mmrepeatdisplayNumbers(n)
	local screenGroup = n
	question = display.newText(number.."x"..multiplier.."=", centerX-60*xscale, centerY-40*yscale, "Comic Relief", 30)
	question:setFillColor(0)
	screenGroup:insert(question)
end

function mmrepeatcorrectResponseListener(n)
	local screenGroup = n
	screenGroup:remove(valueText)
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	storeRepeat(1,totalTime,answerText,answerText,round,2)
	questionCount = questionCount + 1

	solution = display.newText(answerText.."="..number*multiplier, centerX-20*xscale, centerY-40*yscale, "Comic Relief", 30)
	solution.anchorX = 0
	solution:setFillColor(0)
	screenGroup:insert(solution)

	mmrepeatremoveAnswers(screenGroup)
	local reward = display.newText("Good Job!", centerX+70*xscale,centerY+50,300,0,"Comic Relief", 30)
	reward:setFillColor(0)
	screenGroup:insert(reward)

	local myFunction = function() mmrepeatnewSceneListener() end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)

end


function mmrepeatincorrectResponseListener1(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	questionCount = questionCount + 1
	storeRepeat(0,totalTime,answerText,answer1Text,round,2)
	mmrepeatwrongAnswer(screenGroup)
	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end

function mmrepeatincorrectResponseListener2(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	questionCount = questionCount + 1
	storeRepeat(0,totalTime,answerText,answer2Text,round,2)
	mmrepeatwrongAnswer(screenGroup)

	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end

function mmrepeatincorrectResponseListener3(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	questionCount = questionCount + 1
	storeRepeat(0,totalTime,answerText,answer3Text,round,2)
	mmrepeatwrongAnswer(screenGroup)
	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end


function mmrepeatremoveAnswers(n)
	local screenGroup = n
	--screenGroup:remove(answer)
	screenGroup:remove(valueText)
	screenGroup:remove(answer1)
	screenGroup:remove(answer2)
	screenGroup:remove(answer3)
	screenGroup:remove(questionText)
	answer:removeEventListener("tap",mmrepeatlistener)
	

end

function mmrepeatwrongAnswer(n)
	local screenGroup = n
	mmrepeatremoveAnswers(screenGroup)

	solution = display.newText(answerText.."="..number*multiplier, centerX-20*xscale, centerY-40*yscale, "Comic Relief", 30)
	solution:setFillColor(0)
	solution.anchorX = 0
	screenGroup:insert(solution)

	questionText =display.newText( "Oops, the correct answer was", centerX, centerY+140*yscale,450*xscale,200*yscale, "Comic Relief", 18 )
	questionText:setFillColor(0)
	screenGroup:insert(questionText)

	local myFunction = function() mmrepeatnewSceneListener() end
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