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
questionCount = 0
local round = -1
local fractioninstructions = "Now that you know about division you will learn about fractions, a term to describe a portion of a whole number."
local fractioninstructions1 = "In a division equation we call the top number the numerator, and the bottom number the denominator."
local fractioninstructions2 = "Fractions are just division equations which have a numerator that is smaller than the denominator."
local fractioninstructions3 = "You will be given division equations, and will be asked to pick out which is a fraction."
local fractioninstructions4 
local groups
local asteroidnum
local asteroids
local endGroup

local function fractiongoHome()
	first = true
	round = -1
	mmcorrectCount = 0
	storyboard.purgeScene("fraction")
	storyboard.gotoScene( "ddmoonselection" )
end


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	endGroup = screenGroup
	bg = display.newImage("images/mmmoonbg.png", centerX,centerY+(30*yscale))
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
		--fractionShowMultiple(screenGroup)

		myText = display.newText(fractioninstructions, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
		myText:setFillColor(0)
		screenGroup:insert(myText)
		fractionShowNumbers(screenGroup)
	end
	fractionnewQuestion(screenGroup)

	home = display.newImage("images/home.png",display.contentWidth-20*xscale,22*yscale)
	home:scale(0.3*xscale,0.3*yscale)
	home:addEventListener("tap", fractiongoHome)
	screenGroup:insert(home)
	if first==false then
		hintbutton = display.newImage(companionText,display.contentWidth-20*xscale,90*yscale)
		hintbutton:scale(-0.14*xscale,0.14*yscale)

		local function fractionhint()
			hintbutton:removeEventListener("tap",fractionhint)
			provideHint(screenGroup,fractioninstructions2)
		end
		hintbutton:addEventListener("tap",fractionhint)
		screenGroup:insert(hintbutton)
	end

end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )	
	if questionCount>=10 then
		round = -1
		questionCount = 0
		storyboard.gotoScene("showddscore", "fade", 200)
	else
		if round == -1 then
				for row in db:nrows("SELECT * FROM ddScore ORDER BY id DESC") do
				  round = row.round+1
				  break
				end
		end
	end
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	
end

-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )	
end

function fractionnewQuestion(n) -- this will make a new question
	local screenGroup = n
	if (first) then
		local myfunction = function() fractionmakeFirstDisappear(screenGroup) end
		continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
		continue:scale(0.3*xscale,0.3*yscale)
		continue:addEventListener("tap", myfunction)
		screenGroup:insert(continue)
	else 
		fractionGame(n)
	end
end

function fractionShowNumbers(n)
	local screenGroup = n
	asteroidnum = math.random(1,10)
	groupnum = math.random(1,20)
	while groupnum<=asteroidnum do
		groupnum = math.random(1,20)
	end
	numeratorText = display.newText("numerator",centerX-20*xscale,centerY-60*yscale,"Comic Relief",24)
	numeratorText:setFillColor(0)
	screenGroup:insert(numeratorText)

	line = display.newLine(centerX-85*xscale,centerY-38*yscale,centerX+40*xscale,centerY-38*yscale)
	line:setStrokeColor(0)
	line.strokeWidth =3
	screenGroup:insert(line)

	denominatorText = display.newText("denominator",centerX-20*xscale,centerY-30,"Comic Relief",24)
	denominatorText:setFillColor(0)
	screenGroup:insert(denominatorText)


	if first == false then
		startTime = system.getTimer()
	end
end


function fractionmakeFirstDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText(fractioninstructions1, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myfunction = function() fractionmakeSecondDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myfunction)
	screenGroup:insert(continue)
end

function fractionmakeSecondDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText(fractioninstructions2, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myfunction = function() fractionmakeThirdDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myfunction)
	screenGroup:insert(continue)
end

function fractionmakeThirdDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText(fractioninstructions3, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myfunction = function() fractionmakeFourthDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myfunction)
	screenGroup:insert(continue)

end

function fractionmakeFourthDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)
	fractioninstructions4 = "This division equation creates a fraction, since "..asteroidnum.." (the numerator) is smaller than "..groupnum.." (the denominator)."
	fractioninstructions4 = fractioninstructions4.." Good luck out there."
	myText = display.newText(fractioninstructions4, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)



	first = false
	go = display.newImage("images/go.png", centerX+200*xscale, centerY+120*yscale)
	go:scale(0.5*xscale,0.5*yscale)
	go:addEventListener("tap", fractionnewSceneListener)
	screenGroup:insert(go)

	fractionShowAnswer(screenGroup)
end

function fractionShowAnswer(n)
	local screenGroup = n
	topText = display.newText(asteroidnum,centerX+90*xscale,centerY-60*yscale,"Comic Relief",24)
	topText:setFillColor(0)
	screenGroup:insert(topText)

	line1 = display.newLine(centerX+65*xscale,centerY-38*yscale,centerX+120*xscale,centerY-38*yscale)
	line1:setStrokeColor(0)
	line1.strokeWidth =3
	screenGroup:insert(line1)

	bottomText = display.newText(groupnum,centerX+90*xscale,centerY-30,"Comic Relief",24)
	bottomText:setFillColor(0)
	screenGroup:insert(bottomText)


end

function fractionnewSceneListener()
	storyboard.purgeScene("fraction")
	storyboard.reloadScene()
end




function fractionGame(n)
	local screenGroup = n
	fractionShowNumbers(screenGroup)
	fractionshowChoices(screenGroup)

end


function fractionshowChoices(n)
	local screenGroup = n
	startTime = system.getTimer()
	questionText = display.newText("Which is the fraction?", centerX, centerY+120*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	questionText:setFillColor(0)
	screenGroup:insert(questionText)

	a={-205,-80,45,170}
	b = {}
	count = 4

	while (count>0) do --randomize the array of x values
		local r = math.random(1,count)
		b[count] = centerX+a[r]*xscale
		table.remove(a, r)
		count=count-1
	end
	fractiongenerateAnswerText()
	
	answer = display.newText(asteroidnum,b[1],centerY+80*yscale, "Comic Relief",24)
	answer:setFillColor(0)
	function fractionlistener()
		fractioncorrectResponseListener(screenGroup)
	end
	answer:addEventListener("tap", fractionlistener)
	screenGroup:insert(answer)
	
	answerline = display.newLine(b[1]-20*xscale,centerY+100*yscale,b[1]+20*xscale,centerY+100*yscale)
	answerline:setStrokeColor(0)
	answerline.strokeWidth =3
	answerline:addEventListener("tap", fractionlistener)
	screenGroup:insert(answerline)

	answerdenom = display.newText(groupnum,b[1],centerY+115*yscale, "Comic Relief",24)
	answerdenom:setFillColor(0)
	answerdenom:addEventListener("tap", fractionlistener)
	screenGroup:insert(answerdenom)

	answer1 = display.newText(asteroidnum1,b[2],centerY+80*yscale, "Comic Relief", 24)
	answer1:setFillColor(0,0,0)
	local function listener1()
		fractionincorrectResponseListener1(screenGroup)
	end
	answer1:addEventListener("tap", listener1)
	screenGroup:insert(answer1)

	answer1line = display.newLine(b[2]-20*xscale,centerY+100*yscale,b[2]+20*xscale,centerY+100*yscale)
	answer1line:setStrokeColor(0)
	answer1line.strokeWidth =3
	answer1line:addEventListener("tap", listener1)
	screenGroup:insert(answer1line)

	answer1denom = display.newText(groupnum1,b[2],centerY+115*yscale, "Comic Relief",24)
	answer1denom:setFillColor(0)
	answer1denom:addEventListener("tap", listener1)
	screenGroup:insert(answer1denom)

	answer2 = display.newText(asteroidnum2,b[3],centerY+80*yscale, "Comic Relief", 24)
	answer2:setFillColor(0,0,0)
	local function listener2()
		fractionincorrectResponseListener2(screenGroup)
	end
	answer2:addEventListener("tap", listener2)
	screenGroup:insert(answer2)

	answer2line = display.newLine(b[3]-20*xscale,centerY+100*yscale,b[3]+20*xscale,centerY+100*yscale)
	answer2line:setStrokeColor(0)
	answer2line.strokeWidth =3
	answer2line:addEventListener("tap", listener2)
	screenGroup:insert(answer2line)

	answer2denom = display.newText(groupnum2,b[3],centerY+115*yscale, "Comic Relief",24)
	answer2denom:setFillColor(0)
	answer2denom:addEventListener("tap", listener2)
	screenGroup:insert(answer2denom)

	answer3 = display.newText(asteroidnum3,b[4],centerY+80*yscale, "Comic Relief", 24)
	answer3:setFillColor(0,0,0)
	local function listener3()
		fractionincorrectResponseListener3(screenGroup)
	end
	answer3:addEventListener("tap", listener3)
	screenGroup:insert(answer3)

	answer3line = display.newLine(b[4]-20*xscale,centerY+100*yscale,b[4]+20*xscale,centerY+100*yscale)
	answer3line:setStrokeColor(0)
	answer3line.strokeWidth =3
	answer3line:addEventListener("tap", listener3)
	screenGroup:insert(answer3line)

	answer3denom = display.newText(groupnum3,b[4],centerY+115*yscale, "Comic Relief",24)
	answer3denom:setFillColor(0)
	answer3denom:addEventListener("tap", listener3)
	screenGroup:insert(answer3denom)


end

function fractiongenerateAnswerText()
	
	asteroidnum1 = math.random(1,10)
	groupnum1 = math.random(1,20)
	while groupnum1>asteroidnum1 do
		groupnum1 = math.random(1,20)
	end

	asteroidnum2 = math.random(1,10)
	groupnum2 = math.random(1,20)
	while groupnum2>asteroidnum2 do
		groupnum2 = math.random(1,20)
	end
	asteroidnum3 = math.random(1,10)
	groupnum3 = math.random(1,20)
	while groupnum3>asteroidnum3 do
		groupnum3 = math.random(1,20)
	end
end


function fractioncorrectResponseListener(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	storeDD(1,totalTime,asteroidnum,groupnum,0,round,4)
	questionCount = questionCount + 1

	fractionremoveAnswers(screenGroup)
	local reward = display.newText("Good Job!", centerX+70*xscale,centerY+50,300,0,"Comic Relief", 30)
	reward:setFillColor(0)
	screenGroup:insert(reward)

	fractionShowAnswer(screenGroup)

	local myFunction = function() fractionnewSceneListener() end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)

	
end


function fractionincorrectResponseListener1(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	questionCount = questionCount + 1
	storeDD(0,totalTime,asteroidnum1,groupnum1,0,round,4)
	fractionwrongAnswer(screenGroup)
	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end

function fractionincorrectResponseListener2(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	questionCount = questionCount + 1
	storeDD(0,totalTime,asteroidnum2,groupnum2,0,round,4)
	fractionwrongAnswer(screenGroup)

	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end

function fractionincorrectResponseListener3(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	questionCount = questionCount + 1
	storeDD(0,totalTime,asteroidnum3,groupnum3,0,round,4)
	fractionwrongAnswer(screenGroup)
	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end


function fractionremoveAnswers(n)
	local screenGroup = n
	--screenGroup:remove(answer)
	
	screenGroup:remove(answer1)
	screenGroup:remove(answer1line)
	screenGroup:remove(answer1denom)
	screenGroup:remove(answer2)
	screenGroup:remove(answer2line)
	screenGroup:remove(answer2denom)
	screenGroup:remove(answer3)
	screenGroup:remove(answer3line)
	screenGroup:remove(answer3denom)
	screenGroup:remove(questionText)
	answer:removeEventListener("tap",fractionlistener)
	answerline:removeEventListener("tap",fractionlistener)
	answerdenom:removeEventListener("tap",fractionlistener)
	

end

function fractionwrongAnswer(n)
	local screenGroup = n
	fractionremoveAnswers(screenGroup)
	questionText =display.newText( "Oops, the correct answer was", centerX, centerY+140*yscale,450*xscale,200*yscale, "Comic Relief", 18 )
	questionText:setFillColor(0)
	screenGroup:insert(questionText)

	fractionShowAnswer(screenGroup)

	local myFunction = function() fractionnewSceneListener() end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
end


function endfractionGame(n)
	local screenGroup = endGroup
	screenGroup:remove(myText)
	myText = display.newText("Congratulations! You successfully divided "..asteroidnum.." by".. groupnum..", to form "..groupnum.." groups of "..(asteroidnum/2)..".", centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	storeDD(1,totalTime,asteroidnum,groupnum,asteroidnum,round,4)

	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", fractiongoHome)
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