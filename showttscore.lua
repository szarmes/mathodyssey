---------------------------------------------------------------------------------
--
-- goodjob.lua
--This scene will flash "Good Job" then return to the previous scene
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
storyboard.removeAll()
require "timetrials"


local attemptCount=0
local correctCount=0



  
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY

local function goNext()
	storyboard.purgeAll()
	storyboard.gotoScene( "menu")
end


-- Called when the scene's view does not exist:
function scene:createScene( event )
	storyboard.purgeScene("telltime")
	storyboard.purgeScene("timetrials")
	storyboard.purgeScene("timetrialshard")
	local screenGroup = self.view
	attemptCount=0
	correctCount = 0
	round = -1
	for row in db:nrows("SELECT * FROM timeTrialsScore") do
		round = row.round
	end
	for row in db:nrows("SELECT * FROM timeTrialsScore") do
 	if row.round == round then
 		attemptCount = attemptCount+1
 		if row.correct == 1 then
 			correctCount= correctCount+1
 		end
 	end
end
	bg = display.newImage("images/ttbg.png", centerX,centerY+30)
	bg:scale(0.7,0.7)
	screenGroup:insert(bg)
	--display.setDefault( "background", 1, 1, 1 )
	local reward = display.newText("You answered "..correctCount.." out of "..attemptCount.." questions correctly!", centerX+70,centerY,300,0,"Comic Relief", 30)
	reward:setFillColor(0)
	screenGroup:insert(reward)

	continue = display.newImage("images/continue.png", centerX+200, centerY+140)
	continue:scale(0.3,0.3)

	continue:addEventListener("tap", goNext)
	screenGroup:insert(continue)
	
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	--timer.performWithDelay(500,continue,1)

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	
end


function moveCatListener(event) --sample listener
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