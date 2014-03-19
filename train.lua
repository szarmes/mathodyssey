---------------------------------------------------------------------------------
--
-- menu.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
require "dbFile"
local parse = require "mod_parse"


local buttonXOffset = 100



---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY


function goHome(event)
	if ( "ended" == event.phase ) then
		storyboard.removeScene("train")
		storyboard.gotoScene("menu")
	end
end

function goCreateAdd(event)
	if ( "ended" == event.phase ) then
		storyboard.removeScene("train")
		storyboard.gotoScene("createaddition")
	end
end
function goCreateSub(event)
	if ( "ended" == event.phase ) then
		storyboard.removeScene("train")
		storyboard.gotoScene("createsubtraction")
	end
end
function goCreateMult(event)
	if ( "ended" == event.phase ) then
		storyboard.removeScene("train")
		storyboard.gotoScene("createmultiplication")
	end
end
function goCreateDiv(event)
	if ( "ended" == event.phase ) then
		storyboard.removeScene("train")
		storyboard.gotoScene("createdivision")
	end
end
function gopracticeAdd(event)
	if ( "ended" == event.phase ) then
		storyboard.removeScene("train")
		storyboard.gotoScene("practiceaddition")
	end
end
function gopracticeSub(event)
	if ( "ended" == event.phase ) then
		storyboard.removeScene("train")
		storyboard.gotoScene("practicesubtraction")
	end
end
function gopracticeMult(event)
	if ( "ended" == event.phase ) then
		storyboard.removeScene("train")
		storyboard.gotoScene("practicemultiplication")
	end
end
function gopracticeDiv(event)
	if ( "ended" == event.phase ) then
		storyboard.removeScene("train")
		storyboard.gotoScene("practicedivision")
	end
end




-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view

	bg = display.newImage("images/spacebg.png", centerX,centerY+(30*yscale))
	bg:scale(0.8*xscale,0.8*yscale)
	screenGroup:insert(bg)


	local home = widget.newButton
		{
		    defaultFile = "images/home.png",
		    overFile = "images/homepressed.png",
		    onEvent = goHome
		}
	home:scale(0.3*xscale,0.3*yscale)
	home.x = display.contentWidth-20*xscale
	home.y = 22*yscale
	screenGroup:insert(home)


	create = display.newImage("images/create.png", centerX-100*xscale ,centerY-100*yscale)
	create:scale(0.6*xscale,0.6*yscale)
	screenGroup:insert(create)

	practice = display.newImage("images/practice.png", centerX+100*xscale ,centerY-100*yscale)
	practice:scale(0.6*xscale,0.6*yscale)
	screenGroup:insert(practice)

	local createadd = widget.newButton
		{
		    defaultFile = "images/addition.png",
		    overFile = "images/additionpressed.png",
		    onEvent = goCreateAdd
		}
	createadd.x = centerX-100*xscale
	createadd.y = centerY-30*yscale
	screenGroup:insert(createadd)

	local createsub = widget.newButton
		{
		    defaultFile = "images/subtraction.png",
		    overFile = "images/subtractionpressed.png",
		    onEvent = goCreateSub
		}
	createsub.x = centerX-96*xscale
	createsub.y = centerY+20*yscale
	screenGroup:insert(createsub)

	local createmult = widget.newButton
		{
		    defaultFile = "images/multiplication.png",
		    overFile = "images/multiplicationpressed.png",
		    onEvent = goCreateMult
		}
	createmult.x = centerX-100*xscale
	createmult.y = centerY+70*yscale
	screenGroup:insert(createmult)

	local creatediv = widget.newButton
		{
		    defaultFile = "images/division.png",
		    overFile = "images/divisionpressed.png",
		    onEvent = goCreateDiv
		}
	creatediv.x = centerX-98*xscale
	creatediv.y = centerY+120*yscale
	screenGroup:insert(creatediv)

	local practiceadd = widget.newButton
		{
		    defaultFile = "images/addition.png",
		    overFile = "images/additionpressed.png",
		    onEvent = gopracticeAdd
		}
	practiceadd.x = centerX+100*xscale
	practiceadd.y = centerY-30*xscale
	screenGroup:insert(practiceadd)

	local practicesub = widget.newButton
		{
		    defaultFile = "images/subtraction.png",
		    overFile = "images/subtractionpressed.png",
		    onEvent = gopracticeSub
		}
	practicesub.x = centerX+104*xscale
	practicesub.y = centerY+20*yscale
	screenGroup:insert(practicesub)

	local practicemult = widget.newButton
		{
		    defaultFile = "images/multiplication.png",
		    overFile = "images/multiplicationpressed.png",
		    onEvent = gopracticeMult
		}
	practicemult.x = centerX+100*xscale
	practicemult.y = centerY+70*yscale
	screenGroup:insert(practicemult)

	local practicediv = widget.newButton
		{
		    defaultFile = "images/division.png",
		    overFile = "images/divisionpressed.png",
		    onEvent = gopracticeDiv
		}
	practicediv.x = centerX+102*xscale
	practicediv.y = centerY+120*yscale
	screenGroup:insert(practicediv)

	--trainLockLocations(screenGroup)
	--audio.play(bgmusic,{loops = -1,channel=1})

	--background = display.newImage("images/cat.jpg",centerX,centerY)
	--Runtime:addEventListener("touch",moveCatListener)
	--screenGroup:insert( background )

	pullData()

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


function pullData()

	local lastPulled = "2014-03-05T19:31:09.981Z"
	local now = formatDate(os.date("*t"))

	for row in db:nrows("SELECT * FROM lastPulled;") do
		if row.date~=nil then
			lastPulled = row.date
		end
	end

	local function onGetAdd( event )
	  if not event.error then
	  	for i = 1,#event.results,1  do
		   storeQuestion(1,-1,event.results[i].leftnum,event.results[i].rightnum,event.results[i].answernum,"+")
		end
	  end
	end

	local function onGetSub( event )
	  if not event.error then
	  	for i = 1,#event.results,1  do
		  storeQuestion(1,-1,event.results[i].leftnum,event.results[i].rightnum,event.results[i].answernum,"-")
		end
	  end
	end

	local function onGetMult( event )
	  if not event.error then
	  	for i = 1,#event.results,1  do
		   storeQuestion(1,-1,event.results[i].leftnum,event.results[i].rightnum,event.results[i].answernum,"*")
		end
	  end
	end

	local function onGetDiv( event )
	  if not event.error then
	  	for i = 1,#event.results,1  do
		    storeQuestion(1,-1,event.results[i].leftnum,event.results[i].rightnum,event.results[i].answernum,"/")
		end
	  end
	end

	local queryTable = { 
	  ["where"] = { ["operator"] = "+", ["createdAt"] = {["$gt"]= {["__type"]= "Date",["iso"]=lastPulled}}}
	  
	}

	local queryTable1 = { 
	  ["where"] = { ["operator"] = "-", ["createdAt"] = {["$gt"]= {["__type"]= "Date",["iso"]=lastPulled}}}
	  
	}

	local queryTable2 = { 
	  ["where"] = { ["operator"] = "*", ["createdAt"] = {["$gt"]= {["__type"]= "Date",["iso"]=lastPulled}}}
	  
	}

	local queryTable3 = { 
	  ["where"] = { ["operator"] = "/", ["createdAt"] = {["$gt"]= {["__type"]= "Date",["iso"]=lastPulled}}}
	  
	}
	parse:getObjects( "Question", queryTable, onGetAdd )
	parse:getObjects( "Question", queryTable1, onGetSub)
	parse:getObjects( "Question", queryTable2, onGetMult )
	parse:getObjects( "Question", queryTable3, onGetDiv )

	storeLastPulled(now)


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