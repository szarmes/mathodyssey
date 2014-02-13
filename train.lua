---------------------------------------------------------------------------------
--
-- menu.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
require "dbFile"


local buttonXOffset = 100



---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY


function goHome()
	storyboard.removeScene("train")
	storyboard.gotoScene("menu")
end

function goCreateAdd()
	storyboard.removeScene("train")
	storyboard.gotoScene("createaddition")
end
function goCreateSub()
	storyboard.removeScene("train")
	storyboard.gotoScene("createsubtraction")
end
function goCreateMult()
	storyboard.removeScene("train")
	storyboard.gotoScene("createmultiplication")
end
function goCreateDiv()
	storyboard.removeScene("train")
	storyboard.gotoScene("createdivision")
end
function gopracticeAdd()
	storyboard.removeScene("train")
	storyboard.gotoScene("practiceaddition")
end
function gopracticeSub()
	storyboard.removeScene("train")
	storyboard.gotoScene("practicesubtraction")
end
function gopracticeMult()
	storyboard.removeScene("train")
	storyboard.gotoScene("practicemultiplication")
end
function gopracticeDiv()
	storyboard.removeScene("train")
	storyboard.gotoScene("practicedivision")
end




-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view

	bg = display.newImage("images/bg.png", centerX,centerY+(30*yscale))
	bg:scale(0.8*xscale,0.8*yscale)
	screenGroup:insert(bg)


	home = display.newImage("images/home.png",display.contentWidth-20*xscale,22*yscale)
	home:scale(0.3*xscale,0.3*yscale)
	home:addEventListener("tap", goHome)
	screenGroup:insert(home)


	create = display.newImage("images/create.png", centerX-100*xscale ,centerY-100*yscale)
	create:scale(0.6*xscale,0.6*yscale)
	screenGroup:insert(create)

	practice = display.newImage("images/practice.png", centerX+100*xscale ,centerY-100*yscale)
	practice:scale(0.6*xscale,0.6*yscale)
	screenGroup:insert(practice)

	createadd = display.newImage("images/addition.png", centerX-100*xscale ,centerY-30*yscale)
	createadd:addEventListener("tap",goCreateAdd)
	screenGroup:insert(createadd)

	createsub = display.newImage("images/subtraction.png", centerX-96*xscale ,centerY+20*yscale)
	createsub:addEventListener("tap",goCreateSub)
	screenGroup:insert(createsub)

	createmult = display.newImage("images/multiplication.png", centerX-100*xscale ,centerY+70*yscale)
	createmult:addEventListener("tap",goCreateMult)
	screenGroup:insert(createmult)

	creatediv = display.newImage("images/division.png", centerX-98*xscale ,centerY+120*yscale)
	creatediv:scale(1,0.8)
	creatediv:addEventListener("tap",goCreateDiv)
	screenGroup:insert(creatediv)

	practiceadd = display.newImage("images/addition.png", centerX+100*xscale ,centerY-30*yscale)
	practiceadd:addEventListener("tap",gopracticeAdd)
	screenGroup:insert(practiceadd)

	practicesub = display.newImage("images/subtraction.png", centerX+104*xscale ,centerY+20*yscale)
	practicesub:addEventListener("tap",gopracticeSub)
	screenGroup:insert(practicesub)

	practicemult = display.newImage("images/multiplication.png", centerX+100*xscale ,centerY+70*yscale)
	practicemult:addEventListener("tap",gopracticeMult)
	screenGroup:insert(practicemult)

	practicediv = display.newImage("images/division.png", centerX+102*xscale ,centerY+120*yscale)
	practicediv:scale(1,0.8)
	practicediv:addEventListener("tap",gopracticeDiv)
	screenGroup:insert(practicediv)

	trainLockLocations(screenGroup)
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
	physics.addBody(meteor)

	meteor:applyForce(meteorxforce,meteoryforce, meteor.x,meteor.y)
	local function listener1()
		respawnMeteor(screenGroup)
	end
	timer1 = timer.performWithDelay(7000,listener1)
end

function cancelMeteorTimers()
	if timer1 ~= nil then
		timer.cancel(timer1)
		physics.removeBody(meteor)
	end
end

function respawnMeteor(n)
	local screenGroup = n 
	screenGroup:remove(meteor)
	spawnMeteor(screenGroup)
end

function trainLockLocations(n)
	local screenGroup = n
	local lock1check = false
	local lock2check = false
	local lock3check = false
	local lock4check = false
	for row in db:nrows("SELECT * FROM mapUnlocks;") do
		if row.location == "practiceadd" then
			lock1check = true
		end
		if row.location == "practicesub" then
			lock2check = true
		end
		if row.location == "practicemult" then
			lock3check = true
		end
		if row.location == "practicediv" then
			lock4check = true
		end
	end
	if lock1check==false then 
		lock1 = display.newImage("images/lock.png",practiceadd.x+30*xscale,practiceadd.y+15*yscale)
		lock1:scale(0.08*xscale,0.08*yscale)
		screenGroup:insert(lock1)
		practiceadd:removeEventListener("tap",gopracticeAdd)
	end

	if lock2check==false then 
		lock2 = display.newImage("images/lock.png",practicesub.x+30*xscale,practicesub.y+15*yscale)
		lock2:scale(0.08*xscale,0.08*yscale)
		screenGroup:insert(lock2)
		practicesub:removeEventListener("tap",gopracticeSub)
	end
	if lock3check==false then 
		lock3 = display.newImage("images/lock.png",practicemult.x+30*xscale,practicemult.y+15*yscale)
		lock3:scale(0.08*xscale,0.08*yscale)
		screenGroup:insert(lock3)
		practicemult:removeEventListener("tap",gopracticeMult)
	end
	if lock4check==false then 
		lock4 = display.newImage("images/lock.png",practicediv.x+30*xscale,practicediv.y+15*yscale)
		lock4:scale(0.08*xscale,0.08*yscale)
		screenGroup:insert(lock4)
		practicediv:removeEventListener("tap",gopracticeDiv)
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