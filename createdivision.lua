---------------------------------------------------------------------------------
--
-- createquestion.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
require "dbFile"
local parse = require( "mod_parse" )

parse:init( { appId = "ni9gpjglpS7C6uCwOuTAnVV0nySg4g7hxHLnRFlq", 
	apiKey = "rn3sImdi93KlhtBXsQbNXC7mBV41OvveyljmXFmI" } )



local buttonXOffset = 100
local buttons
local buttonbgs

local highlighted = "left"
local leftnum = 0
local rightnum = 0
local answernum = 0
local startTime
local operatortext

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY


function goHome(event)
	if event.phase == "ended" then
		storyboard.removeScene("createdivision")
		storyboard.gotoScene("train")
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


	dog = display.newImage(companionText, centerX-240*xscale, centerY+118*yscale)
	dog:scale(0.2*xscale, 0.2*yscale)
	screenGroup:insert(dog)
	
	insertButtons(screenGroup)
	--audio.play(bgmusic,{loops = -1,channel=1})

	--background = display.newImage("images/cat.jpg",centerX,centerY)
	--Runtime:addEventListener("touch",moveCatListener)
	--screenGroup:insert( background )

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local screenGroup = self.view	
	startTime = system.getTimer()
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	
end

function insertButtons(n)
	local screenGroup = n
	startTime = system.getTimer()
	buttons = {}
	buttonbgs = {}
	--1 to 9
	for i = 0,2,1 do
		for j = 1,3,1 do
			local function myFunction(event)
				if event.phase == "ended" then
					recordPress((3*i)+j)
				end
			end
			buttonbgs[(3*i)+j] = widget.newButton
			{
			   	defaultFile = buttonSource,
		    	overFile = buttonPressedSource,
			    onEvent = myFunction
			}
			buttonbgs[(3*i)+j].x = 40+50*j*xscale
			buttonbgs[(3*i)+j].y = centerY+50*yscale-50*i*yscale
			buttonbgs[(3*i)+j]:scale(0.14*xscale,0.14*yscale)
			
			screenGroup:insert(buttonbgs[(3*i)+j])
			buttons[(3*i)+j] = display.newText((3*i+j),40+50*j*xscale,centerY+50*yscale-50*i*yscale, "Comic Relief",24)
			buttons[(3*i)+j]:setFillColor(0)
			screenGroup:insert(buttons[(3*i)+j])
		end
	end
	--zero
	local function myFunction(event)
		if event.phase == "ended" then
			recordPress(0)
		end
	end
	zerobg = widget.newButton
		{
		    defaultFile = buttonSource,
		    overFile = buttonPressedSource,
		    onEvent = myFunction
		}

	zerobg.x = 40+75*1*xscale
	zerobg.y = centerY+100*yscale
	zerobg:scale(0.3*xscale,0.14*yscale)
	zerobutton = display.newText("0",40+75*1*xscale,centerY+100*yscale,"Comic Relief",24)
	zerobutton:setFillColor(0)

	screenGroup:insert(zerobg)
	screenGroup:insert(zerobutton)
	--submit
	local function myFunction(event)
		if event.phase=="ended" then
			if leftnum~=0 or rightnum~=0 then
				submit(screenGroup)
			end
		end
	end
	submitbg = widget.newButton
		{
		    defaultFile = buttonSource,
		    overFile = buttonPressedSource,
		    onEvent = myFunction
		}
	submitbg.x = centerX+130*xscale
	submitbg.y = centerY-20*yscale
	submitbg:scale(0.4*xscale,0.15*yscale)
	screenGroup:insert(submitbg)
	
	submittext = display.newText("Submit",centerX+130*xscale,centerY-20*yscale,"Comic Relief",24)
	submittext:setFillColor(0)
	screenGroup:insert(submittext)

	--clear
	local function myFunction(event)
		if event.phase=="ended" then
			if highlighted== "left" then
			lefttext.text=""
			leftnum = 0
			elseif highlighted == "right" then
			righttext.text=""
			rightnum = 0
			elseif highlighted == "answer" then
				answertext.text=""
				answernum = 0
			end
			if incorrect~=nil then
				screenGroup:remove(bubble)
				screenGroup:remove(incorrect)
				incorrect = nil
			end
		end
	end
	clearbg = widget.newButton
		{
		    defaultFile = buttonSource,
		    overFile = buttonPressedSource,
		    onEvent = myFunction
		}
	clearbg.x = centerX+130*xscale
	clearbg.y = centerY+100*yscale
	clearbg:scale(0.4*xscale,0.15*yscale)
	screenGroup:insert(clearbg)
	cleartext = display.newText("Clear",centerX+130*xscale,centerY+100*yscale,"Comic Relief",24)
	cleartext:setFillColor(0)
	clearbg:addEventListener("tap",myFunction)
	screenGroup:insert(clearbg)
	screenGroup:insert(cleartext)

	--clear all
	local function myFunction(event)
		if event.phase=="ended" then
			lefttext.text=""
			righttext.text=""
			answertext.text=""
			leftnum = 0
			rightnum = 0
			answernum = 0
			if incorrect~=nil then
				screenGroup:remove(bubble)
				screenGroup:remove(incorrect)
				incorrect = nil
			end
		end
	end
	clearallbg = widget.newButton
		{
		    defaultFile = buttonSource,
		    overFile = buttonPressedSource,
		    onEvent = myFunction
		}
	clearallbg.x = centerX+130*xscale
	clearallbg.y = centerY+40*yscale
	clearallbg:scale(0.4*xscale,0.15*yscale)
	screenGroup:insert(clearallbg)
	clearalltext = display.newText("Clear All",centerX+130*xscale,centerY+40*yscale,"Comic Relief",24)
	clearalltext:setFillColor(0)
	clearallbg:addEventListener("tap",myFunction)
	screenGroup:insert(clearallbg)
	screenGroup:insert(clearalltext)
	
	
	--textbox
	textbox = display.newImage("images/bubble.png",centerX-40*xscale,centerY-100*yscale)
	textbox:scale(0.7*xscale,0.2*yscale)
	screenGroup:insert(textbox)
	
	--operator
	operatortext = display.newText("/",centerX-130*xscale,centerY-105*yscale,"Comic Relief",40)
	operatortext:setFillColor(0)
	screenGroup:insert(operatortext)

	--equalsign
	equaltext = display.newText("=",centerX+40*xscale,centerY-105*yscale,"Comic Relief",40)
	equaltext:setFillColor(0)
	screenGroup:insert(equaltext)
	

	leftbg = display.newImage(buttonSource,centerX-210*xscale,centerY-100*yscale)
	leftbg:scale(0.35*xscale,0.17*yscale)


	leftbg1 = display.newImage("images/selection.png",centerX-210*xscale,centerY-100*yscale)
	leftbg1:scale(0.35*xscale,0.17*yscale)
	leftbg1.isVisible = false
	

	lefttext = display.newText("",centerX-200*xscale,centerY-100*yscale,"Comic Relief",24)
	lefttext:setFillColor(0)
	local function myFunction()
		highlight("left")
	end
	leftbg:addEventListener("tap",myFunction)
	leftbg1:addEventListener("tap",myFunction)

	screenGroup:insert(leftbg)
	screenGroup:insert(leftbg1)
	screenGroup:insert(lefttext)

	rightbg = display.newImage(buttonSource,centerX-50*xscale,centerY-100*yscale)
	rightbg:scale(0.35*xscale,0.17*yscale)
	rightbg.isVisible = false

	rightbg1 = display.newImage("images/selection.png",centerX-50*xscale,centerY-100*yscale)
	rightbg1:scale(0.35*xscale,0.17*yscale)

	righttext = display.newText("",centerX-50*xscale,centerY-100*yscale,"Comic Relief",24)
	righttext:setFillColor(0)
	local function myFunction()
		highlight("right")
	end
	rightbg:addEventListener("tap",myFunction)
	rightbg1:addEventListener("tap",myFunction)
	screenGroup:insert(rightbg)
	screenGroup:insert(rightbg1)
	screenGroup:insert(righttext)


	answerbg = display.newImage(buttonSource,centerX+130*xscale,centerY-100*yscale)
	answerbg:scale(0.35*xscale,0.17*yscale)
	answerbg.isVisible = false
	answerbg1 = display.newImage("images/selection.png",centerX+130*xscale,centerY-100*yscale)
	answerbg1:scale(0.35*xscale,0.17*yscale)
	answertext = display.newText("",centerX+130*xscale,centerY-100*yscale,"Comic Relief",24)
	answertext:setFillColor(0)
	local function myFunction()
		highlight("answer")
	end
	answerbg:addEventListener("tap",myFunction)
	answerbg1:addEventListener("tap",myFunction)
	screenGroup:insert(answerbg)
	screenGroup:insert(answerbg1)
	screenGroup:insert(answertext)
end

function recordPress(num)
	if highlighted == "left" then
		if leftnum < 10 then
			leftnum = leftnum*10+num
		end
		lefttext.text= leftnum
	end
	if highlighted == "right" then
		if rightnum < 1 then
			rightnum = rightnum*10+num
		end
		righttext.text= rightnum	end
	if highlighted == "answer" then
		if answernum < 10 then
			answernum = answernum*10+num
		end
		answertext.text= answernum	end
end

function highlight(str)
	if str == "left" then
		rightbg.isVisible=false
		rightbg1.isVisible = true
		answerbg.isVisible = false
		answerbg1.isVisible = true
		leftbg.isVisible = true
		leftbg1.isVisible = false
	elseif str == "right" then
		rightbg.isVisible=true
		rightbg1.isVisible = false
		answerbg.isVisible = false
		answerbg1.isVisible = true
		leftbg.isVisible = false
		leftbg1.isVisible = true
	elseif str == "answer" then
		rightbg.isVisible=false
		rightbg1.isVisible = true
		answerbg.isVisible = true
		answerbg1.isVisible = false
		leftbg.isVisible = false
		leftbg1.isVisible = true
	end
	highlighted = str

end

function submit(n)
	local  screenGroup = n
	totalTime = math.floor((system.getTimer() -startTime)/1000)
	if leftnum / rightnum == answernum then
		unlockMap("practicediv")
		storeQuestion(1,totalTime,leftnum,rightnum,answernum,"/")
		addCoins(1)
		local function onCreateUser( event )
		  print( event.response.createdAt )
		  print( event.response.sessionToken )
		end
		 
		--create Parse User
		local dataTable = { ["timespent"] = totalTime, ["leftnum"] = leftnum, ["rightnum"] = rightnum,["answernum"] = answernum, ["operator"] = "/" }
		if consent==true then
			parse:createObject( "Question", dataTable, onCreateObject )
		end
		bubble = display.newImage("images/bubble.png", centerX-225*xscale,centerY)
		bubble:scale(0.15*xscale,0.3*yscale)
		screenGroup:insert(bubble)
		
		rewardText = display.newText("Question created!",centerX-225*xscale,centerY,60*xscale,60*yscale,"Comic Relief",12)
		rewardText:setFillColor(0)
		screenGroup:insert(rewardText)

		continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
		continue:scale(0.3*xscale,0.3*yscale)
		continue:addEventListener("tap", divideNewSceneListener)
		screenGroup:insert(continue)

	else
		storeQuestion(0,totalTime,leftnum,rightnum,answernum,"/")
		if incorrect==nil then
			bubble = display.newImage("images/bubble.png", centerX-225*xscale,centerY)
			bubble:scale(0.15*xscale,0.3*yscale)
			screenGroup:insert(bubble)
			
			incorrect = display.newText("Woops, try again",centerX-225*xscale,centerY,60*xscale,60*yscale,"Comic Relief",14)
			incorrect:setFillColor(0)
			screenGroup:insert(incorrect)
		end
	end
end

function divideNewSceneListener()
	storyboard.purgeScene("createdivision")
	leftnum = 0
	rightnum = 0
	answernum = 0
	highlighted = "left"
	storyboard.gotoScene("createdivision")

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