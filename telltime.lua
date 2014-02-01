---------------------------------------------------------------------------------
--
-- telltime.lua
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
first = true
local round = -1
ttcorrectCount = 0
questionCount = 0
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
local hourtime 
local minutetime
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local instructions = "Welcome to the Time Trials. Your first assignment in this vacant desert is to figure out what time it is."
local instructions1 = "The hour hand, the shorter one, tells you what hour of the day it is."
local instructions2 = "The minute hand, the longer one, tells you how many minutes into that hour it is."
local instructions3 = "Be careful, you need to multiply the number the minute hand points to by 5!"
local instructions4 = "For instance, if the minute hand points to the 6, that means 30 minutes of that hour has passed."
local instructions5 = "But, if the minute hand points straight up to 12 then 0 minutes have passed and the hour has just started."
local instructions6
local instructions7 = "Completing this task will take you one step forward in time."

local function goHome()
	first = true
	round = -1
	ttcorrectCount = 0
	storyboard.gotoScene( "menu" )
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	storyboard.purgeScene("howtoplay")
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
	newQuestion(screenGroup)
	displayClocks(screenGroup)
	generateAnswers()
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )

	if questionCount>=10 then
		round = -1
		questionCount = 0
		first = true
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

function displayClocks(n)
	local screenGroup = n
	clock1 = display.newImage("images/clock.png", centerX, centerY-60*yscale)
	clock1:scale(0.7*yscale,0.7*yscale)
	screenGroup:insert(clock1)

	pm1 = display.newText("PM",centerX+90*xscale,centerY, "Comic Relief", 18)
	pm1:setFillColor(0)
	screenGroup:insert(pm1)

	minute1 = display.newImage(minute, centerX, centerY-60*yscale, "Comic Relief", 18)
	minute1:scale(0.8*xscale,0.8*yscale)
	minute1.anchorY = 1
	screenGroup:insert(minute1)

	hour1 = display.newImage(hour, centerX, centerY-60*yscale)
	hour1:scale(0.6*xscale,0.6*yscale)
	hour1.anchorY = 1
	screenGroup:insert(hour1)

	title1 = display.newText( "Clock 1", centerX-90*xscale, centerY-140*yscale, "Comic Relief", 18 )
	title1:setFillColor(0)
	screenGroup:insert(title1)

	home = display.newImage("images/home.png",display.contentWidth-20*xscale,22*yscale)
	home:scale(0.3*xscale,0.3*yscale)
	home:addEventListener("tap", goHome)
	screenGroup:insert(home)

	
	rotate()
end


function rotate() --set up the times
	minute1:rotate(6*r1)
	hour1:rotate(0.5*r1)
	
	hourtime =(0.5*(r1))%12
	minutetime = (6*(r1))%30
end


function newQuestion(n) -- this will make a new question
	local screenGroup = n
	r1 = math.random(23)*30

	hourtime = math.floor(r1/60)%12
	if hourtime == 0 then
		hourtime = 12
	end
	if (r1/30)%2 == 0 then
		instructions6 = "Using these rules you can see that it's "..hourtime..":".."00 pm. All questions will be in pm."
	else 
		instructions6 = "Using these rules you can see that it's \n"..hourtime..":".."30 pm. All questions will be in pm."
	end
	ha = math.floor(r1/60) --hours answer
	ma = ((r1/30)%2)*30 

	if (first) then
		local myFunction = function() makeFirstDisappear(screenGroup) end
		continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
		continue:scale(0.3*xscale,0.3*yscale)

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

	myText = display.newText( instructions1, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myFunction = function() makeSecondDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
	--showAnswer(screenGroup)
end

function makeSecondDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( instructions2, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myFunction = function() makeThirdDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
	--showAnswer(screenGroup)
end

function makeThirdDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( instructions3, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myFunction = function() makeFourthDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
	--showAnswer(screenGroup)
end

function makeFourthDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( instructions4, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myFunction = function() makeFifthDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
	--showAnswer(screenGroup)
end

function makeFifthDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( instructions5, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myFunction = function() makeSixthDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
	--showAnswer(screenGroup)
end

function makeSixthDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( instructions6, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myFunction = function() makeSeventhDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
	--showAnswer(screenGroup)
end

function makeSeventhDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( instructions7, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	first = false
	go = display.newImage("images/go.png", centerX+200*xscale, centerY+120*yscale)
	go:scale(0.5*xscale,0.5*yscale)
	go:addEventListener("tap", newSceneListener)
	screenGroup:insert(go)
end

function showChoices(n)
	local screenGroup = n
	startTime = system.getTimer()
	questionText =display.newText( "What time is it?", centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
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
	generateAnswerText()
	
	answer = display.newText(answerText,b[1],centerY+100*yscale, 125*xscale,0, "Comic Relief", 16)
	answer:setFillColor(0)
	function listener()
		correctResponseListener(screenGroup)
	end
	answer:addEventListener("tap", listener)
	screenGroup:insert(answer)

	answer1 = nil
	answer1 = display.newText(answer1Text,b[2],centerY+100*yscale,125*xscale,0, "Comic Relief", 16)
	answer1:setFillColor(0,0,0)
	local function listener1()
		incorrectResponseListener1(screenGroup)
	end
	answer1:addEventListener("tap", listener1)
	screenGroup:insert(answer1)

	answer2 = nil
	answer2 = display.newText(answer2Text,b[3],centerY+100*yscale,125*xscale,0, "Comic Relief", 16)
	answer2:setFillColor(0,0,0)
	local function listener2()
		incorrectResponseListener2(screenGroup)
	end
	answer2:addEventListener("tap", listener2)
	screenGroup:insert(answer2)

	answer3 = nil
	answer3 = display.newText(answer3Text,b[4],centerY+100*yscale,125*xscale,0, "Comic Relief", 16)
	answer3:setFillColor(0,0,0)
	local function listener3()
		incorrectResponseListener3(screenGroup)
	end
	answer3:addEventListener("tap", listener3)
	screenGroup:insert(answer3)
end

function newSceneListener()
	storyboard.purgeScene("telltime")
	storyboard.reloadScene()
end

function incorrectResponseListener1(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	storeTimeTrials(0,totalTime,ha,ma,ha1,ma1,r1,r2,round,1)
	questionCount = questionCount + 1
	wrongAnswer(screenGroup)
end

function incorrectResponseListener2(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	storeTimeTrials(0,totalTime,ha,ma,ha2,ma2,r1,r2,round,1)
	questionCount = questionCount + 1
	wrongAnswer(screenGroup)
end

function incorrectResponseListener3(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	storeTimeTrials(0,totalTime,ha,ma,ha3,ma3,r1,r2,round,1)
	questionCount = questionCount + 1
	
	wrongAnswer(screenGroup)
end

function correctResponseListener(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	storeTimeTrials(1,totalTime,ha,ma,ha,ma,r1,r2,round,1)
	questionCount = questionCount + 1
	removeAnswers(screenGroup)
	local reward = display.newText("Good Job!", centerX+70*xscale,centerY+50*yscale,300*xscale,0,"Comic Relief", 30)
	reward:setFillColor(0)
	screenGroup:insert(reward)

	local myFunction = function() newSceneListener() end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)	
end

function generateAnswers()
	math.randomseed( os.time() )
	r2 = math.random(23)*30
	ha1 = math.floor(r2/60) --hours answer
	ma1 = ((r2/30)%2)*30  --minutes answer
	while(((ha1/60)+ma1 == (ha/60)+ma)) do
		r2 = math.random(23)*30
		ha1 = math.floor(r2/60) --hours answer
		ma1 = ((r2/30)%2)*30  
	end
	r3 = math.random(23)*30
	ha2 = math.floor(r3/60) --hours answer
	ma2 = ((r3/30)%2)*30  
	while(((ha2/60)+ma2 == (ha/60)+ma)or((ha2/60)+ma2 == (ha1/60)+ma1)) do
		r3 = math.random(23)*30
		ha2 = math.floor(r3/60) --hours answer 
		ma2 = ((r3/30)%2)*30
	end
	r4 = math.random(23)*30
	ha3 = math.floor(r4/60) --hours answer
	ma3 =  ((r4/30)%2)*30 
	while((((ha3/60)+ma3 == (ha/60)+ma)or((ha3/60)+ma3 == (ha1/60)+ma1))or((ha3/60)+ma3 == (ha2/60)+ma2)) do
		r4 = math.random(23)*30
		ha3 = math.floor(r4/60) --hours answer
		ma3 =  ((r4/30)%2)*30 
	end
	

	

	if ha == 0 then 
		ha = 12
	end
	if ha1 == 0 then 
		ha1 = 12
	end
	if ha2 == 0 then 
		ha2 = 12
	end
	if ha3 == 0 then 
		ha3 = 12
	end


end

function generateAnswerText()
	answerText = ha..":"..ma.." pm"
	answer1Text = ha1..":"..ma1.." pm"
	answer2Text = ha2..":"..ma2.." pm"
	answer3Text = ha3..":"..ma3.." pm"

	if ma == 0 then 
		answerText = ha..":"..ma.."0 pm"
	end
	if ma1 == 0 then 
		answer1Text = ha1..":"..ma1.."0 pm"
	end
	if ma2 == 0 then 
		answer2Text = ha2..":"..ma2.."0 pm"
	end
	if ma3 == 0 then 
		answer3Text = ha3..":"..ma3.."0 pm"
	end



end

function removeAnswers(n)
	local screenGroup = n
	--screenGroup:remove(answer)
	screenGroup:remove(answer1)
	screenGroup:remove(answer2)
	screenGroup:remove(answer3)
	screenGroup:remove(questionText)
	answer:removeEventListener("tap",listener)

end

function wrongAnswer(n)
	local screenGroup = n
	removeAnswers(screenGroup)
	questionText =display.newText( "Oops, the correct answer was", centerX, centerY+140*xscale,450*xscale,200*yscale, "Comic Relief", 18 )
	questionText:setFillColor(0)
	screenGroup:insert(questionText)

	local myFunction = function() newSceneListener() end
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