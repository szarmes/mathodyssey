---------------------------------------------------------------------------------
--
-- showeescore.lua
--This scene will flash "Good Job" then return to the previous scene
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
storyboard.removeAll()
require "exponentialenergy"


local attemptCount=0
local correctCount=0

local explosionSound = audio.loadStream("sounds/explosion.wav")

  
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY

local function goNext()
	storyboard.removeAll()
	storyboard.gotoScene( "menu")
end


-- Called when the scene's view does not exist:
function scene:createScene( event )
	storyboard.purgeScene("exponentialenergy")
	local screenGroup = self.view
	attemptCount=0
	correctCount = 0
	round = -1
	for row in db:nrows("SELECT * FROM eeScore ORDER BY id DESC") do
		round = row.round
		break
	end
	for row in db:nrows("SELECT * FROM eeScore") do
	 	if row.round == round then
	 		attemptCount = attemptCount+1
	 		if row.correct == 1 then
	 			correctCount= correctCount+1
	 		end
	 	end
	end

	if correctCount == attemptCount then
		bg = display.newImage("images/gjeebg.png", centerX,centerY+30)
		bg:scale(0.7,0.7)
		screenGroup:insert(bg)
	else 
		bg = display.newImage("images/taeebg.png", centerX,centerY+30)
		bg:scale(0.7,0.7)
		screenGroup:insert(bg)
	end

	explosion = display.newImage("images/explosion.png",centerX,centerY)
	explosion:scale(0.2,0.2)
	screenGroup:insert(explosion)

	timer1 = timer.performWithDelay(50,boom,20)
	playExplosion()

	local function myFunction()
		addImages(screenGroup)
	end
	timer.performWithDelay(3000,myFunction)
	
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


function addImages(n) --sample listener
	local screenGroup = n
	--screenGroup:remove(explosion)

	local reward = display.newText("You answered "..correctCount.." out of "..attemptCount.." questions correctly!", centerX+70,centerY,300,0,"Comic Relief", 30)
	reward:setFillColor(0)
	screenGroup:insert(reward)

	continue = display.newImage("images/continue.png", centerX+200, centerY+140)
	continue:scale(0.3,0.3)

	continue:addEventListener("tap", goNext)
	screenGroup:insert(continue)
end

function boom()
	explosion:scale(1.15,1.15)
end

function playExplosion()
	audio.play(explosionSound)
	

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