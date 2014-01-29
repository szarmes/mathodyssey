---------------------------------------------------------------------------------
--
-- tryagain.lua
--This scene will flash "Good Job" then return to the previous scene
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
storyboard.removeAll()
local TAanswerText = ""

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY

local function continue()
	storyboard.purgeAll()
	storyboard.gotoScene( storyboard.getPrevious())
end


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	local correctText = nil
	if storyboard.getPrevious() == "timetrials" then
		bg = display.newImage("images/ttbg.png", centerX,centerY+30)
		bg:scale(0.7,0.7)
		screenGroup:insert(bg)
		correctText = "Clock 2 was "..answerText.." ahead of Clock 1." 
		answerText = nil
	end 
	if storyboard.getPrevious() == "exponentialenergy" then
		bg = display.newImage("images/taeebg.png", centerX,centerY+30)
		bg:scale(0.7,0.7)
		screenGroup:insert(bg)
	end	
	display.setDefault( "background", 1, 1, 1 )
	local reward = display.newText("Sorry, that was incorrect.", centerX,centerY-100,400,0,"Comic Relief", 30)
	reward:setFillColor(0)
	screenGroup:insert(reward)
	if (correctText ~= nil) then
		correction = display.newText(correctText, centerX+100, centerY,600,0, "Comic Relief", 30)
		correction:setFillColor(0)
		screenGroup:insert(correction)
	end
	storyboard.purgeScene(storyboard.getPrevious())
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	timer.performWithDelay(3000,continue,1)
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