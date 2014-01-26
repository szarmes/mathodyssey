---------------------------------------------------------------------------------
--
-- timetrials.lua
--This scene is the time trial mini game
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local widget = require( "widget" )
local scene = storyboard.newScene()
storyboard.removeAll()

local minute = "images/easyminute.png"
local hour = "images/easyhour.png"

local r1 = 30%720 --rotations for clock1
local r2 = 750%720 --rotations for clock2
local ha --hours answer
local ma --minutes answer
local before = false
local first = true


---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local instructions = "Welcome to the Time Trials! In this level, your task is to figure out the amount of time that has passed from clock 1 to clock 2, using your addition and subtraction skills!"

local function continue()
	storyboard.gotoScene( "menu", "fade", 2000 )
end


-- Called when the scene's view does not exist:
function scene:createScene( event )
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

	minute1 = display.newImage(minute, centerX-120, centerY-60)
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
	r1 = math.random(20)*30
	r2 = math.random(20)*30
	while (r2==r1) do
		r2 = math.random(20)*30
	end

	ha = math.abs(math.floor(math.abs(r1-r2)/60)) --hours answer
	ma = math.abs(math.abs(r1-r2) -(ha*60)) --minutes answer
	before = (r2<r1)

	if (first) then
		local myFunction = function() makeFirstDisappear(screenGroup) end
		timer.performWithDelay(2000, myFunction)
		first = false
	else 
		showChoices(screenGroup)
	end



end

function makeFirstDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	showAnswer(screenGroup)
end

function showAnswer(n)
	local screenGroup = n
	answerText = ""

	if (before) then
		answerText =display.newText( "In this case, Clock 1 is "..ha.." hours and "..ma.." minutes ahead of Clock 2", centerX, centerY+140,500,200, "Komika Display", 20 )		
	else
		answerText =display.newText( "In this case, Clock 1 is "..ha.." hours and " ..ma.." minutes behind Clock 2", centerX, centerY+140,500,200, "Komika Display", 20 )
	end
	answerText:setFillColor(0)
	screenGroup:insert(answerText)

	go = display.newImage("images/go.png", centerX+200, centerY+120)
	go:scale(0.5,0.5)
	go:addEventListener("tap", newSceneListener)
	screenGroup:insert(go)


end

function showChoices(n)

	
end

function newSceneListener()
	storyboard.purgeScene("timetrials")
	storyboard.reloadScene()
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