---------------------------------------------------------------------------------
--
-- exponentialenergy.lua
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
local instructions = "Welcome to the Balance Board. On this planet you will learn properties of equality."
local instructions1 = "Look at the value on both sides of the board. If they are the same, you're looking for the = sign."
local instructions2 = "If one is bigger than the other, use either the greater-than-sign, >, or the less-than-sign, <, as your equality sign."
local instructions3 = "Think of > and < as the mouth of a hungry crocodile. The croc always wants to eat more, so it opens to the equation with a larger value."
local instructions4 = "Once you pick a sign, the Balance Board will adjust to show which value is larger. It will not move if they are equal."
local instrucions5
local instructions6 = "Good luck out there."
local operator
local lnum1
local lnum2
local loperator
local lval
local rnum1
local rnum2
local roperator
local rval

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	bg = display.newImage("images/bbbg.png", centerX,centerY+30*yscale)
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
	
	--bbdisplayNumbers(screenGroup)
	--background = display.newImage("images/cat.jpg",centerX,centerY)
	--Runtime:addEventListener("touch",moveCatListener)
	--screenGroup:insert( background )

	home = display.newImage("images/home.png",display.contentWidth-20*xscale,22*yscale)
	home:scale(0.3*xscale,0.3*yscale)
	home:addEventListener("tap", bbgoHome)
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
		storyboard.gotoScene("showbbscore", "fade", 200)
	else

		if round == -1 then
			for row in db:nrows("SELECT * FROM bbScore ORDER BY id DESC") do
			  round = row.round+1
			  break
			end
		end

		local screenGroup = self.view
		bbgenerateAnswers()
		bbgenerateAnswerText()
		bbdisplayNumbers(screenGroup)

		if operator == "=" then
			instructions5 = "In this case the equality sign is =, since "..lval.." = "..rval.."."
		elseif operator == "<" then
			instructions5 = "In this case the equality sign is <, since "..lval.." is less than "..rval.."."
		else
			instructions5 = "In this case the equality sign is >, since "..lval.." is greater than "..rval.."."
		end
		bbnewQuestion(screenGroup)
	end
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	
end
function bbgoHome()
	first = true
	round = -1
	questionCount = 0
	storyboard.purgeScene("balanceboard")
	storyboard.gotoScene( "menu")
end

function bbnewQuestion(n)
	local screenGroup = n

	if (first) then
		continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
		continue:scale(0.3*xscale,0.3*yscale)
		local myFunction = function() bbmakeFirstDisappear(screenGroup) end
		continue:addEventListener("tap", myFunction)
		screenGroup:insert(continue)
		first = false
	else 
		bbshowChoices(screenGroup)
	end

end

function bbmakeFirstDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( instructions1, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 16 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myFunction = function() bbmakeSecondDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
	--eeshowAnsswer(screenGroup)
end
function bbmakeSecondDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( instructions2, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 16 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myFunction = function() bbmakeThirdDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
	--eeshowAnsswer(screenGroup)
end

function bbmakeThirdDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( instructions3, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myFunction = function() bbmakeFourthDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)

	--eeshowAnsswer(screenGroup)
end

function bbmakeFourthDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( instructions4, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myFunction = function() bbmakeFifthDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
	--eeshowAnsswer(screenGroup)
end

function bbmakeFifthDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)
	

	myText = display.newText( instructions5, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 20 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	bbadjustBoard(screenGroup)

	local myFunction = function() bbmakeSixthDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
	--eeshowAnsswer(screenGroup)
end

function bbmakeSixthDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( instructions6, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	first = false
	go = display.newImage("images/go.png", centerX+200*xscale, centerY+120*yscale)
	go:scale(0.5*xscale,0.5*yscale)
	go:addEventListener("tap", bbnewSceneListener)
	screenGroup:insert(go)

	--eeshowAnsswer(screenGroup)
end

function bbnewSceneListener()
	storyboard.purgeScene("balanceboard")
	storyboard.reloadScene()
end

function bbgenerateAnswers()
	lval = math.random(0,20)
	rval = math.random(0,20)
	if lval==rval then
		operator = "="
	elseif lval<rval then
		operator = "<"
	else 
		operator = ">"
	end
end

function bbshowChoices(n)
	local screenGroup = n
	startTime = system.getTimer()
	questionText =display.newText( "What is the equality sign?", centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	questionText:setFillColor(0)
	screenGroup:insert(questionText)
	
	a={centerX-150*xscale,centerX,centerX+150*xscale}
	b = {}
	count = 3

	while (count>0) do --randomize the array of x values
		local r = math.random(1,count)
		b[count] = a[r]
		table.remove(a, r)
		count=count-1
	end
	bbgenerateAnswerText()
	
	answer = display.newText(operator,b[1],centerY+100*yscale, "Comic Relief", 40)
	answer:setFillColor(0)
	function bblistener()
		bbcorrectResponseListener(screenGroup)
	end
	answer:addEventListener("tap", bblistener)
	screenGroup:insert(answer)

	answer1 = display.newText(answer1Text,b[2],centerY+100*yscale, "Comic Relief", 40)
	answer1:setFillColor(0,0,0)
	local function listener1()
		bbincorrectResponseListener1(screenGroup)
	end
	answer1:addEventListener("tap", listener1)
	screenGroup:insert(answer1)

	answer2 = display.newText(answer2Text,b[3],centerY+100*yscale, "Comic Relief", 40)
	answer2:setFillColor(0,0,0)
	local function listener2()
		bbincorrectResponseListener2(screenGroup)
	end
	answer2:addEventListener("tap", listener2)
	screenGroup:insert(answer2)

end

function bbgenerateAnswerText()

	if operator == "=" then
		answer1Text = "<"
		answer2Text = ">"
	end
	if operator == "<" then
		answer1Text = "="
		answer2Text = ">"
	end
	if operator == ">" then
		answer1Text = "="
		answer2Text = "<"
	end

end

function bbdisplayNumbers(n)
	local screenGroup = n

	board = display.newImage("images/balanced.png",centerX,centerY-40*yscale)
	board:scale(xscale,0.6*yscale)
	screenGroup:insert(board)

	scalebase = display.newImage("images/scalebase.png",centerX,centerY-40*yscale)
	scalebase:scale(0.8*xscale,0.6*yscale)
	screenGroup:insert(scalebase)

	lequation = display.newText(lval,centerX-150*xscale,centerY-60*yscale,"Comic Relief",30)
	lequation:setFillColor(0)
	screenGroup:insert(lequation)

	requation = display.newText(rval,centerX+150*xscale,centerY-60*yscale,"Comic Relief",30)
	requation:setFillColor(0)
	screenGroup:insert(requation)

	operatorText = display.newText("?",centerX,centerY-60*yscale,"Comic Relief",40)
	operatorText:setFillColor(0)
	screenGroup:insert(operatorText)
	
	
end

function bbcorrectResponseListener(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	storeBB(1,totalTime,operator,operator,lval,rval,round,1)
	questionCount = questionCount + 1

	bbremoveAnswers(screenGroup)
	local reward = display.newText("Good Job!", centerX+70*xscale,centerY+50,300,0,"Comic Relief", 30)
	reward:setFillColor(0)
	screenGroup:insert(reward)

	local myFunction = function() bbnewSceneListener() end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)

	
end


function bbincorrectResponseListener1(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	questionCount = questionCount + 1
	storeBB(0,totalTime,operator,answer1Text,lval,rval,round,1)
	bbwrongAnswer(screenGroup)
	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end

function bbincorrectResponseListener2(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	questionCount = questionCount + 1
	storeBB(0,totalTime,operator,answer2Text,lval,rval,round,1)
	bbwrongAnswer(screenGroup)

	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end


function bbremoveAnswers(n)
	local screenGroup = n
	--screenGroup:remove(answer)
	
	screenGroup:remove(answer1)
	screenGroup:remove(answer2)
	screenGroup:remove(answer3)
	screenGroup:remove(questionText)
	answer:removeEventListener("tap",bblistener)
	bbadjustBoard(screenGroup)
	

end

function bbwrongAnswer(n)
	local screenGroup = n
	bbremoveAnswers(screenGroup)
	questionText =display.newText( "Oops, the correct answer was", centerX, centerY+140*yscale,450*xscale,200*yscale, "Comic Relief", 18 )
	questionText:setFillColor(0)
	screenGroup:insert(questionText)

	local myFunction = function() bbnewSceneListener() end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
end

function bbadjustBoard(n)
	local screenGroup = n
	screenGroup:remove(board)
	if operator == "=" then
		boardsrc = "images/balanced.png"
	elseif operator == ">" then
		boardsrc = "images/lessthan.png"
		lequation.y=lequation.y+20*yscale
		requation.y=requation.y-10*yscale

	else
		boardsrc = "images/greaterthan.png"
		lequation.y=lequation.y-10*yscale
		requation.y=requation.y+20*yscale

	end

	board = display.newImage(boardsrc,centerX,centerY-40*yscale)
	board:scale(xscale,0.6*yscale)
	screenGroup:insert(board)

	screenGroup:remove(operatorText)
	operatorText = display.newText(operator,centerX,centerY-60*yscale,"Comic Relief",40)
	operatorText:setFillColor(0)
	screenGroup:insert(operatorText)

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