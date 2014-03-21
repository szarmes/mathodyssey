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

	dog = display.newImage("images/dog.png", centerX-140*xscale, centerY-10*yscale)
	dog:scale(0.14*xscale, 0.14*yscale)
	screenGroup:insert(dog)


	dogcoins = display.newImage("images/coins.png",dog.x-20*xscale,centerY+30*yscale)
	dogcoins:scale(0.2*xscale,0.1*yscale)
	screenGroup:insert(dogcoins)

	dogcoinamount = display.newText("x"..150,dog.x+15*xscale,centerY+30*yscale,"Comic Relief",12)
	dogcoinamount:setFillColor(.776,.666,.349)
	screenGroup:insert(dogcoinamount)

	astronaut = display.newImage("images/astronaut.png", centerX-220*xscale, centerY-30*yscale)
	astronaut:scale(0.18*xscale, 0.18*yscale)
	screenGroup:insert(astronaut)

	astrosloth = display.newImage("images/astrosloth.png", centerX-60*xscale, centerY-30*yscale)
	astrosloth:scale(-0.18*xscale, 0.18*yscale)
	screenGroup:insert(astrosloth)


	slothcoins = display.newImage("images/coins.png",astrosloth.x-10*xscale,centerY+30*yscale)
	slothcoins:scale(0.2*xscale,0.1*yscale)
	screenGroup:insert(slothcoins)

	slothcoinamount = display.newText("x"..100,astrosloth.x+25*xscale,centerY+30*yscale,"Comic Relief",12)
	slothcoinamount:setFillColor(.776,.666,.349)
	screenGroup:insert(slothcoinamount)


	ship2 = display.newImage("images/ship2.png", centerX+40*xscale, centerY-30*yscale)
	ship2:scale(0.3*xscale, 0.3*yscale)
	screenGroup:insert(ship2)

	ship1 = display.newImage("images/ship1.png", centerX+110*xscale, centerY-30*yscale)
	ship1:scale(0.3*xscale, 0.3*yscale)
	screenGroup:insert(ship1)

	ship1coins = display.newImage("images/coins.png",ship1.x-20*xscale,centerY+30*yscale)
	ship1coins:scale(0.2*xscale,0.1*yscale)
	screenGroup:insert(ship1coins)

	ship1coinamount = display.newText("x"..75,ship1.x+15*xscale,centerY+30*yscale,"Comic Relief",12)
	ship1coinamount:setFillColor(.776,.666,.349)
	screenGroup:insert(ship1coinamount)

	ship3 = display.newImage("images/ship3.png", centerX+200*xscale, centerY-30*yscale)
	ship3:scale(0.3*xscale, 0.3*yscale)
	screenGroup:insert(ship3)

	ship3coins = display.newImage("images/coins.png",ship3.x-20*xscale,centerY+30*yscale)
	ship3coins:scale(0.2*xscale,0.1*yscale)
	screenGroup:insert(ship3coins)

	ship3coinamount = display.newText("x"..150,ship3.x+15*xscale,centerY+30*yscale,"Comic Relief",12)
	ship3coinamount:setFillColor(.776,.666,.349)
	screenGroup:insert(ship3coinamount)


	companion = display.newImage("images/companion.png",centerX-130*xscale,centerY+100*yscale)
	companion:scale(0.5*xscale,0.5*yscale)
	screenGroup:insert(companion)

	ship = display.newImage("images/ship.png",centerX+130*xscale,centerY+100*yscale)
	ship:scale(0.5*xscale,0.5*yscale)
	screenGroup:insert(ship)





	
	--audio.play(bgmusic,{loops = -1,channel=1})

	--background = display.newImage("images/cat.jpg",centerX,centerY)
	--Runtime:addEventListener("touch",moveCatListener)
	--screenGroup:insert( background )
	local compcheckx
	local compchecky

	for row in db:nrows("SELECT * FROM companionSelect;") do
		if row.companion == 1 then
			compcheckx = astronaut.x
			compchecky = centerY
		end

		if row.companion == 0 then
			
			compcheckx = dog.x
			compchecky = centerY
		end
	end

	companioncheck = display.newImage("images/check.png",compcheckx,compchecky)
	companioncheck:scale(0.4*xscale,0.4*yscale)
	screenGroup:insert(companioncheck)

	local shipcheckx
	local shipchecky

	for row in db:nrows("SELECT * FROM shipSelect;") do
		if row.ship == 2 then
			shipcheckx = ship2.x
			shipchecky = centerY
		end

		if row.ship == 1 then
			
			shipcheckx = ship1.x
			shipchecky = centerY
		end
	end

	shipcheck = display.newImage("images/check.png",shipcheckx,shipchecky)
	shipcheck:scale(0.4*xscale,0.4*yscale)
	screenGroup:insert(shipcheck)


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