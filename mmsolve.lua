---------------------------------------------------------------------------------
--
-- mmsolve.lua
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
local solveinstructions = "Your new task is to solve the given multiplication equation."
local solveinstructions1 = "Remember, multiplication represent how many times a number appears in a repeated addtion of itself."
local solveinstructions2
local solveinstructions3 = "Keep it up, you're almost there!"
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
		myText = display.newText( solveinstructions, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
		myText:setFillColor(0)
		screenGroup:insert(myText)
	end

	home = display.newImage("images/home.png",display.contentWidth-20*xscale,22*yscale)
	home:scale(0.3*xscale,0.3*yscale)
	home:addEventListener("tap", mmsolvegoHome)
	screenGroup:insert(home)

	if first==false then
		hintbutton = display.newImage(companionText,display.contentWidth-20*xscale,90*yscale)
		hintbutton:scale(-0.14*xscale,0.14*yscale)

		local function mmsolvehint()
			hintbutton:removeEventListener("tap",mmsolvehint)
			provideHint(screenGroup,solveinstructions1)
		end
		hintbutton:addEventListener("tap",mmsolvehint)
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
		mmsolvegenerateAnswers()
		mmsolvegenerateAnswerText()
		mmsolvedisplayNumbers(screenGroup)
		numberText = number*multiplier

		solveinstructions2 = "In this case, the correct value is "..numberText	
		mmsolvenewQuestion(screenGroup)
	end
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	
end
function mmsolvegoHome()
	first = true
	round = -1
	questionCount = 0
	storyboard.purgeScene("mmsolve")
	storyboard.gotoScene( "mmselection")
end

function mmsolvenewQuestion(n)
	local screenGroup = n

	if (first) then
		continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
		continue:scale(0.3*xscale,0.3*yscale)
		local myFunction = function() mmsolvemakeFirstDisappear(screenGroup) end
		continue:addEventListener("tap", myFunction)
		screenGroup:insert(continue)
	else 
		mmsolveshowChoices(screenGroup)
	end

end

function mmsolvemakeFirstDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( solveinstructions1, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 16 )
	myText:setFillColor(0)
	screenGroup:insert(myText)
	local myFunction = function() mmsolvemakeSecondDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)
	screenGroup:insert(continue)
	continue:addEventListener("tap", myFunction)
	--showAnswer(screenGroup)
end
function mmsolvemakeSecondDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)
	screenGroup:remove(valueText)
	myText = display.newText( solveinstructions2, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 16 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	solution = display.newText(number*multiplier, centerX-20*xscale, centerY-40*yscale, "Comic Relief", 30)
	solution.anchorX = 0
	solution:setFillColor(0)
	screenGroup:insert(solution)

	local myFunction = function() mmsolvemakeThirdDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
end

function mmsolvemakeThirdDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( solveinstructions3, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	first = false
	go = display.newImage("images/go.png", centerX+200*xscale, centerY+120*yscale)
	go:scale(0.5*xscale,0.5*yscale)
	go:addEventListener("tap", mmsolvenewSceneListener)
	screenGroup:insert(go)
end

function mmsolvenewSceneListener()
	storyboard.purgeScene("mmsolve")
	storyboard.reloadScene()
end

function mmsolvegenerateAnswers()
	number = math.random(2,9)
	multiplier = math.random(2,5)
	if multiplier == 1 then
		number = number + 1
	end	
end

function mmsolveshowChoices(n)
	local screenGroup = n
	startTime = system.getTimer()
	questionText =display.newText( "What is the correct value?", centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
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
	
	answer = display.newText(answerText,b[1],centerY+100*yscale, "Comic Relief", 20)
	answer:setFillColor(0)
	function mmsolvelistener()
		mmsolvecorrectResponseListener(screenGroup)
	end
	answer:addEventListener("tap", mmsolvelistener)
	screenGroup:insert(answer)

	answer1 = nil
	answer1 = display.newText(answer1Text,b[2],centerY+100*yscale, "Comic Relief", 20)
	answer1:setFillColor(0)
	local function listener1()
		mmsolveincorrectResponseListener1(screenGroup)
	end
	answer1:addEventListener("tap", listener1)
	screenGroup:insert(answer1)

	answer2 = nil
	answer2 = display.newText(answer2Text,b[3],centerY+100*yscale, "Comic Relief", 20)
	answer2:setFillColor(0)
	local function listener2()
		mmsolveincorrectResponseListener2(screenGroup)
	end
	answer2:addEventListener("tap", listener2)
	screenGroup:insert(answer2)

	answer3 = nil
	answer3 = display.newText(answer3Text,b[4],centerY+100*yscale,"Comic Relief", 20)
	answer3:setFillColor(0)
	local function listener3()
		mmsolveincorrectResponseListener3(screenGroup)
	end
	answer3:addEventListener("tap", listener3)
	screenGroup:insert(answer3)

end

function mmsolvegenerateAnswerText()

	if multiplier == 5 then
		answerText = number*5
		answer1Text = number*4
		answer2Text =  number*3
		answer3Text =  number*2
	end
	if multiplier == 4 then
		answer1Text =  number*5
		answerText =  number*4
		answer2Text =  number*3
		answer3Text =  number*2
	end
	if multiplier == 3 then
		answer2Text =  number*5
		answer1Text =  number*4
		answerText =  number*3
		answer3Text =  number*2
	end
	if multiplier == 2 then
		answer3Text =  number*5
		answer1Text =  number*4
		answer2Text = number*3
		answerText =  number*2
	end

end

function mmsolvedisplayNumbers(n)
	local screenGroup = n
	question = display.newText(number.."x"..multiplier.."=", centerX-60*xscale, centerY-40*yscale, "Comic Relief", 30)
	question:setFillColor(0)
	screenGroup:insert(question)
end

function mmsolvecorrectResponseListener(n)
	if hintOn==false then
		local screenGroup = n
		screenGroup:remove(valueText)
		local totalTime = math.floor((system.getTimer()-startTime)/1000)
		storeRepeat(1,totalTime,answerText,answerText,round,3)
		questionCount = questionCount + 1

		solution = display.newText(number*multiplier, centerX-20*xscale, centerY-40*yscale, "Comic Relief", 30)
		solution.anchorX = 0
		solution:setFillColor(0)
		screenGroup:insert(solution)

		mmsolveremoveAnswers(screenGroup)
		local reward = display.newText("Good Job!", centerX+70*xscale,centerY+50,300,0,"Comic Relief", 30)
		reward:setFillColor(0)
		screenGroup:insert(reward)

		local myFunction = function() mmsolvenewSceneListener() end
		continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
		continue:scale(0.3*xscale,0.3*yscale)

		continue:addEventListener("tap", myFunction)
		screenGroup:insert(continue)
	end

end


function mmsolveincorrectResponseListener1(n) 
	if hintOn==false then
		local screenGroup = n
		local totalTime = math.floor((system.getTimer()-startTime)/1000)
		questionCount = questionCount + 1
		storeRepeat(0,totalTime,answerText,answer1Text,round,3)
		mmsolvewrongAnswer(screenGroup)
	end
	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end

function mmsolveincorrectResponseListener2(n)
	if hintOn==false then
		local screenGroup = n
		local totalTime = math.floor((system.getTimer()-startTime)/1000)
		questionCount = questionCount + 1
		storeRepeat(0,totalTime,answerText,answer2Text,round,3)
		mmsolvewrongAnswer(screenGroup)
	end

	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end

function mmsolveincorrectResponseListener3(n)
	if hintOn==false then
		local screenGroup = n
		local totalTime = math.floor((system.getTimer()-startTime)/1000)
		questionCount = questionCount + 1
		storeRepeat(0,totalTime,answerText,answer3Text,round,3)
		mmsolvewrongAnswer(screenGroup)
	end
	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end


function mmsolveremoveAnswers(n)
	local screenGroup = n
	--screenGroup:remove(answer)
	screenGroup:remove(valueText)
	screenGroup:remove(answer1)
	screenGroup:remove(answer2)
	screenGroup:remove(answer3)
	screenGroup:remove(questionText)
	answer:removeEventListener("tap",mmsolvelistener)
	

end

function mmsolvewrongAnswer(n)
	local screenGroup = n
	mmsolveremoveAnswers(screenGroup)

	solution = display.newText(number*multiplier, centerX-20*xscale, centerY-40*yscale, "Comic Relief", 30)
	solution:setFillColor(0)
	solution.anchorX = 0
	screenGroup:insert(solution)

	questionText =display.newText( "Oops, the correct answer was", centerX, centerY+140*yscale,450*xscale,200*yscale, "Comic Relief", 18 )
	questionText:setFillColor(0)
	screenGroup:insert(questionText)

	local myFunction = function() mmsolvenewSceneListener() end
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