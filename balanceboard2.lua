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
local bb2instructions = "Your new task on this deployment is to choose the value that correctly satisfies the balance board equation."
local bb2instructions1 = "Use addition and subtraction to find the value of the given equation."
local bb2instructions2 = "If the board is tilted to the left, find a smaller value to satisfy the equation."
local bb2instructions3 = "If the board is tilted to the right, find the larger value to satisfy the equation."
local bb2instructions4 = "If the board is flat, look for a number with equal value to satisfy the equation."
local bb2instrucions5
local bb2instructions6 = "We're pulling for you!"
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
		myText = display.newText( bb2instructions, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
		myText:setFillColor(0)
		screenGroup:insert(myText)
	end
	
	--bbdisplayNumbers(screenGroup)
	--background = display.newImage("images/cat.jpg",centerX,centerY)
	--Runtime:addEventListener("touch",moveCatListener)
	--screenGroup:insert( background )

	home = display.newImage("images/home.png",display.contentWidth-20*xscale,22*yscale)
	home:scale(0.3*xscale,0.3*yscale)
	home:addEventListener("tap", bb2goHome)
	screenGroup:insert(home)

	if first==false then
		hintbutton = display.newImage(companionText,display.contentWidth-20*xscale,90*yscale)
		hintbutton:scale(-0.14*xscale,0.14*yscale)

		local function bb2hint()
			hintbutton:removeEventListener("tap",bb2hint)
			provideHint(screenGroup,bb2instructions1)
		end
		hintbutton:addEventListener("tap",bb2hint)
		screenGroup:insert(hintbutton)
	end

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
		bb2generateAnswers()
		bb2generateAnswerText()
		bb2displayNumbers(screenGroup)
		bb2adjustBoard(screenGroup)

		if operator == "=" then
			bb2instructions5 = "In this case, a possible value is "..rval..", since "..lval.." = "..rval.."."
		elseif operator == "<" then
			bb2instructions5 = "In this case, a possible value is "..rval..", since "..lval.." is less than "..rval.."."
		else
			bb2instructions5 = "In this case, a possible value is "..rval..", since " ..lval.." is greater than "..rval.."."
		end
		bb2newQuestion(screenGroup)
	end
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	
end
function bb2goHome()
	first = true
	round = -1
	questionCount = 0
	storyboard.purgeScene("balanceboard2")
	storyboard.gotoScene( "bbselection")
end

function bb2newQuestion(n)
	local screenGroup = n

	if (first) then
		continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
		continue:scale(0.3*xscale,0.3*yscale)
		local myFunction = function() bb2makeFirstDisappear(screenGroup) end
		continue:addEventListener("tap", myFunction)
		screenGroup:insert(continue)
		first = false
	else 
		bb2showChoices(screenGroup)
	end

end

function bb2makeFirstDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( bb2instructions1, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myFunction = function() bb2makeSecondDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
	--eeshowAnsswer(screenGroup)
end
function bb2makeSecondDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( bb2instructions2, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myFunction = function() bb2makeThirdDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
	--eeshowAnsswer(screenGroup)
end

function bb2makeThirdDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( bb2instructions3, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myFunction = function() bb2makeFourthDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)

	--eeshowAnsswer(screenGroup)
end

function bb2makeFourthDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( bb2instructions4, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myFunction = function() bb2makeFifthDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
	--eeshowAnsswer(screenGroup)
end

function bb2makeFifthDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)
	

	myText = display.newText( bb2instructions5, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 20 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myFunction = function() bb2makeSixthDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
	--eeshowAnsswer(screenGroup)
end

function bb2makeSixthDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( bb2instructions6, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	first = false
	go = display.newImage("images/go.png", centerX+200*xscale, centerY+120*yscale)
	go:scale(0.5*xscale,0.5*yscale)
	go:addEventListener("tap", bb2newSceneListener)
	screenGroup:insert(go)

	--eeshowAnsswer(screenGroup)
end

function bb2newSceneListener()
	storyboard.purgeScene("balanceboard2")
	storyboard.reloadScene()
end

function bb2generateAnswers()
	lnum1 = math.random(5,20)
	lnum2 = math.random(0,20)
	loperatornum = math.random(1,2)
	if loperatornum == 1 then
		loperator = "+"
		lval = lnum1+lnum2
	else
		loperator = "-"
		while lnum2>=lnum1 do
			lnum2 = math.random(0,20)
		end
		lval = lnum1-lnum2
	end
	rnum1 = math.random(5,20)
	rnum2 = math.random(0,20)
	roperatornum = math.random(1,2)
	if roperatornum == 1 then
		roperator = "+"
		rval = rnum1+rnum2
	else
		roperator = "-"
		while rnum2>=rnum1 do 
			rnum2 = math.random(0,20)
		end
		rval = rnum1-rnum2
	end

	if lval==rval then
		operator = "="
	elseif lval<rval then
		operator = "<"
	else 
		operator = ">"
	end
end

function bb2showChoices(n)
	local screenGroup = n
	startTime = system.getTimer()
	questionText =display.newText( "What value satisfies the equation?", centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
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
	bb2generateAnswerText()
	
	answer = display.newText(rval,b[1],centerY+100*yscale, "Comic Relief", 30)
	answer:setFillColor(0)
	function bb2listener()
		bb2correctResponseListener(screenGroup)
	end
	answer:addEventListener("tap", bb2listener)
	screenGroup:insert(answer)

	answer1 = display.newText(answer1Text,b[2],centerY+100*yscale, "Comic Relief", 30)
	answer1:setFillColor(0,0,0)
	local function listener1()
		bb2incorrectResponseListener1(screenGroup)
	end
	answer1:addEventListener("tap", listener1)
	screenGroup:insert(answer1)

	answer2 = display.newText(answer2Text,b[3],centerY+100*yscale, "Comic Relief", 30)
	answer2:setFillColor(0,0,0)
	local function listener2()
		bb2incorrectResponseListener2(screenGroup)
	end
	answer2:addEventListener("tap", listener2)
	screenGroup:insert(answer2)

end

function bb2generateAnswerText()
	if operator == "=" then
		answer1Text = math.random(0,50)
		while answer1Text <= lval do
			answer1Text = math.random(0,50)
		end
		answer2Text = math.random(0,50)
		while answer2Text >= lval do
			answer2Text = math.random(0,50)
		end
	end
	if operator == "<" then
		print(operator)
		answer1Text = lval
		answer2Text = math.random(0,50)
		while answer2Text >= lval do
			answer2Text = math.random(0,50)
		end
		print ("answer1: "..answer1Text)
		print ("answer2: "..answer2Text)
	end
	if operator == ">" then
		print(operator)
		answer1Text = lval
		answer2Text = math.random(0,50)
		while answer2Text <= lval do
			answer2Text = math.random(0,50)
		end
		print ("answer1: "..answer1Text)
		print ("answer2: "..answer2Text)
	end

end

function bb2displayNumbers(n)
	local screenGroup = n

	board = display.newImage("images/balanced.png",centerX,centerY-40*yscale)
	board:scale(xscale,0.6*yscale)
	screenGroup:insert(board)

	scalebase = display.newImage("images/scalebase.png",centerX,centerY-40*yscale)
	scalebase:scale(0.8*xscale,0.6*yscale)
	screenGroup:insert(scalebase)

	lequation = display.newText(lnum1..loperator..lnum2,centerX-150*xscale,centerY-60*yscale,"Comic Relief",30)
	lequation:setFillColor(0)
	screenGroup:insert(lequation)

	requation = display.newText("?",centerX+150*xscale,centerY-60*yscale,"Comic Relief",30)
	requation:setFillColor(0)
	screenGroup:insert(requation)

	operatorText = display.newText(operator,centerX,centerY-60*yscale,"Comic Relief",40)
	operatorText:setFillColor(0)
	screenGroup:insert(operatorText)
	
	
end

function bb2correctResponseListener(n)
	if hintOn==false then
		local screenGroup = n
		local totalTime = math.floor((system.getTimer()-startTime)/1000)
		storeBB(1,totalTime,operator,operator,lval,rval,round,3)
		questionCount = questionCount + 1

		bb2removeAnswers(screenGroup)
		local reward = display.newText("Good Job!", centerX+70*xscale,centerY+50,300,0,"Comic Relief", 30)
		reward:setFillColor(0)
		screenGroup:insert(reward)

		local myFunction = function() bb2newSceneListener() end
		continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
		continue:scale(0.3*xscale,0.3*yscale)

		continue:addEventListener("tap", myFunction)
		screenGroup:insert(continue)
	end

	
end


function bb2incorrectResponseListener1(n) 
	if hintOn==false then
		local screenGroup = n
		local totalTime = math.floor((system.getTimer()-startTime)/1000)
		questionCount = questionCount + 1
		storeBB(0,totalTime,operator,answer1Text,lval,rval,round,3)
		bb2wrongAnswer(screenGroup)
	end
	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end

function bb2incorrectResponseListener2(n)
	if hintOn==false then
		local screenGroup = n
		local totalTime = math.floor((system.getTimer()-startTime)/1000)
		questionCount = questionCount + 1
		storeBB(0,totalTime,operator,answer2Text,lval,rval,round,3)
		bb2wrongAnswer(screenGroup)
	end

	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end


function bb2removeAnswers(n)
	local screenGroup = n
	--screenGroup:remove(answer)
	
	screenGroup:remove(answer1)
	screenGroup:remove(answer2)
	screenGroup:remove(answer3)
	screenGroup:remove(questionText)
	answer:removeEventListener("tap",bb2listener)
	

end

function bb2wrongAnswer(n)
	local screenGroup = n
	bb2removeAnswers(screenGroup)
	questionText =display.newText( "Oops, the correct answer was", centerX, centerY+140*yscale,450*xscale,200*yscale, "Comic Relief", 18 )
	questionText:setFillColor(0)
	screenGroup:insert(questionText)

	local myFunction = function() bb2newSceneListener() end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
end

function bb2adjustBoard(n)
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