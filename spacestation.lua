---------------------------------------------------------------------------------
--
-- menu.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
require "dbFile"
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY


local coinnum = 0

function goHome()
	storyboard.removeScene("spacestation")
	storyboard.gotoScene("play")
end




-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view

	for row in db:nrows("SELECT * FROM coins;") do
		if row.amount~=nil then
			coinnum = coinnum + row.amount
		end
	end

	bg = display.newImage("images/spacebg.png", centerX,centerY+(30*yscale))
	bg:scale(0.8*xscale,0.8*yscale)
	screenGroup:insert(bg)


	title = display.newImage("images/customize.png", centerX,centerY-120*yscale)
	title:scale(0.6*xscale,0.6*yscale)
	screenGroup:insert(title)

	home = display.newImage("images/home.png",display.contentWidth-20*xscale,22*yscale)
	home:scale(0.3*xscale,0.3*yscale)
	home:addEventListener("tap", goHome)
	screenGroup:insert(home)

	coins = display.newImage("images/coins.png",10*xscale,22*yscale)
	coins:scale(0.3*xscale,0.15*yscale)
	screenGroup:insert(coins)

	coinamount = display.newText("x"..coinnum,60*xscale,22*yscale,"Comic Relief",20)
	coinamount:setFillColor(.776,.666,.349)
	screenGroup:insert(coinamount)



	
	--audio.play(bgmusic,{loops = -1,channel=1})

	--background = display.newImage("images/cat.jpg",centerX,centerY)
	--Runtime:addEventListener("touch",moveCatListener)
	--screenGroup:insert( background )

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	storyboard.purgeAll()

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