---------------------------------------------------------------------------------
--
-- showeescore.lua
--This scene will flash "Good Job" then return to the previous scene
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
storyboard.removeAll()



local attemptCount=0
local correctCount=0


  
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY

local function goNext()
	storyboard.removeAll()
	if storyboard.getPrevious() == "fraction" or storyboard.getPrevious() == "fraction1" or storyboard.getPrevious() == "fraction2" then
		storyboard.gotoScene("ddmoonselection")
	else
		storyboard.gotoScene( "ddselection")
	end
end


-- Called when the scene's view does not exist:
function scene:createScene( event )
	--storyboard.purgeScene("divisiondash1")
	--storyboard.purgeScene("exponentialenergyhard")
	local screenGroup = self.view
	attemptCount=0
	correctCount = 0
	local round = -1
	for row in db:nrows("SELECT * FROM ddScore ORDER BY id DESC") do
		round = row.round
		break
	end
	for row in db:nrows("SELECT * FROM ddScore") do
	 	if row.round == round then
	 		attemptCount = attemptCount+1
	 		if row.correct == 1 then
	 			correctCount= correctCount+1
	 		end
	 	end
	end

	
	if storyboard.getPrevious() == "fraction" or storyboard.getPrevious() == "fraction1" or storyboard.getPrevious() == "fraction2" then
		bg = display.newImage("images/mmmoonbg.png", centerX,centerY+30*yscale)
		bg:scale(0.8*xscale,0.7*yscale)
		screenGroup:insert(bg)
	else
		bg = display.newImage("images/ddbg.png", centerX,centerY+30*yscale)
		bg:scale(0.8*xscale,0.7*yscale)
		screenGroup:insert(bg)
	end

	if correctCount>6 and storyboard.getPrevious() == "divisiondash1"then

		local mapcheck = false
		for row in db:nrows("SELECT * FROM mapUnlocks;") do
			if row.location == "eeplanet" then
				mapcheck = true
				break
			end
		end
		if mapcheck == false then
			unlockText = display.newText("New area and planet unlocked!",centerX,centerY+100*yscale,"Comic Relief",24)
			unlockText:setFillColor(0)
			screenGroup:insert(unlockText)
		end
		unlockMap("eeplanet")
		unlockMap("dd2")


	end

	if correctCount>6 and storyboard.getPrevious() == "divisiondash2"then

		local mapcheck = false
		for row in db:nrows("SELECT * FROM mapUnlocks;") do
			if row.location == "fraction" then
				mapcheck = true
				break
			end
		end
		if mapcheck == false then
			unlockText = display.newText("Moon unlocked!",centerX,centerY+100*yscale,"Comic Relief",24)
			unlockText:setFillColor(0)
			screenGroup:insert(unlockText)
		end
		unlockMap("ddmoon")
		
	end

	if correctCount>6 and storyboard.getPrevious() == "fraction"then

		local mapcheck = false
		for row in db:nrows("SELECT * FROM mapUnlocks;") do
			if row.location == "fraction1" then
				mapcheck = true
				break
			end
		end
		if mapcheck == false then
			unlockText = display.newText("New area unlocked!",centerX,centerY+100*yscale,"Comic Relief",24)
			unlockText:setFillColor(0)
			screenGroup:insert(unlockText)
		end
		unlockMap("fraction1")
		
	end

	if correctCount>6 and storyboard.getPrevious() == "fraction1"then

		local mapcheck = false
		for row in db:nrows("SELECT * FROM mapUnlocks;") do
			if row.location == "fraction2" then
				mapcheck = true
				break
			end
		end
		if mapcheck == false then
			unlockText = display.newText("New area unlocked!",centerX,centerY+100*yscale,"Comic Relief",24)
			unlockText:setFillColor(0)
			screenGroup:insert(unlockText)
		end
		unlockMap("fraction2")
		
	end
	
	
	local reward = display.newText("You answered "..correctCount.." out of "..attemptCount.." questions correctly!", centerX,centerY,300*xscale,200*yscale,"Comic Relief", 30)
	reward:setFillColor(0)
	screenGroup:insert(reward)

	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+140*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

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