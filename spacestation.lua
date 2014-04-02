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
local bubbleOn = false
local centerX = display.contentCenterX
local centerY = display.contentCenterY


local coinnum = 0

function goHome()
	storyboard.removeScene("spacestation")
	storyboard.gotoScene("play")
end

local function confirmPurchase(n,str,amount,num)
	bubbleOn=true
	local screenGroup = n

	--hintbutton:removeSelf()
	
	--hintOn=true
	confirmbubble =  display.newImage("images/bubble.png", centerX-20*xscale,centerY)
	confirmbubble:scale(0.8*xscale,0.5*yscale)
	screenGroup:insert(confirmbubble)

	confirmtext = display.newText("Are you sure?",centerX,centerY+40*yscale,400*xscale,200*yscale,"Comic Relief",18)
	confirmtext:setFillColor(0)
	screenGroup:insert(confirmtext)

	nobutton = display.newText("Don't Buy",centerX+160*xscale,centerY+50*yscale,"Comic Relief",18)
	nobutton:setFillColor(0)
	local function noconfirm()
		bubbleOn =false
		screenGroup:remove(confirmbubble)
		screenGroup:remove(confirmtext)
		screenGroup:remove(nobutton)
		screenGroup:remove(yesbutton)

	end
	nobutton:addEventListener("tap",noconfirm)
	screenGroup:insert(nobutton)
	local function yesconfirm()
		bubbleOn=false

		addCoins(-amount)
		storeCompanion(num)
		unlockItem(str)
		if str=="sloth" then
			companioncheck.x = astrosloth.x
			storeCompanion(2)
			unlockItem("sloth")
			slothcheck=true
		end
		if str == "dog" then
			companioncheck.x = dog.x
			storeCompanion(0)
			unlockItem("dog")
			dogcheck = true
		end
		if str == "ship1" then
			shipcheck.x = ship1.x
			storeShip(1)
			unlockItem("ship1")
			ship1check = true
		end
		if str == "ship3" then
			shipcheck.x = ship3.x
			storeShip(3)
			unlockItem("ship3")
			ship2check = true
		end

		for row in db:nrows("SELECT * FROM coins;") do
			if row.amount~=nil then
				coinnum =  row.amount
			end
		end
		coinamount.text = "x"..coinnum

		screenGroup:remove(confirmbubble)
		screenGroup:remove(confirmtext)
		screenGroup:remove(nobutton)
		screenGroup:remove(yesbutton)


	end
	yesbutton = display.newText("Buy",centerX-180*xscale,centerY+50*yscale,"Comic Relief",18)
	yesbutton:setFillColor(0)
	yesbutton:addEventListener("tap",yesconfirm)
	screenGroup:insert(yesbutton)
end

local function notEnough(n,str)
	local screenGroup = n
	bubbleOn=true
	--hintbutton:removeSelf()
	
	--hintOn=true
	confirmbubble =  display.newImage("images/bubble.png", centerX-20*xscale,centerY)
	confirmbubble:scale(0.8*xscale,0.5*yscale)
	screenGroup:insert(confirmbubble)

	confirmtext = display.newText("Not enough coins!",centerX,centerY+40*yscale,400*xscale,200*yscale,"Comic Relief",18)
	confirmtext:setFillColor(0)
	screenGroup:insert(confirmtext)

	nobutton = display.newText("Close",centerX+180*xscale,centerY+50*yscale,"Comic Relief",18)
	nobutton:setFillColor(0)
	local function noconfirm()
		bubbleOn=false
		screenGroup:remove(confirmbubble)
		screenGroup:remove(confirmtext)
		screenGroup:remove(nobutton)
	end
	nobutton:addEventListener("tap",noconfirm)
	screenGroup:insert(nobutton)
end



-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view

	for row in db:nrows("SELECT * FROM coins;") do
		if row.amount~=nil then
			coinnum = coinnum + row.amount
		end
	end
	slothcheck = false
 	dogcheck= false
	 ship1check = false
	 ship2check = false
	for row in db:nrows("SELECT * FROM itemUnlocks;") do
		if row.name=="sloth" then
			slothcheck = true
		end
		if row.name=="dog" then
			dogcheck = true
		end
		if row.name=="ship1" then
			ship1check = true
		end
		if row.name=="ship3" then
			ship2check = true
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

	dog = display.newImage("images/dog.png", centerX-60*xscale, centerY-10*yscale)
	dog:scale(0.14*xscale, 0.14*yscale)
	local function buyDog()
		if bubbleOn==false then
			if dogcheck==false then
				if coinnum>=150 then
					confirmPurchase(screenGroup,"dog",150,0)
				else
					notEnough(screenGroup)
				end
			else
				storeCompanion(0)
				companioncheck.x = dog.x
			end
		end
	end
	dog:addEventListener("tap",buyDog)
	screenGroup:insert(dog)


	dogcoins = display.newImage("images/coins.png",dog.x-20*xscale,centerY+30*yscale)
	dogcoins:scale(0.2*xscale,0.1*yscale)
	screenGroup:insert(dogcoins)

	dogcoinamount = display.newText("x"..150,dog.x+15*xscale,centerY+30*yscale,"Comic Relief",12)
	dogcoinamount:setFillColor(.776,.666,.349)
	screenGroup:insert(dogcoinamount)

	astronaut = display.newImage("images/astronaut.png", centerX-220*xscale, centerY-30*yscale)
	astronaut:scale(0.18*xscale, 0.18*yscale)
	local function buyAstro(  )
		if bubbleOn==false then
			storeCompanion(1)
			companioncheck.x = astronaut.x
		end
	end
	astronaut:addEventListener("tap",buyAstro)
	screenGroup:insert(astronaut)

	astrosloth = display.newImage("images/astrosloth.png", centerX-140*xscale, centerY-30*yscale)
	astrosloth:scale(-0.18*xscale, 0.18*yscale)
	local function buySloth()
		if bubbleOn==false then
			if slothcheck==false then
				if coinnum>=100 then
					confirmPurchase(screenGroup,"sloth",100,0)
				else
					notEnough(screenGroup)
				end
			else
				storeCompanion(2)
				companioncheck.x = astrosloth.x
			end
		end
	end
	astrosloth:addEventListener("tap",buySloth)
	screenGroup:insert(astrosloth)


	slothcoins = display.newImage("images/coins.png",astrosloth.x-10*xscale,centerY+30*yscale)
	slothcoins:scale(0.2*xscale,0.1*yscale)
	screenGroup:insert(slothcoins)

	slothcoinamount = display.newText("x"..100,astrosloth.x+25*xscale,centerY+30*yscale,"Comic Relief",12)
	slothcoinamount:setFillColor(.776,.666,.349)
	screenGroup:insert(slothcoinamount)


	ship2 = display.newImage("images/ship2.png", centerX+40*xscale, centerY-30*yscale)
	ship2:scale(0.3*xscale, 0.3*yscale)
	local function buyShip2(  )
		if bubbleOn==false then
			storeShip(2)
			shipcheck.x = ship2.x
		end
	end
	ship2:addEventListener("tap",buyShip2)
	screenGroup:insert(ship2)

	ship1 = display.newImage("images/ship1.png", centerX+110*xscale, centerY-30*yscale)
	ship1:scale(0.3*xscale, 0.3*yscale)
	local function buyShip1()
		if bubbleOn==false then
			if ship1check==false then
				if coinnum>=75 then
					confirmPurchase(screenGroup,"ship1",75,1)
				else
					notEnough(screenGroup)
				end
			else
				storeShip(1)
				shipcheck.x = ship1.x
			end
		end
	end
	ship1:addEventListener("tap",buyShip1)
	screenGroup:insert(ship1)

	ship1coins = display.newImage("images/coins.png",ship1.x-20*xscale,centerY+30*yscale)
	ship1coins:scale(0.2*xscale,0.1*yscale)
	screenGroup:insert(ship1coins)

	ship1coinamount = display.newText("x"..75,ship1.x+15*xscale,centerY+30*yscale,"Comic Relief",12)
	ship1coinamount:setFillColor(.776,.666,.349)
	screenGroup:insert(ship1coinamount)

	ship3 = display.newImage("images/ship3.png", centerX+200*xscale, centerY-30*yscale)
	ship3:scale(0.3*xscale, 0.3*yscale)
	local function buyShip3()
		if bubbleOn==false then
			if ship2check==false then
				if coinnum>=150 then
					confirmPurchase(screenGroup,"ship3",150,1)
				else
					notEnough(screenGroup)
				end
			else
				storeShip(3)
				shipcheck.x = ship3.x
			end
		end
	end
	ship3:addEventListener("tap",buyShip3)
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

		if row.companion == 2 then
			compcheckx = astrosloth.x
			compchecky = centerY
		end

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

		if row.ship == 3 then
			shipcheckx = ship3.x
			shipchecky = centerY
		end
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