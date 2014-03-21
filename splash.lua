---------------------------------------------------------------------------------
--
-- splash.lua
--This scene is the splash screen and will transition to the menu scene after 3 seconds
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
storyboard.removeAll()

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local bg
local bgs
local timer1



local function continue()
	timer.cancel(timer1)
	storyboard.gotoScene("menu","fade",2000)
end



-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	--bg = display.newImage("images/spacebg.png", centerX,centerY+(30*yscale))
	--bg:scale(0.8*xscale,0.8*yscale)
	--screenGroup:insert(bg)

	--local image = display.newImage( "images/splash.png", centerX, centerY )
	--image:scale(0.9*xscale,0.9*yscale)
	--screenGroup:insert( image )
	
	--image.touch = onSceneTouch

	bgs = {}

	local function loadPic()
		for count = 1,119,1 do --screenGroup:remove(bg)
			local countText
			if count<10 then
				countText = "00"..count
			elseif count<100 then
				countText = "0"..count
			else
				countText=count
			end
			bgs[count] = display.newImage("render/Dunc'sIntro_00"..countText..".png", centerX,centerY)
			bgs[count]:scale(0.5*xscale,0.5*yscale)
			bgs[count].isVisible = false
		end
	end
	local swapcount = 1

	local function swapPic()

		if swapcount==1 then
			audio.play(launchSound,{loops = 0,channel=3})
		end
		bgs[swapcount].isVisible = false
		bgs[swapcount+1].isVisible=true
		swapcount = swapcount+1
		
		if swapcount==118 then
			bgs[swapcount].isVisible = false
			timer.cancel(timer1)
			storyboard.gotoScene("menu","crossFade",3000)
		end
	end



	loadPic()
	timer1=timer.performWithDelay(15,swapPic,118)
	--continue()
	--swapPic(screenGroup)


end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	--endSceneTimer = timer.performWithDelay( 10000, continue, 1 )	--after 4 seconds, go to menu
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