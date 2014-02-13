---------------------------------------------------------------------------------
--
-- createquestion.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
require "dbFile"


local buttonXOffset = 100
local buttons
local buttonbgs


---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY

function goHome()
	storyboard.purgeScene("createbedmas")
	storyboard.gotoScene("train")
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
	
	insertButtons(screenGroup)
	--audio.play(bgmusic,{loops = -1,channel=1})

	--background = display.newImage("images/cat.jpg",centerX,centerY)
	--Runtime:addEventListener("touch",moveCatListener)
	--screenGroup:insert( background )

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local screenGroup = self.view	

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	
end

function insertButtons(n)
	local screenGroup = n
	buttons = {}
	buttonbgs = {}
	--1 to 9
	for i = 0,2,1 do
		for j = 1,3,1 do
			buttonbgs[(3*i)+j] = display.newImage(buttonSource,40+50*j*xscale,centerY+50*yscale-50*i*yscale)
			buttonbgs[(3*i)+j]:scale(0.14*xscale,0.14*yscale)
			local function myFunction()
				recordPress((3*i)+j)
			end
			buttonbgs[(3*i)+j]:addEventListener("tap",myFunction)
			screenGroup:insert(buttonbgs[(3*i)+j])
			buttons[(3*i)+j] = display.newText((3*i+j),40+50*j*xscale,centerY+50*yscale-50*i*yscale, "Comic Relief",24)
			buttons[(3*i)+j]:setFillColor(0)
			screenGroup:insert(buttons[(3*i)+j])
		end
	end
	--zero
	zerobg = display.newImage(buttonSource,40+50*2*xscale,centerY+100*yscale)
	zerobg:scale(0.45*xscale,0.14*yscale)
	zerobutton = display.newText("0",40+50*2*xscale,centerY+100*yscale,"Comic Relief",24)
	zerobutton:setFillColor(0)
	local function myFunction()
		recordPress(zerobutton.text)
	end
	zerobg:addEventListener("tap",myFunction)
	screenGroup:insert(zerobg)
	screenGroup:insert(zerobutton)
	--division
	divbg = display.newImage(buttonSource,40+50*4*xscale,centerY-50*yscale)
	divbg:scale(0.14*xscale,0.14*yscale)
	divbutton = display.newText("/",40+50*4*xscale,centerY-50*yscale,"Comic Relief",24)
	divbutton:setFillColor(0)
	local function myFunction()
		recordPress(divbutton.text)
	end
	divbg:addEventListener("tap",myFunction)
	screenGroup:insert(divbg)
	screenGroup:insert(divbutton)
	--multiplication
	multbg = display.newImage(buttonSource,40+50*4*xscale,centerY+50*yscale-50*yscale)
	multbg:scale(0.14*xscale,0.14*yscale)
	multbutton = display.newText("*",40+50*4*xscale,centerY,"Comic Relief",24)
	multbutton:setFillColor(0)
	local function myFunction()
		recordPress(multbutton.text)
	end
	multbg:addEventListener("tap",myFunction)
	screenGroup:insert(multbg)
	screenGroup:insert(multbutton)
	--addition
	addbg = display.newImage(buttonSource,40+50*4*xscale,centerY+50*yscale)
	addbg:scale(0.14*xscale,0.14*yscale)
	addbutton = display.newText("+",40+50*4*xscale,centerY+50*yscale,"Comic Relief",24)
	addbutton:setFillColor(0)
	local function myFunction()
		recordPress(addbutton.text)
	end
	addbg:addEventListener("tap",myFunction)
	screenGroup:insert(addbg)
	screenGroup:insert(addbutton)
	--subtraction
	subbg = display.newImage(buttonSource,40+50*4*xscale,centerY+100*yscale)
	subbg:scale(0.14*xscale,0.14*yscale)
	subbutton = display.newText("-",40+50*4*xscale,centerY+100*yscale,"Comic Relief",24)
	subbutton:setFillColor(0)
	local function myFunction()
		recordPress(subbutton.text)
	end
	subbg:addEventListener("tap",myFunction)
	screenGroup:insert(subbg)
	screenGroup:insert(subbutton)
	--textbox
	textbox = display.newImage("images/bubble.png",centerX-40*xscale,centerY-100*yscale)
	textbox:scale(0.7*xscale,0.2*yscale)
	textbox.alpha = 0.8
	screenGroup:insert(textbox)
	textboxtext = display.newText("",centerX-40*xscale,centerY-100*yscale,"Comic Relief",24)
	textboxtext:setFillColor(0)
	screenGroup:insert(textboxtext)
	--submit
	submitbg = display.newImage(buttonSource,centerX+130*xscale,centerY-20*yscale)
	submitbg:scale(0.4*xscale,0.2*yscale)
	screenGroup:insert(submitbg)
	submittext = display.newText("Submit",centerX+130*xscale,centerY-20*yscale,"Comic Relief",24)
	submittext:setFillColor(0)
	screenGroup:insert(submittext)
	--clear
	clearbg = display.newImage(buttonSource,centerX+130*xscale,centerY+60*yscale)
	clearbg:scale(0.4*xscale,0.2*yscale)
	screenGroup:insert(clearbg)
	cleartext = display.newText("Clear",centerX+130*xscale,centerY+60*yscale,"Comic Relief",24)
	cleartext:setFillColor(0)
	local function myFunction()
		textboxtext.text=""
	end
	clearbg:addEventListener("tap",myFunction)
	screenGroup:insert(clearbg)
	screenGroup:insert(cleartext)
end

function recordPress(num)
	textboxtext.text= textboxtext.text..num
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