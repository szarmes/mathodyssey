---------------------------------------------------------------------------------
--
-- menu.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
require "dbFile"
companionText = "images/astronaut.png"

local buttonXOffset = 100
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
local centerX = display.contentCenterX
local centerY = display.contentCenterY
first = true
questionCount = 0
local round = -1
local fraction1instructions = "In this area, you will further explore the nature of fractions."
local fraction1instructions1 = "Fact: \nTwo fractions with different numerators and denominators can actually equal each other."
local fraction1instructions2 = "By multiplying (or dividing) a fraction's numerator and denominator by the same number, you create a new, equal fraction."
local fraction1instructions3 = "Using this knowledge, you will be asked to pick out which fraction is equal to the given fraction."
local fraction1instructions4 
local groups
local asteroidnum
local asteroids
local endGroup
local ratio

local function fraction1goHome()
	first = true
	round = -1
	mmcorrectCount = 0
	storyboard.purgeScene("fraction1")
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
		--fraction1ShowMultiple(screenGroup)

		myText = display.newText(fraction1instructions, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
		myText:setFillColor(0)
		screenGroup:insert(myText)
		fraction1ShowNumbers(screenGroup)
	end
	fraction1newQuestion(screenGroup)

	home = display.newImage("images/home.png",display.contentWidth-20*xscale,22*yscale)
	home:scale(0.3*xscale,0.3*yscale)
	home:addEventListener("tap", fraction1goHome)
	screenGroup:insert(home)
	if first==false then
		hintbutton = display.newImage(companionText,display.contentWidth-20*xscale,90*yscale)
		hintbutton:scale(-0.14*xscale,0.14*yscale)

		local function fraction1hint()
			hintbutton:removeEventListener("tap",fraction1hint)
			provideHint(screenGroup,fraction1instructions2)
		end
		hintbutton:addEventListener("tap",fraction1hint)
		screenGroup:insert(hintbutton)

		equalsText = display.newText("=", centerX, centerY-38*xscale,"Comic Relief",30)
		equalsText:setFillColor(0)
		screenGroup:insert(equalsText)

		qmarkText = display.newText("?",centerX+60*xscale,centerY-45*yscale,"Comic Relief",24)
		qmarkText:setFillColor(0)
		screenGroup:insert(qmarkText)
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

function fraction1newQuestion(n) -- this will make a new question
	local screenGroup = n
	if (first) then
		local myfunction = function() fraction1makeFirstDisappear(screenGroup) end
		continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
		continue:scale(0.3*xscale,0.3*yscale)
		continue:addEventListener("tap", myfunction)
		screenGroup:insert(continue)
	else 
		fraction1Game(n)
	end
end

function fraction1ShowNumbers(n)
	local screenGroup = n
	asteroidnum = math.random(1,5)
	groupnum = math.random(1,10)
	while groupnum<=asteroidnum do
		groupnum = math.random(1,10)
	end
	ratio = math.random(2,5)
	numeratorText = display.newText(asteroidnum,centerX-60*xscale,centerY-60*yscale,"Comic Relief",24)
	numeratorText:setFillColor(0)
	screenGroup:insert(numeratorText)

	line = display.newLine(centerX-85*xscale,centerY-38*yscale,centerX-30*xscale,centerY-38*yscale)
	line:setStrokeColor(0)
	line.strokeWidth =3
	screenGroup:insert(line)

	denominatorText = display.newText(groupnum,centerX-60*xscale,centerY-30,"Comic Relief",24)
	denominatorText:setFillColor(0)
	screenGroup:insert(denominatorText)


	if first == false then
		startTime = system.getTimer()
	end
end


function fraction1makeFirstDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText(fraction1instructions1, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myfunction = function() fraction1makeSecondDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myfunction)
	screenGroup:insert(continue)
end

function fraction1makeSecondDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText(fraction1instructions2, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 16 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myfunction = function() fraction1makeThirdDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myfunction)
	screenGroup:insert(continue)
end

function fraction1makeThirdDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText(fraction1instructions3, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myfunction = function() fraction1makeFourthDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myfunction)
	screenGroup:insert(continue)

end

function fraction1makeFourthDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)
	fraction1instructions4 = "In this case, these fractions are equal. The right fraction was created by multiplying the left fraction's numerator and denominator by "..ratio.."." 
	fraction1instructions4 = fraction1instructions4.." Good luck."
	myText = display.newText(fraction1instructions4, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 16 )
	myText:setFillColor(0)
	screenGroup:insert(myText)



	first = false
	go = display.newImage("images/go.png", centerX+200*xscale, centerY+120*yscale)
	go:scale(0.5*xscale,0.5*yscale)
	go:addEventListener("tap", fraction1newSceneListener)
	screenGroup:insert(go)

	fraction1ShowAnswer(screenGroup)
end

function fraction1ShowAnswer(n)
	local screenGroup = n

	equalsText = display.newText("=", centerX, centerY-38*xscale,"Comic Relief",30)
	equalsText:setFillColor(0)
	screenGroup:insert(equalsText)

	numerator1Text = display.newText(asteroidnum*ratio,centerX+60*xscale,centerY-60*yscale,"Comic Relief",24)
	numerator1Text:setFillColor(0)
	screenGroup:insert(numerator1Text)

	line1 = display.newLine(centerX+35*xscale,centerY-38*yscale,centerX+90*xscale,centerY-38*yscale)
	line1:setStrokeColor(0)
	line1.strokeWidth =3
	screenGroup:insert(line1)

	denominator1Text = display.newText(groupnum*ratio,centerX+60*xscale,centerY-30,"Comic Relief",24)
	denominator1Text:setFillColor(0)
	screenGroup:insert(denominator1Text)


end

function fraction1newSceneListener()
	storyboard.purgeScene("fraction1")
	storyboard.reloadScene()
end




function fraction1Game(n)
	local screenGroup = n
	fraction1ShowNumbers(screenGroup)
	fraction1showChoices(screenGroup)

end


function fraction1showChoices(n)
	local screenGroup = n
	startTime = system.getTimer()
	questionText = display.newText("Which fraction is equal to the given fraction?", centerX, centerY+120*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
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
	fraction1generateAnswerText()
	
	answer = display.newText(asteroidnum*ratio,b[1],centerY+80*yscale, "Comic Relief",24)
	answer:setFillColor(0)
	function fraction1listener()
		fraction1correctResponseListener(screenGroup)
	end
	answer:addEventListener("tap", fraction1listener)
	screenGroup:insert(answer)
	
	answerline = display.newLine(b[1]-20*xscale,centerY+100*yscale,b[1]+20*xscale,centerY+100*yscale)
	answerline:setStrokeColor(0)
	answerline.strokeWidth =3
	answerline:addEventListener("tap", fraction1listener)
	screenGroup:insert(answerline)

	answerdenom = display.newText(groupnum*ratio,b[1],centerY+115*yscale, "Comic Relief",24)
	answerdenom:setFillColor(0)
	answerdenom:addEventListener("tap", fraction1listener)
	screenGroup:insert(answerdenom)

	answer1 = display.newText(asteroidnum1*ratio,b[2],centerY+80*yscale, "Comic Relief", 24)
	answer1:setFillColor(0,0,0)
	local function listener1()
		fraction1incorrectResponseListener1(screenGroup)
	end
	answer1:addEventListener("tap", listener1)
	screenGroup:insert(answer1)

	answer1line = display.newLine(b[2]-20*xscale,centerY+100*yscale,b[2]+20*xscale,centerY+100*yscale)
	answer1line:setStrokeColor(0)
	answer1line.strokeWidth =3
	answer1line:addEventListener("tap", listener1)
	screenGroup:insert(answer1line)

	answer1denom = display.newText(groupnum1*ratio,b[2],centerY+115*yscale, "Comic Relief",24)
	answer1denom:setFillColor(0)
	answer1denom:addEventListener("tap", listener1)
	screenGroup:insert(answer1denom)

	answer2 = display.newText(asteroidnum2*ratio,b[3],centerY+80*yscale, "Comic Relief", 24)
	answer2:setFillColor(0,0,0)
	local function listener2()
		fraction1incorrectResponseListener2(screenGroup)
	end
	answer2:addEventListener("tap", listener2)
	screenGroup:insert(answer2)

	answer2line = display.newLine(b[3]-20*xscale,centerY+100*yscale,b[3]+20*xscale,centerY+100*yscale)
	answer2line:setStrokeColor(0)
	answer2line.strokeWidth =3
	answer2line:addEventListener("tap", listener2)
	screenGroup:insert(answer2line)

	answer2denom = display.newText(groupnum2*ratio,b[3],centerY+115*yscale, "Comic Relief",24)
	answer2denom:setFillColor(0)
	answer2denom:addEventListener("tap", listener2)
	screenGroup:insert(answer2denom)

	answer3 = display.newText(asteroidnum3*ratio,b[4],centerY+80*yscale, "Comic Relief", 24)
	answer3:setFillColor(0,0,0)
	local function listener3()
		fraction1incorrectResponseListener3(screenGroup)
	end
	answer3:addEventListener("tap", listener3)
	screenGroup:insert(answer3)

	answer3line = display.newLine(b[4]-20*xscale,centerY+100*yscale,b[4]+20*xscale,centerY+100*yscale)
	answer3line:setStrokeColor(0)
	answer3line.strokeWidth =3
	answer3line:addEventListener("tap", listener3)
	screenGroup:insert(answer3line)

	answer3denom = display.newText(groupnum3*ratio,b[4],centerY+115*yscale, "Comic Relief",24)
	answer3denom:setFillColor(0)
	answer3denom:addEventListener("tap", listener3)
	screenGroup:insert(answer3denom)


end

function fraction1generateAnswerText()
	
	asteroidnum1 = math.random(1,5)
	groupnum1 = math.random(1,10)
	while groupnum1<=asteroidnum1 or (asteroidnum1==asteroidnum and groupnum1 == groupnum) do
		groupnum1 = math.random(1,10)
		asteroidnum1 = math.random(1,5)
	end

	asteroidnum2 = math.random(1,5)
	groupnum2 = math.random(1,10)
	while groupnum2<=asteroidnum2 or (asteroidnum2==asteroidnum and groupnum2 == groupnum) do
		groupnum2 = math.random(1,10)
		asteroidnum2 = math.random(1,5)
	end
	asteroidnum3 = math.random(1,5)
	groupnum3 = math.random(1,10)
	while groupnum3<=asteroidnum3 or (asteroidnum3==asteroidnum and groupnum3 == groupnum) do
		groupnum3 = math.random(1,10)
		asteroidnum3 = math.random(1,5)
	end
end


function fraction1correctResponseListener(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	storeDD(1,totalTime,asteroidnum,groupnum,0,round,4)
	questionCount = questionCount + 1

	fraction1removeAnswers(screenGroup)
	local reward = display.newText("Good Job!", centerX+70*xscale,centerY+50,300,0,"Comic Relief", 30)
	reward:setFillColor(0)
	screenGroup:insert(reward)

	fraction1ShowAnswer(screenGroup)

	local myFunction = function() fraction1newSceneListener() end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)

	
end


function fraction1incorrectResponseListener1(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	questionCount = questionCount + 1
	storeDD(0,totalTime,asteroidnum1,groupnum1,0,round,4)
	fraction1wrongAnswer(screenGroup)
	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end

function fraction1incorrectResponseListener2(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	questionCount = questionCount + 1
	storeDD(0,totalTime,asteroidnum2,groupnum2,0,round,4)
	fraction1wrongAnswer(screenGroup)

	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end

function fraction1incorrectResponseListener3(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	questionCount = questionCount + 1
	storeDD(0,totalTime,asteroidnum3,groupnum3,0,round,4)
	fraction1wrongAnswer(screenGroup)
	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end


function fraction1removeAnswers(n)
	local screenGroup = n
	--screenGroup:remove(answer)
	screenGroup:remove(qmarkText)
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
	answer:removeEventListener("tap",fraction1listener)
	answerline:removeEventListener("tap",fraction1listener)
	answerdenom:removeEventListener("tap",fraction1listener)
	

end

function fraction1wrongAnswer(n)
	local screenGroup = n
	fraction1removeAnswers(screenGroup)
	questionText =display.newText( "Oops, the correct choice was", centerX, centerY+140*yscale,450*xscale,200*yscale, "Comic Relief", 18 )
	questionText:setFillColor(0)
	screenGroup:insert(questionText)

	fraction1ShowAnswer(screenGroup)

	local myFunction = function() fraction1newSceneListener() end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
end


function endfraction1Game(n)
	local screenGroup = endGroup
	screenGroup:remove(myText)
	myText = display.newText("Congratulations! You successfully divided "..asteroidnum.." by".. groupnum..", to form "..groupnum.." groups of "..(asteroidnum/2)..".", centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	storeDD(1,totalTime,asteroidnum,2,asteroidnum,round,1)

	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", fraction1goHome)
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