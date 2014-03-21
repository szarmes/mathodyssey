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
local title
local titlescale = 1.008
local cloud1
local cloud2

local titlecount = 1
local function scaleTitle()
	titlecount=titlecount+1
	title:scale(titlescale,titlescale)
	titlescale= titlescale+.0002
	if titlecount>100 then
		titlescale= titlescale+.001
	end
end

local function scaleBg()
	bg:scale(1.0008,1.0008)
end

local cloud1count = 1
local function scaleCloud1()
	cloud1:scale(1.001,1.001)
	cloud1.x = cloud1.x-1*xscale
	if cloud1count%2==0 then
		cloud1.y = cloud1.y-1
	end
	cloud1count=cloud1count+1
end

local cloud2count = 1
local function scaleCloud2()
	cloud2:scale(1.001,1.001)
	if cloud2count%2==0 then
		cloud2.y = cloud2.y-1
	end
	cloud2count=cloud2count+1
end

local cloud3count = 1
local function scaleCloud3()
	cloud3:scale(1.001,1.001)
	cloud3.x = cloud3.x-1
	if cloud3count%2==0 then
		cloud3.y = cloud3.y+1
	end
	cloud3count=cloud3count+1
end

local cloud4count = 1
local function scaleCloud4()
	cloud4:scale(1.001,1.001)
	cloud4.x = cloud4.x+1
	if cloud4count%2==0 then
		cloud4.y = cloud4.y-1
	end
	cloud4count=cloud4count+1
end

local cometcount = 1
local function scaleComet()
	comet.x = comet.x+5
	
	comet.y = comet.y-3

	cometcount=cometcount+1
end




local function continue()
	storyboard.gotoScene("menu","crossFade",1000)
end





-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view

	if string.sub(system.getInfo("model"),1,5) == "Droid" or string.sub(system.getInfo("model"),1,9) == "Nexus One" then
		bg = display.newImage("splash/bg.png", centerX+100,centerY)
		bg:scale(0.8*xscale,0.8*yscale)
		screenGroup:insert(bg)
	else
		bg = display.newImage("splash/bg.png", centerX-100*xscale,centerY-100*yscale)
		bg:scale(0.8*xscale,0.8*yscale)
		screenGroup:insert(bg)
	end
	cloud4 = display.newImage("splash/cloud4.png", centerX+200*xscale,centerY-50*yscale)
	cloud4:scale(0.4*xscale,0.4*yscale)
	screenGroup:insert(cloud4)
	
	comet = display.newImage("splash/comet.png", centerX-450*xscale,centerY+180*yscale)
	comet:scale(0.02*xscale,0.013*yscale)
	comet.alpha = 0.7
	comet:rotate(-30)
	screenGroup:insert(comet)


	cloud3 = display.newImage("splash/cloud3.png", centerX-40*xscale,centerY+100*yscale)
	cloud3:scale(0.5*xscale,0.5*yscale)
	screenGroup:insert(cloud3)

	cloud2 = display.newImage("splash/cloud2.png", centerX+10*xscale,centerY-170*yscale)
	cloud2:scale(0.7*xscale,0.7*yscale)
	screenGroup:insert(cloud2)

	cloud1 = display.newImage("splash/cloud1.png", centerX-200*xscale,centerY-100*yscale)
	cloud1:scale(0.5*xscale,0.5*yscale)
	screenGroup:insert(cloud1)



	title = display.newImage("splash/title.png", centerX,centerY)
	title:scale(0.2*xscale,0.2*yscale)
	screenGroup:insert(title)



	audio.play(launchSound,{loops = 0,channel=3})
	timer.performWithDelay(10,scaleTitle,200)
	timer.performWithDelay(10,scaleBg,145)
	timer.performWithDelay(10,scaleCloud1,200)
	timer.performWithDelay(10,scaleCloud2,200)
	timer.performWithDelay(10,scaleCloud3,200)
	timer.performWithDelay(10,scaleCloud4,200)
	timer.performWithDelay(10,scaleComet,200)
	timer.performWithDelay(5000,continue)




	

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