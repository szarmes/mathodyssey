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
local mm1

local function goTomm() --play timetrials
	storyboard.purgeAll()
	storyboard.gotoScene("mmpatterns")
end

local function goTomm1() --play timetrials
	storyboard.purgeAll()
	storyboard.gotoScene("mmrepeat")
end

local function goTomm2() --play exponential energy
	storyboard.purgeAll()
	storyboard.gotoScene( "mmsolve" )
end

local function goHome() --go back to the menu
	storyboard.gotoScene(storyboard.getPrevious())
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view

	bg = display.newImage("images/lavabg.png", centerX,centerY+30*yscale)
	bg:scale(0.8*xscale,0.8*yscale)
	screenGroup:insert(bg)

	mm = display.newImage("images/incomplete.png", -10*xscale,centerY+120*yscale)
	mm:scale(0.5*xscale,0.5*yscale)
	mm:addEventListener("tap", goTomm)
	mm.anchorX = 0
	screenGroup:insert(mm)

	mm1 = display.newImage("images/incomplete.png", 140*xscale,centerY+10*yscale)
	mm1:scale(0.5*xscale,0.5*yscale)
	mm1:addEventListener("tap", goTomm1)
	mm1.anchorX = 0
	screenGroup:insert(mm1)

	mm2 = display.newImage("images/incomplete.png", centerX+100*xscale,centerY-60*yscale)
	mm2:scale(0.5*xscale,0.5*yscale)
	mm2:addEventListener("tap", goTomm2)
	mm2.anchorX = 0
	screenGroup:insert(mm2)


	home = display.newImage("images/home.png",display.contentWidth-20*xscale,22*yscale)
	home:scale(0.3*xscale,0.3*yscale)
	home:addEventListener("tap", goHome)
	screenGroup:insert(home)

	mmLockLocations(screenGroup)
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

function mmLockLocations(n)
	local screenGroup = n
	local lock1check = false
	local lock2check = false
	for row in db:nrows("SELECT * FROM mapUnlocks;") do
		if row.location == "mm1" then
			lock1check = true
		end
		if row.location == "mm2" then
			lock2check = true
		end
	end
	if lock1check==false then 
		lock1 = display.newImage("images/lock.png",mm1.x+30*xscale,mm1.y+15*yscale)
		lock1:scale(0.08*xscale,0.08*yscale)
		screenGroup:insert(lock1)
		mm1:removeEventListener("tap",goTomm1)
	end

	if lock2check==false then 
		lock2 = display.newImage("images/lock.png",mm2.x+30*xscale,mm2.y+15*yscale)
		lock2:scale(0.08*xscale,0.08*yscale)
		screenGroup:insert(lock2)
		mm2:removeEventListener("tap",goTomm2)
	end
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