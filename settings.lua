---------------------------------------------------------------------------------
--
-- settings.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local widget = require( "widget" )

local buttonXOffset = 100


---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY


local function goHome()
	storyboard.gotoScene( "menu" )
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view

	bg = display.newImage("images/bg.png", centerX,centerY+30)
	bg:scale(0.7,0.7)
	screenGroup:insert(bg)

	title = display.newImage("images/splash.png", centerX,centerY-100)
	title:scale(0.8,0.8)
	screenGroup:insert(title)
	
	home = display.newImage("images/home.png",0,display.contentHeight-40)
	home:scale(0.3,0.3)
	home:addEventListener("tap", goHome)
	screenGroup:insert(home)

	-- Handle press events for the checkbox

	-- Create the widget
	local sfxmuteSwitch = widget.newSwitch
	{
	    left = 200,
	    top = 140,
	    style = "onOff",
	    id = "sfxmuteSwitch",
	   	onPress = onsfxPress
	}
	screenGroup:insert(sfxmuteSwitch)

	local musicmuteSwitch = widget.newSwitch
	{
	    left = 200,
	    top = 190,
	    style = "onOff",
	    id = "musicmuteSwitch",
	    onPress = onmusicPress
	}
	screenGroup:insert(musicmuteSwitch)

	sfxon = display.newImage("images/SFX-On.png", centerX-100,centerY)
	sfxon:scale(0.3,0.3)
	screenGroup:insert(sfxon)
	sfxoff = display.newImage("images/SFX-Off.png", centerX+100,centerY)
	sfxoff:scale(0.3,0.3)
	screenGroup:insert(sfxoff)

	musicon = display.newImage("images/Music-On.png", centerX-100,centerY+50)
	musicon:scale(0.3,0.3)
	screenGroup:insert(musicon)
	musicoff = display.newImage("images/Music-Off.png", centerX+100,centerY+50)
	musicoff:scale(0.3,0.3)
	screenGroup:insert(musicoff)

	--background = display.newImage("images/cat.jpg",centerX,centerY)
	--Runtime:addEventListener("touch",moveCatListener)
	--screenGroup:insert( background )

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

function onsfxPress( event )
    mutesfx()
end

function onmusicPress( event )
    mutemusic()
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