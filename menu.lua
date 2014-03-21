---------------------------------------------------------------------------------
--
-- menu.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
require "dbFile"


local buttonXOffset = 100
buttonSource = "images/button.png"
buttonPressedSource = "images/buttonpressed.png"



---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY
companionText = "images/astronaut.png"


function goToPlay(event)
	if ( "ended" == event.phase ) then
		--cancelMeteorTimers()
		storyboard.gotoScene("play")
	end
end
function goToTrain(event)
	if ( "ended" == event.phase ) then
		storyboard.gotoScene("train")
	end
end


function goToStory(event)
	if ( "ended" == event.phase ) then
		storyboard.gotoScene("story")
	end
end

function goToCredits(event)
	if ( "ended" == event.phase ) then
		storyboard.gotoScene("credit")
	end
end

function goToSettings(event)
	if ( "ended" == event.phase ) then
		storyboard.gotoScene("settings")
	end
end


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view

	bg = display.newImage("images/spacebg.png", centerX,centerY+(30*yscale))
	bg:scale(0.8*xscale,0.8*yscale)
	screenGroup:insert(bg)

	local play = widget.newButton
		{
		    defaultFile = "images/play.png",
		    overFile = "images/playpressed.png",
		    onEvent = goToPlay
		}
	play.x = centerX-145*xscale
	play.y = centerY
	play:scale(0.7*xscale,0.6*yscale)
	screenGroup:insert(play)

	local story = widget.newButton
		{
		    defaultFile = "images/story.png",
		    overFile = "images/storypressed.png",
		    onEvent = goToStory
		}
	story.x = centerX-145*xscale
	story.y = centerY+70*yscale
	story:scale(0.6*xscale,0.6*yscale)
	screenGroup:insert(story)

	local train = widget.newButton
		{
		    defaultFile = "images/train.png",
		    overFile = "images/trainpressed.png",
		    onEvent = goToTrain
		}
	train.x = centerX+120*xscale
	train.y = centerY
	train:scale(0.7*xscale,0.7*yscale)
	screenGroup:insert(train)

	local credits = widget.newButton
		{
		    defaultFile = "images/credits.png",
		    overFile = "images/creditspressed.png",
		    onEvent = goToCredits
		}
	credits.x = centerX+120*xscale
	credits.y = centerY+70*yscale
	credits:scale(0.6*xscale,0.6*yscale)
	screenGroup:insert(credits)

	title = display.newImage("images/splash.png", centerX,centerY-100*yscale)
	title:scale(0.8*xscale,0.8*yscale)
	screenGroup:insert(title)

	local settings = widget.newButton
		{
		    defaultFile = "images/settings.png",
		    overFile = "images/settingspressed.png",
		    onEvent = goToSettings
		}
	settings.x = 20*xscale
	settings.y = centerY+130*yscale
	settings:scale(0.7*xscale,0.7*yscale)
	screenGroup:insert(settings)

	--spawnMeteor(screenGroup)
	--audio.play(bgmusic,{loops = -1,channel=1})

	--background = display.newImage("images/cat.jpg",centerX,centerY)
	--Runtime:addEventListener("touch",moveCatListener)
	--screenGroup:insert( background )

	first = true

	local goldButton = false
	for row in db:nrows("SELECT * FROM mapUnlocks;") do
		if row.location == "finishGame" then
			goldButton = true
		end
	end
	if goldButton == true then
		buttonSource = "images/goldbutton.png"
		buttonPressedSource = "images/goldbuttonpressed.png"
	end


	consent = true
	for row in db:nrows("SELECT * FROM firstTime;") do
		if row.first == 0 then
			consent = false
		end
	end

	local firstCheck = false
	for row in db:nrows("SELECT * FROM companionSelect;") do
		if row.companion == 1 then
			firstCheck = true
			companionText = "images/astronaut.png"
		end

		if row.companion == 0 then
			firstCheck = true
			companionText = "images/dog.png"
		end
	end
	if firstCheck == false then
		storyboard.gotoScene("firstTime")
	end


end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local screenGroup = self.view	
	print ("enterScene")
	
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	
end

function spawnMeteor(n)
	local screenGroup = n
	version = math.random(1,4)
	if version==1 then
		meteorx = centerX+200*xscale
		meteory = centerY-200*yscale
		meteorxforce = -50
		meteoryforce = 25
		meteorrotation = 0
	elseif version==2 then
		meteorx = centerX-200*xscale
		meteory = centerY-200*yscale
		meteorxforce = 30
		meteoryforce = 40
		meteorrotation = -90
	elseif version==3 then
		meteorx = centerX-200*xscale
		meteory = centerY+200*yscale
		meteorxforce = 23
		meteoryforce = -40
		meteorrotation = 155
	else
		meteorx = centerX+400*xscale
		meteory = centerY+100*yscale
		meteorxforce = -35
		meteoryforce = -10
		meteorrotation = 45
	end

	src = math.random(1,3)
	if src == 1 then
		meteorsrc = "images/meteor.png"
	elseif src == 2 then
		meteorsrc = "images/meteor1.png"
	else
		meteorsrc = "images/meteor2.png"
	end

	meteor = display.newImage(meteorsrc,meteorx,meteory)
	meteor:scale(0.6*xscale,0.6*yscale)
	meteor:rotate(meteorrotation)
	screenGroup:insert(meteor)
	physics.addBody(meteor,"kinematic")

	meteor:setLinearVelocity(meteorxforce*4,meteoryforce*4)
	local function listener1()
		--cancelMeteorTimers()
		respawnMeteor(screenGroup)
	end
	timer1 = timer.performWithDelay(7000,listener1)
end

function cancelMeteorTimers()
	if timer1 ~= nil then
		timer.cancel(timer1)
		timer1 = nil
		meteor:removeSelf()
	end
end

function respawnMeteor(n)
	local screenGroup = n 
	spawnMeteor(screenGroup)
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