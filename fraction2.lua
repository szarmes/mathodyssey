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
local fraction2instructions = "Your final task with fractions is to simplify them."
local fraction2instructions1 = "This means you convert the fraction into an equal fraction that has the smallest possible, whole-numbered numerator and denominator."
local fraction2instructions2 = "To do this, divide the numerator and denominator by the highest number that can divide into both numbers exactly."
local fraction2instructions3 = "The number that accomplishes this is called the common denominator."
local fraction2instructions4 = "Be aware that sometimes the given fraction will already be in simplified form, meaning the common denominator is 1."
local fraction2instructions5 
local groups
local asteroidnum
local asteroids
local endGroup
local commondenom
local ratio

local function fraction2goHome()
	first = true
	round = -1
	mmcorrectCount = 0
	storyboard.purgeScene("fraction2")
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
		--fraction2ShowMultiple(screenGroup)

		myText = display.newText(fraction2instructions, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
		myText:setFillColor(0)
		screenGroup:insert(myText)
		fraction2ShowNumbers(screenGroup)
	end
	fraction2newQuestion(screenGroup)

	home = display.newImage("images/home.png",display.contentWidth-20*xscale,22*yscale)
	home:scale(0.3*xscale,0.3*yscale)
	home:addEventListener("tap", fraction2goHome)
	screenGroup:insert(home)
	if first==false then
		hintbutton = display.newImage(companionText,display.contentWidth-20*xscale,90*yscale)
		hintbutton:scale(-0.14*xscale,0.14*yscale)

		local function fraction2hint()
			hintbutton:removeEventListener("tap",fraction2hint)
			provideHint(screenGroup,fraction2instructions2)
		end
		hintbutton:addEventListener("tap",fraction2hint)
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

function fraction2newQuestion(n) -- this will make a new question
	local screenGroup = n
	if (first) then
		local myfunction = function() fraction2makeFirstDisappear(screenGroup) end
		continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
		continue:scale(0.3*xscale,0.3*yscale)
		continue:addEventListener("tap", myfunction)
		screenGroup:insert(continue)
	else 
		fraction2Game(n)
	end
end

function fraction2ShowNumbers(n)
	local screenGroup = n
	local ratio = math.random(1,2)
	asteroidnum = math.random(1,10)*ratio
	groupnum = math.random(1,20)*ratio
	while groupnum<=asteroidnum do
		groupnum = math.random(1,20)*ratio
	end
	commondenom = 1
	for i = 1,groupnum,1 do
		if asteroidnum%i ==0 and groupnum%i==0 then
			commondenom = i
		end
	end
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


function fraction2makeFirstDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText(fraction2instructions1, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myfunction = function() fraction2makeSecondDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myfunction)
	screenGroup:insert(continue)
end

function fraction2makeSecondDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText(fraction2instructions2, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 16 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myfunction = function() fraction2makeThirdDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myfunction)
	screenGroup:insert(continue)
end

function fraction2makeThirdDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText(fraction2instructions3, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myfunction = function() fraction2makeFourthDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myfunction)
	screenGroup:insert(continue)

end

function fraction2makeFourthDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText(fraction2instructions4, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myfunction = function() fraction2makeFifthDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myfunction)
	screenGroup:insert(continue)

end

function fraction2makeFifthDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)
	fraction2instructions5 = "In this case, the common denominator was "..commondenom..". The simplified, right fraction was created by dividing the left fraction by "..commondenom.."." 
	fraction2instructions5 = fraction2instructions5.." Good luck."
	myText = display.newText(fraction2instructions5, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 16 )
	myText:setFillColor(0)
	screenGroup:insert(myText)



	first = false
	go = display.newImage("images/go.png", centerX+200*xscale, centerY+120*yscale)
	go:scale(0.5*xscale,0.5*yscale)
	go:addEventListener("tap", fraction2newSceneListener)
	screenGroup:insert(go)

	fraction2ShowAnswer(screenGroup)
end

function fraction2ShowAnswer(n)
	local screenGroup = n

	equalsText = display.newText("=", centerX, centerY-38*xscale,"Comic Relief",30)
	equalsText:setFillColor(0)
	screenGroup:insert(equalsText)

	numerator1Text = display.newText(asteroidnum/commondenom,centerX+60*xscale,centerY-60*yscale,"Comic Relief",24)
	numerator1Text:setFillColor(0)
	screenGroup:insert(numerator1Text)

	line1 = display.newLine(centerX+35*xscale,centerY-38*yscale,centerX+90*xscale,centerY-38*yscale)
	line1:setStrokeColor(0)
	line1.strokeWidth =3
	screenGroup:insert(line1)

	denominator1Text = display.newText(groupnum/commondenom,centerX+60*xscale,centerY-30,"Comic Relief",24)
	denominator1Text:setFillColor(0)
	screenGroup:insert(denominator1Text)


end

function fraction2newSceneListener()
	storyboard.purgeScene("fraction2")
	storyboard.reloadScene()
end




function fraction2Game(n)
	local screenGroup = n
	fraction2ShowNumbers(screenGroup)
	fraction2showChoices(screenGroup)

end


function fraction2showChoices(n)
	local screenGroup = n
	startTime = system.getTimer()
	questionText = display.newText("Which is the simplified form?", centerX, centerY+120*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
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
	fraction2generateAnswerText()
	
	answer = display.newText(asteroidnum/commondenom,b[1],centerY+80*yscale, "Comic Relief",24)
	answer:setFillColor(0)
	function fraction2listener()
		fraction2correctResponseListener(screenGroup)
	end
	answer:addEventListener("tap", fraction2listener)
	screenGroup:insert(answer)
	
	answerline = display.newLine(b[1]-20*xscale,centerY+100*yscale,b[1]+20*xscale,centerY+100*yscale)
	answerline:setStrokeColor(0)
	answerline.strokeWidth =3
	answerline:addEventListener("tap", fraction2listener)
	screenGroup:insert(answerline)

	answerdenom = display.newText(groupnum/commondenom,b[1],centerY+115*yscale, "Comic Relief",24)
	answerdenom:setFillColor(0)
	answerdenom:addEventListener("tap", fraction2listener)
	screenGroup:insert(answerdenom)

	answer1 = display.newText(asteroidnum1,b[2],centerY+80*yscale, "Comic Relief", 24)
	answer1:setFillColor(0,0,0)
	local function listener1()
		fraction2incorrectResponseListener1(screenGroup)
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
		fraction2incorrectResponseListener2(screenGroup)
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
		fraction2incorrectResponseListener3(screenGroup)
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

function fraction2generateAnswerText()
	
	asteroidnum1 = math.random(1,10)
	groupnum1 = math.random(1,20)
	while groupnum1<=asteroidnum1 or (asteroidnum1==asteroidnum/commondenom and groupnum1 == groupnum/commondenom) do
		groupnum1 = math.random(1,20)
		asteroidnum1 = math.random(1,10)
	end

	asteroidnum2 = math.random(1,10)
	groupnum2 = math.random(1,20)
	while groupnum2<=asteroidnum2 or (asteroidnum2==asteroidnum/commondenom and groupnum2 == groupnum/commondenom) do
		groupnum2 = math.random(1,20)
		asteroidnum2 = math.random(1,10)
	end
	asteroidnum3 = math.random(1,10)
	groupnum3 = math.random(1,20)
	while groupnum3<=asteroidnum3 or (asteroidnum3==asteroidnum/commondenom and groupnum3 == groupnum/commondenom) do
		groupnum3 = math.random(1,20)
		asteroidnum3 = math.random(1,10)
	end
end


function fraction2correctResponseListener(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	storeDD(1,totalTime,asteroidnum,groupnum,0,round,6)
	questionCount = questionCount + 1

	fraction2removeAnswers(screenGroup)
	local reward = display.newText("Good Job!", centerX+70*xscale,centerY+50,300,0,"Comic Relief", 30)
	reward:setFillColor(0)
	screenGroup:insert(reward)

	fraction2ShowAnswer(screenGroup)

	local myFunction = function() fraction2newSceneListener() end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)

	
end


function fraction2incorrectResponseListener1(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	questionCount = questionCount + 1
	storeDD(0,totalTime,asteroidnum1,groupnum1,0,round,6)
	fraction2wrongAnswer(screenGroup)
	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end

function fraction2incorrectResponseListener2(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	questionCount = questionCount + 1
	storeDD(0,totalTime,asteroidnum2,groupnum2,0,round,6)
	fraction2wrongAnswer(screenGroup)

	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end

function fraction2incorrectResponseListener3(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	questionCount = questionCount + 1
	storeDD(0,totalTime,asteroidnum3,groupnum3,0,round,6)
	fraction2wrongAnswer(screenGroup)
	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end


function fraction2removeAnswers(n)
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
	answer:removeEventListener("tap",fraction2listener)
	answerline:removeEventListener("tap",fraction2listener)
	answerdenom:removeEventListener("tap",fraction2listener)
	

end

function fraction2wrongAnswer(n)
	local screenGroup = n
	fraction2removeAnswers(screenGroup)
	questionText =display.newText( "Oops, the correct choice was", centerX, centerY+140*yscale,450*xscale,200*yscale, "Comic Relief", 18 )
	questionText:setFillColor(0)
	screenGroup:insert(questionText)

	fraction2ShowAnswer(screenGroup)

	local myFunction = function() fraction2newSceneListener() end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
end


function endfraction2Game(n)
	local screenGroup = endGroup
	screenGroup:remove(myText)
	myText = display.newText("Congratulations! You successfully divided "..asteroidnum.." by".. groupnum..", to form "..groupnum.." groups of "..(asteroidnum/2)..".", centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	storeDD(1,totalTime,asteroidnum,groupnum,asteroidnum,round,6)

	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", fraction2goHome)
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