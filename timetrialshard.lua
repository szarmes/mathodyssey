---------------------------------------------------------------------------------
--
-- timetrials.lua
--This scene is the time trial mini game
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local widget = require( "widget" )
require "dbFile"
local tryAgain = require("tryagain")

local scene = storyboard.newScene()
storyboard.removeAll()

local minute = "images/easyminute.png"
local hour = "images/easyhour.png"
local r1 = 30%720 --rotations for clock1
local r2 = 750%720 --rotations for clock2
first = true
local round = -1
questionCount = 0
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local instructions = "You have made it to the final location on this planet. Congratulations. But tough times still await you."
local instructions1 = "Your time telling skills will be truly tested in this mission. You must keep your composure and remain steadfast."
local instructions2 = "Coming this far and falling short is not an option."

local function timetrialshardgoHome()
	first = true
	round = -1
	questionCount = 0
	storyboard.gotoScene( "menu")
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	storyboard.reloadScene()
	storyboard.purgeScene("tryagain")
	local screenGroup = self.view	
	bg = display.newImage("images/ttbg.png", centerX,centerY+30*yscale)
	bg:scale(0.8*xscale,0.8*yscale)
	screenGroup:insert(bg)
	if (first) then

		bubble = display.newImage("images/bubble.png", centerX-20*xscale,centerY+100*yscale)
		bubble:scale(0.74*xscale,0.43*yscale)
		bubble.alpha = 0.7
		screenGroup:insert(bubble)
		dog = display.newImage("images/astronaut.png", centerX-260*xscale, centerY+118*yscale)
		dog:scale(0.2*xscale, 0.2*yscale)
		dog:rotate(30)
		screenGroup:insert(dog)
		myText = display.newText( instructions, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
		myText:setFillColor(0)
		screenGroup:insert(myText)
	end
	timetrialshardnewQuestion(screenGroup)
	timetrialsharddisplayClocks(screenGroup)
	timetrialshardgenerateAnswers()
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	if questionCount>=10 then
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
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
end

-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
end

function timetrialsharddisplayClocks(n)
	local screenGroup = n
	clock1 = display.newImage("images/clock.png", centerX-120*xscale, centerY-60*yscale)
	clock1:scale(0.7*xscale,0.7*yscale)
	screenGroup:insert(clock1)

	pm1 = display.newText("PM",centerX-40*xscale,centerY, "Comic Relief", 18)
	pm1:setFillColor(0)
	screenGroup:insert(pm1)

	minute1 = display.newImage(minute, centerX-120*xscale, centerY-60*yscale, "Comic Relief", 18)
	minute1:scale(0.8*xscale,0.8)
	minute1.anchorY = 1
	screenGroup:insert(minute1)

	hour1 = display.newImage(hour, centerX-120*xscale, centerY-60*yscale)
	hour1:scale(0.6*xscale,0.6*yscale)
	hour1.anchorY = 1
	screenGroup:insert(hour1)

	clock2 = display.newImage("images/clock.png", centerX+120*xscale, centerY-60*yscale)
	clock2:scale(0.7*xscale,0.7*yscale)
	screenGroup:insert(clock2)

	pm2 = display.newText("PM",centerX+200*xscale,centerY, "Comic Relief", 18)
	pm2:setFillColor(0)
	screenGroup:insert(pm2)

	minute2 = display.newImage(minute, centerX+120*xscale, centerY-60*yscale)
	minute2:scale(0.8*xscale,0.8*yscale)
	minute2.anchorY = 1
	screenGroup:insert(minute2)

	hour2 = display.newImage(hour, centerX+120*xscale, centerY-60*yscale)
	hour2:scale(0.6*xscale,0.6*yscale)
	hour2.anchorY = 1
	screenGroup:insert(hour2)

	title1 = display.newText( "Clock 1", centerX-200*xscale, centerY-140*yscale, "Comic Relief", 18 )
	title1:setFillColor(0)
	screenGroup:insert(title1)

	title2 = display.newText( "Clock 2", centerX+40*xscale, centerY-140*yscale, "Comic Relief", 18 )
	title2:setFillColor(0)
	screenGroup:insert(title2)

	home = display.newImage("images/home.png",display.contentWidth-20*xscale,22*yscale)
	home:scale(0.3*xscale,0.3*yscale)
	home:addEventListener("tap", timetrialshardgoHome)
	screenGroup:insert(home)

	timetrialshardrotate()
end

function timetrialshardrotate() --set up the times
	minute1:rotate(6*r1)
	hour1:rotate(0.5*r1)
	
	minute2:rotate(6*r2)
	hour2:rotate(0.5*r2)
end

function timetrialshardnewQuestion(n) -- this will make a new question
	local screenGroup = n
	r1 = math.random(24)*15
	r2 = math.random(47)*15
	while (r2<=r1) do
		r2 = math.random(47)*15
	end

	ha = math.abs(math.floor(math.abs(r1-r2)/60)) --hours answer
	ma = math.abs(math.abs(r1-r2) -(ha*60)) --minutes answer
	before = (r2<r1)

	if (first) then
		local myFunction = function() timetrialshardmakeFirstDisappear(screenGroup) end
		continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
		continue:scale(0.3*xscale,0.3*yscale)

		continue:addEventListener("tap", myFunction)
		screenGroup:insert(continue)
		
	else 
		timetrialshardshowChoices(screenGroup)
	end
end

function timetrialshardmakeFirstDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( instructions1, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myFunction = function() timetrialshardmakeSecondDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
	--showAnswer(screenGroup)
end

function timetrialshardmakeSecondDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( instructions2, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	go = display.newImage("images/go.png", centerX+200*xscale, centerY+120*yscale)
	go:scale(0.5*xscale,0.5*yscale)
	go:addEventListener("tap", timetrialshardnewSceneListener)
	screenGroup:insert(go)


	first = false
end

function timetrialshardshowChoices(n)
	local screenGroup = n
	startTime = system.getTimer()
	questionText =display.newText( "How far ahead of Clock 1 is Clock 2?", centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
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
	timetrialshardgenerateAnswerText()
	tryAgain.TAanswerText = answerText
	answer = display.newText(answerText,b[1],centerY+100, 125*xscale,0, "Comic Relief", 16)
	answer:setFillColor(0)
	function listener()
		timetrialshardcorrectResponseListener(screenGroup)
	end
	answer:addEventListener("tap", listener)
	screenGroup:insert(answer)

	answer1 = nil
	answer1 = display.newText(answer1Text,b[2],centerY+100,125*xscale,0, "Comic Relief", 16)
	answer1:setFillColor(0,0,0)
	local function listener1()
		timetrialshardincorrectResponseListener1(screenGroup)
	end
	answer1:addEventListener("tap", listener1)
	screenGroup:insert(answer1)

	answer2 = nil
	answer2 = display.newText(answer2Text,b[3],centerY+100,125*xscale,0, "Comic Relief", 16)
	answer2:setFillColor(0,0,0)
	local function listener2()
		timetrialshardincorrectResponseListener2(screenGroup)
	end
	answer2:addEventListener("tap", listener2)
	screenGroup:insert(answer2)

	answer3 = nil
	answer3 = display.newText(answer3Text,b[4],centerY+100,125*xscale,0, "Comic Relief", 16)
	answer3:setFillColor(0,0,0)
	local function listener3()
		timetrialshardincorrectResponseListener3(screenGroup)
	end
	answer3:addEventListener("tap", listener3)
	screenGroup:insert(answer3)
end

function timetrialshardnewSceneListener()
	storyboard.purgeScene("timetrialshard")
	storyboard.reloadScene()
end

function timetrialshardincorrectResponseListener1(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	storeTimeTrials(0,totalTime,ha,ma,ha1,ma1,r1,r2,round,3)
	questionCount = questionCount + 1
	timetrialshardwrongAnswer(screenGroup)
end

function timetrialshardincorrectResponseListener2(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	storeTimeTrials(0,totalTime,ha,ma,ha2,ma2,r1,r2,round,3)
	questionCount = questionCount + 1
	timetrialshardwrongAnswer(screenGroup)
end

function timetrialshardincorrectResponseListener3(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	storeTimeTrials(0,totalTime,ha,ma,ha3,ma3,r1,r2,round,3)
	questionCount = questionCount + 1
	timetrialshardwrongAnswer(screenGroup)
end

function timetrialshardcorrectResponseListener(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	storeTimeTrials(1,totalTime,ha,ma,ha,ma,r1,r2,round,3)
	questionCount = questionCount + 1
	timetrialshardremoveAnswers(screenGroup)
	
	local reward = display.newText("Good Job!", centerX+70*xscale,centerY+50*yscale,300*xscale,0,"Comic Relief", 30)
	reward:setFillColor(0)
	screenGroup:insert(reward)

	local myFunction = function() timetrialshardnewSceneListener() end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)	
end

function timetrialshardgenerateAnswers()
	math.randomseed( os.time() )
	r5 = math.random(46)*15
	ha1 = math.floor(r5/60) --hours answer
	ma1 = math.abs(r5 -(ha1*60))  --minutes answer
	while(((ha1*60)+ma1 == (ha*60)+ma)) do
		r5 = math.random(46)*15
		ha1 = math.floor(r5/60) --hours answer
		ma1 = math.abs(r5 -(ha1*60)) 
	end
	r3 = math.random(46)*15
	ha2 = math.floor(r3/60) --hours answer
	ma2 = math.abs(r3 -(ha2*60)) 
	while(((ha2*60)+ma2 == (ha*60)+ma)or((ha2*60)+ma2 == (ha1*60)+ma1)) do
		r3 = math.random(46)*15
		ha2 = math.floor(r3/60) --hours answer 
		ma2 = math.abs(r3 -(ha2*60))
	end
	r4 = math.random(46)*15
	ha3 = math.floor(r4/60) --hours answer
	ma3 = math.abs(r4 -(ha3*60))
	while((((ha3*60)+ma3 == (ha*60)+ma)or((ha3*60)+ma3 == (ha1*60)+ma1))or((ha3*60)+ma3 == (ha2*60)+ma2)) do
		r4 = math.random(46)*15
		ha3 = math.floor(r4/60) --hours answer
		ma3 = math.abs(r4 -(ha3*60))
	end
end

function timetrialshardgenerateAnswerText()
	timetrialshardgenerateAnswers()
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

function timetrialshardremoveAnswers(n)
	local screenGroup = n
	--screenGroup:remove(answer)
	screenGroup:remove(answer1)
	screenGroup:remove(answer2)
	screenGroup:remove(answer3)
	screenGroup:remove(questionText)
	answer:removeEventListener("tap",listener)
end

function timetrialshardwrongAnswer(n)
	local screenGroup = n
	timetrialshardremoveAnswers(screenGroup)
	questionText =display.newText( "Oops, the correct answer was", centerX, centerY+140*yscale,450*xscale,200*yscale, "Comic Relief", 18 )
	questionText:setFillColor(0)
	screenGroup:insert(questionText)

	local myFunction = function() timetrialshardnewSceneListener() end
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