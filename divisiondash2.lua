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
local dd2instructions = "Your division skills will now be put to the test."
local dd2instructions1 = "In this mode, the number on top represents the number of asteroids in the field."
local dd2instructions2 = "The number on the bottom represents how many groups the field needs to be split into."
local dd2instructions3 = "Find the answer by figuring out how many asteroids will go into each group to make them have equal amounts."
local dd2instructions4 
local groups
local asteroidnum
local asteroids
local endGroup

local function dd2goHome()
	first = true
	round = -1
	mmcorrectCount = 0
	storyboard.purgeScene("divisiondash2")
	storyboard.gotoScene( "ddselection" )
end


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	endGroup = screenGroup
	bg = display.newImage("images/ddbg.png", centerX,centerY+(30*yscale))
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
		--dd2ShowMultiple(screenGroup)

		myText = display.newText(dd2instructions, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
		myText:setFillColor(0)
		screenGroup:insert(myText)
		dd2ShowNumbers(screenGroup)
	end
	dd2newQuestion(screenGroup)

	home = display.newImage("images/home.png",display.contentWidth-20*xscale,22*yscale)
	home:scale(0.3*xscale,0.3*yscale)
	home:addEventListener("tap", dd2goHome)
	screenGroup:insert(home)
	if first==false then
		hintbutton = display.newImage(companionText,display.contentWidth-20*xscale,90*yscale)
		hintbutton:scale(-0.14*xscale,0.14*yscale)

		local function dd2hint()
			hintbutton:removeEventListener("tap",dd2hint)
			provideHint(screenGroup,dd2instructions3)
		end
		hintbutton:addEventListener("tap",dd2hint)
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

function dd2newQuestion(n) -- this will make a new question
	local screenGroup = n
	if (first) then
		local myfunction = function() dd2makeFirstDisappear(screenGroup) end
		continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
		continue:scale(0.3*xscale,0.3*yscale)
		continue:addEventListener("tap", myfunction)
		screenGroup:insert(continue)
	else 
		dd2Game(n)
	end
end

function dd2ShowNumbers(n)
	local screenGroup = n
	asteroidnum = math.random(3,10)*2
	groupnum = math.random(2,6)
	while asteroidnum%groupnum~=0 do
		groupnum = math.random(2,4)
	end
	numeratorText = display.newText(asteroidnum,centerX-20*xscale,centerY-60*yscale,"Comic Relief",24)
	numeratorText:setFillColor(0)
	screenGroup:insert(numeratorText)

	line = display.newLine(centerX-45*xscale,centerY-38*yscale,centerX+10*xscale,centerY-38*yscale)
	line:setStrokeColor(0)
	line.strokeWidth =3
	screenGroup:insert(line)

	denominatorText = display.newText(groupnum,centerX-20*xscale,centerY-30,"Comic Relief",24)
	denominatorText:setFillColor(0)
	screenGroup:insert(denominatorText)

	equalsText = display.newText("=",centerX+30*xscale,centerY-45*yscale,"Comic Relief",24)
	equalsText:setFillColor(0)
	screenGroup:insert(equalsText)

	solutionText = display.newText("?",centerX+60*xscale,centerY-45*yscale,"Comic Relief",24)
	solutionText:setFillColor(0)
	screenGroup:insert(solutionText)
	if first == false then
		startTime = system.getTimer()
	end
end


function dd2makeFirstDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText(dd2instructions1, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myfunction = function() dd2makeSecondDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myfunction)
	screenGroup:insert(continue)
end

function dd2makeSecondDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText(dd2instructions2, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 16 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myfunction = function() dd2makeThirdDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myfunction)
	screenGroup:insert(continue)
end

function dd2makeThirdDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText(dd2instructions3, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 16 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myfunction = function() dd2makeFourthDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myfunction)
	screenGroup:insert(continue)

end

function dd2makeFourthDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)
	dd2instructions4 = "In this example you would divide the field of "..asteroidnum.." asteroids into "..groupnum.." equal groups of "..(asteroidnum/groupnum).."."
	dd2instructions4 = dd2instructions4.." Good luck out there."
	myText = display.newText(dd2instructions4, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)



	first = false
	go = display.newImage("images/go.png", centerX+200*xscale, centerY+120*yscale)
	go:scale(0.5*xscale,0.5*yscale)
	go:addEventListener("tap", dd2newSceneListener)
	screenGroup:insert(go)

	dd2ShowAnswer(screenGroup)
end

function dd2ShowAnswer(n)
	local screenGroup = n
	screenGroup:remove(solutionText)
	solutionText = display.newText(asteroidnum/groupnum,centerX+60*xscale,centerY-45*yscale,"Comic Relief",24)
	solutionText:setFillColor(0)
	screenGroup:insert(solutionText)


end

function dd2newSceneListener()
	storyboard.purgeScene("divisiondash2")
	storyboard.reloadScene()
end




function dd2Game(n)
	local screenGroup = n
	dd2ShowNumbers(screenGroup)
	dd2showChoices(screenGroup)

end


function dd2showChoices(n)
	local screenGroup = n
	startTime = system.getTimer()
	questionText = display.newText("If you divide "..asteroidnum.. " asteroids into "..groupnum.." groups, how many asteroids are in each group?", centerX, centerY+120*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
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
	dd2generateAnswerText()
	
	answer = display.newText(answerText,b[1],centerY+100*yscale, "Comic Relief",24)
	answer:setFillColor(0)
	function dd2listener()
		dd2correctResponseListener(screenGroup)
	end
	answer:addEventListener("tap", dd2listener)
	screenGroup:insert(answer)

	answer1 = display.newText(answer1Text,b[2],centerY+100*yscale, "Comic Relief", 24)
	answer1:setFillColor(0,0,0)
	local function listener1()
		dd2incorrectResponseListener1(screenGroup)
	end
	answer1:addEventListener("tap", listener1)
	screenGroup:insert(answer1)

	answer2 = display.newText(answer2Text,b[3],centerY+100*yscale, "Comic Relief", 24)
	answer2:setFillColor(0,0,0)
	local function listener2()
		dd2incorrectResponseListener2(screenGroup)
	end
	answer2:addEventListener("tap", listener2)
	screenGroup:insert(answer2)

	answer3 = display.newText(answer3Text,b[4],centerY+100*yscale, "Comic Relief", 24)
	answer3:setFillColor(0,0,0)
	local function listener3()
		dd2incorrectResponseListener3(screenGroup)
	end
	answer3:addEventListener("tap", listener3)
	screenGroup:insert(answer3)

end

function dd2generateAnswerText()
	answerText = asteroidnum/groupnum
	answer1Text = math.random(1,10)
	while answer1Text == answerText do
		answer1Text = math.random(1,10)
	end
	answer2Text = math.random(1,10)
	while answer2Text == answerText or answer2Text == answer1Text do
		answer2Text = math.random(1,10)
	end
	answer3Text = math.random(1,10)
	while answer3Text == answerText or answer3Text == answer1Text or answer3Text == answer2Text do
		answer3Text = math.random(1,10)
	end
end


function dd2correctResponseListener(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	storeDD(1,totalTime,asteroidnum,groupnum,answerText,round,3)
	questionCount = questionCount + 1

	dd2removeAnswers(screenGroup)
	local reward = display.newText("Good Job!", centerX+70*xscale,centerY+50,300,0,"Comic Relief", 30)
	reward:setFillColor(0)
	screenGroup:insert(reward)

	dd2ShowAnswer(screenGroup)

	local myFunction = function() dd2newSceneListener() end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)

	
end


function dd2incorrectResponseListener1(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	questionCount = questionCount + 1
	storeDD(0,totalTime,asteroidnum,groupnum,answer1Text,round,3)
	dd2wrongAnswer(screenGroup)
	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end

function dd2incorrectResponseListener2(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	questionCount = questionCount + 1
	storeDD(0,totalTime,asteroidnum,groupnum,answer2Text,round,3)
	dd2wrongAnswer(screenGroup)

	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end

function dd2incorrectResponseListener3(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	questionCount = questionCount + 1
	storeDD(0,totalTime,asteroidnum,groupnum,answer3Text,round,3)
	dd2wrongAnswer(screenGroup)
	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end


function dd2removeAnswers(n)
	local screenGroup = n
	--screenGroup:remove(answer)
	
	screenGroup:remove(answer1)
	screenGroup:remove(answer2)
	screenGroup:remove(answer3)
	screenGroup:remove(questionText)
	answer:removeEventListener("tap",dd2listener)
	

end

function dd2wrongAnswer(n)
	local screenGroup = n
	dd2removeAnswers(screenGroup)
	questionText =display.newText( "Oops, the correct answer was", centerX, centerY+140*yscale,450*xscale,200*yscale, "Comic Relief", 18 )
	questionText:setFillColor(0)
	screenGroup:insert(questionText)

	dd2ShowAnswer(screenGroup)

	local myFunction = function() dd2newSceneListener() end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
end


function enddd2Game(n)
	local screenGroup = endGroup
	screenGroup:remove(myText)
	myText = display.newText("Congratulations! You successfully divided "..asteroidnum.." by".. groupnum..", to form "..groupnum.." groups of "..(asteroidnum/2)..".", centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	storeDD(1,totalTime,asteroidnum,groupnum,asteroidnum,round,3)

	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", dd2goHome)
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