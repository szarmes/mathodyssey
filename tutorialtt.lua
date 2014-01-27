---------------------------------------------------------------------------------
--
-- tutorialtt.lua
--This scene is the time trial mini game
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local widget = require( "widget" )
require "dbFile"

local scene = storyboard.newScene()
storyboard.removeAll()

local minute = "images/easyminute.png"
local hour = "images/easyhour.png"
local r1 = 30%720 --rotations for clock1
local r2 = 750%720 --rotations for clock2
local first = true
local round = -1
questionCount = 0
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local instructions = "Welcome to the Time Trials! In this level, your task is to figure out the amount of time that has passed from clock 1 to clock 2, using your addition and subtraction skills!"
local instructions1 = "To do this, count how many hours the hour hand (blue) in Clock 2 is in front of the hour hand in Clock 1."
local instructions2 = "Then count how many minutes the minute hand (red) in Clock 2 is in front of the minute hand in Clock 1."
local instructions3 = "An easier way to find the answer is to subtract the numbers that the hands in Clock 2 point to from the corresponding hands in Clock 1."
local instructions4 = "It's easier than you think. Give it a shot!"

local function goHome()
	round = -1
	questionCount = 0
	storyboard.gotoScene( "menu", "fade", 500 )
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	storyboard.reloadScene()
	local screenGroup = self.view
	display.setDefault( "background", 1, 1, 1 )

	if (first) then
		myText = display.newText( instructions, centerX, centerY+140,500,200, "Komika Display", 20 )
		myText:setFillColor(0)
		screenGroup:insert(myText)
	end

	newQuestion(screenGroup)
	displayClocks(screenGroup)

	
	
	--image.touch = onSceneTouch
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )

	if questionCount>=3 then
		round = -1
		questionCount = 0
		storyboard.gotoScene("showttscore" )
	end
	
	if round == -1 then
		for row in db:nrows("SELECT * FROM timeTrialsScore ORDER BY id DESC") do
		  round = row.round+1
		  break
		end
	end
	generateAnswers()
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	
end

function displayClocks(n)
	local screenGroup = n
	clock1 = display.newImage("images/clock.png", centerX-120, centerY-60)
	clock1:scale(0.7,0.7)
	screenGroup:insert(clock1)

	pm1 = display.newText("PM",centerX-40,centerY, "Komika Display", 20)
	pm1:setFillColor(0)
	screenGroup:insert(pm1)

	minute1 = display.newImage(minute, centerX-120, centerY-60, "Komika Display", 20)
	minute1:scale(0.8,0.8)
	minute1.anchorY = 1
	screenGroup:insert(minute1)

	hour1 = display.newImage(hour, centerX-120, centerY-60)
	hour1:scale(0.7,0.7)
	hour1.anchorY = 1
	screenGroup:insert(hour1)

	clock2 = display.newImage("images/clock.png", centerX+120, centerY-60)
	clock2:scale(0.7,0.7)
	screenGroup:insert(clock2)

	pm2 = display.newText("PM",centerX+200,centerY, "Komika Display", 20)
	pm2:setFillColor(0)
	screenGroup:insert(pm2)

	minute2 = display.newImage(minute, centerX+120, centerY-60)
	minute2:scale(0.8,0.8)
	minute2.anchorY = 1
	screenGroup:insert(minute2)

	hour2 = display.newImage(hour, centerX+120, centerY-60)
	hour2:scale(0.7,0.7)
	hour2.anchorY = 1
	screenGroup:insert(hour2)

	title1 = display.newText( "Clock 1", centerX-200, centerY-140, "Komika Display", 20 )
	title1:setFillColor(0)
	screenGroup:insert(title1)

	title2 = display.newText( "Clock 2", centerX+40, centerY-140, "Komika Display", 20 )
	title2:setFillColor(0)
	screenGroup:insert(title2)

	home = display.newImage("images/home.png",display.contentWidth,30)
	home:scale(0.3,0.3)
	home:addEventListener("tap", goHome)
	screenGroup:insert(home)

	rotate()

end


function rotate() --set up the times
	minute1:rotate(6*r1)
	hour1:rotate(0.5*r1)
	
	minute2:rotate(6*r2)
	hour2:rotate(0.5*r2)
end


function newQuestion(n) -- this will make a new question
	local screenGroup = n
	r1 = math.random(12)*30
	r2 = math.random(23)*30
	while (r2<=r1) do
		r2 = math.random(23)*30
	end

	ha = math.abs(math.floor(math.abs(r1-r2)/60)) --hours answer
	ma = math.abs(math.abs(r1-r2) -(ha*60)) --minutes answer
	before = (r2<r1)

	if (first) then
		local myFunction = function() makeFirstDisappear(screenGroup) end
		continue = display.newImage("images/continue.png", centerX+200, centerY+140)
		continue:scale(0.3,0.3)

		continue:addEventListener("tap", myFunction)
		screenGroup:insert(continue)
	else 
		showChoices(screenGroup)
	end



end

function makeFirstDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( instructions1, centerX, centerY+140,500,200, "Komika Display", 20 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myFunction = function() makeSecondDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200, centerY+140)
	continue:scale(0.3,0.3)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
	--showAnswer(screenGroup)
end

function makeSecondDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( instructions2, centerX, centerY+140,500,200, "Komika Display", 20 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myFunction = function() makeThirdDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200, centerY+140)
	continue:scale(0.3,0.3)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
	--showAnswer(screenGroup)
end

function makeThirdDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( instructions3, centerX, centerY+140,500,200, "Komika Display", 20 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myFunction = function() makeFourthDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200, centerY+140)
	continue:scale(0.3,0.3)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
	--showAnswer(screenGroup)
end

function makeFourthDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( instructions4, centerX, centerY+140,500,200, "Komika Display", 20 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myFunction = function() makeFifthDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200, centerY+140)
	continue:scale(0.3,0.3)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
	--showAnswer(screenGroup)
end

function makeFifthDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)
	first = false
	go = display.newImage("images/go.png", centerX+200, centerY+120)
	go:scale(0.5,0.5)
	go:addEventListener("tap", newSceneListener)
	screenGroup:insert(go)
end




function showChoices(n)
	local screenGroup = n
	startTime = system.getTimer()
	questionText =display.newText( "How far ahead of Clock 1 is Clock 2?", centerX, centerY+140,500,200, "Komika Display", 20 )
	questionText:setFillColor(0)
	screenGroup:insert(questionText)
	a={50,175,300,425}
	b = {}
	count = 4

	while (count>0) do --randomize the array of x values
		local r = math.random(1,count)
		b[count] = a[r]
		table.remove(a, r)
		count=count-1
	end
	generateAnswerText()
	answer = display.newText(answerText,b[1],centerY+100, 125,0, "Komika Display", 16)
	answer:setFillColor(0)
	answer:addEventListener("tap", correctResponseListener)
	screenGroup:insert(answer)

	answer1 = nil
	answer1 = display.newText(answer1Text,b[2],centerY+100,125,0, "Komika Display", 16)
	answer1:setFillColor(0,0,0)
	local function listener1()
		incorrectResponseListener1(screenGroup)
	end
	answer1:addEventListener("tap", listener1)
	screenGroup:insert(answer1)

	answer2 = nil
	answer2 = display.newText(answer2Text,b[3],centerY+100,125,0, "Komika Display", 16)
	answer2:setFillColor(0,0,0)
	local function listener2()
		incorrectResponseListener2(screenGroup)
	end
	answer2:addEventListener("tap", listener2)
	screenGroup:insert(answer2)

	answer3 = nil
	answer3 = display.newText(answer3Text,b[4],centerY+100,125,0, "Komika Display", 16)
	answer3:setFillColor(0,0,0)
	local function listener3()
		incorrectResponseListener3(screenGroup)
	end
	answer3:addEventListener("tap", listener3)
	screenGroup:insert(answer3)
end

function newSceneListener()
	storyboard.purgeScene("timetrials")
	storyboard.reloadScene()
end

function incorrectResponseListener1(n)
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	--storeTimeTrials(0,totalTime,ha,ma,ha1,ma1,r1,r2,round)
	questionCount = questionCount + 1
	storyboard.purgeScene("timetrials")
	storyboard.gotoScene("tryagain","fade",500)
end

function incorrectResponseListener2(n)
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	--storeTimeTrials(0,totalTime,ha,ma,ha2,ma2,r1,r2,round)
	questionCount = questionCount + 1
	storyboard.purgeScene("timetrials")
	storyboard.gotoScene("tryagain","fade",500)
end
function incorrectResponseListener3(n)
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	--storeTimeTrials(0,totalTime,ha,ma,ha3,ma3,r1,r2,round)
	questionCount = questionCount + 1
	storyboard.purgeScene("timetrials")
	storyboard.gotoScene("tryagain","fade",500)
end

function correctResponseListener()
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	--storeTimeTrials(1,totalTime,ha,ma,ha,ma,r1,r2,round)
	questionCount = questionCount + 1
	storyboard.purgeScene("timetrials")
	storyboard.gotoScene("goodjob","fade",500)
end

function generateAnswers()
	r3 = math.abs(r1-r2)
	r31 = r3+math.random(-4,4)*30
	while r31<0 or r31 == r3 do
		r31 = r3+math.random(-4,4)*30
	end
	r32 = r3+math.random(-4,4)*30
	while r32<0 or r32 == r3 or r32==r31 do
		r32 = r3+math.random(-4,4)*30
	end
	r33 = r3+math.random(-4,4)*30
	while r33<0 or r33 == r3 or r33 == r31 or r33 == r32 do
		r33 = r3+math.random(-4,4)*30
	end

	ha1 = math.abs(math.floor(math.abs(r31)/60)) --hours answer
	ma1 = math.abs(math.abs(r31) -(ha1*60)) --minutes answer
	ha2 = math.abs(math.floor(math.abs(r32)/60)) --hours answer
	ma2 = math.abs(math.abs(r32) -(ha2*60)) --minutes answer
	ha3 = math.abs(math.floor(math.abs(r33)/60)) --hours answer
	ma3 = math.abs(math.abs(r33) -(ha3*60)) --minutes answer



end

function generateAnswerText()
	if (ha == 1) then
		answerText = ha.." hour and \n"..ma.." minutes"
	else
		answerText = ha.." hours and \n"..ma.." minutes"
	end
	if (ha1 == 1) then
		answer1Text = ha1.." hour and \n"..ma1.." minutes"
	else
		answer1Text = ha1.." hours and \n"..ma1.." minutes"
	end
	if (ha2 == 1) then
		answer2Text = ha2.." hour and \n"..ma2.." minutes"
	else
		answer2Text = ha2.." hours and \n"..ma2.." minutes"
	end
	if (ha3 == 1) then
		answer3Text = ha3.." hour and \n"..ma3.." minutes"
	else
		answer3Text = ha3.." hours and \n"..ma3.." minutes"
	end
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