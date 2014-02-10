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
first = true
local round = -1
local ddinstructions = "On this planet you will be learning about Division, a term used to describe how you split up a number."
local ddinstructions1 = "Your first task will be to split a group of asteroids into two smaller groups of asteroids, each of which having the same amount."
local ddinstructions2 = "To accomplish this, drag the asteroids into the areas provided for each group."
local ddinstructions3 = "You will find out that division is a lot easier than it looks."
local ddinstructions4 
local groups
local asteroidnum
local asteroids
local endGroup

local function ddgoHome()
	first = true
	round = -1
	mmcorrectCount = 0
	storyboard.purgeScene("divisiondash")
	storyboard.gotoScene( "menu" )
end


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	endGroup = screenGroup
	bg = display.newImage("images/ddbg.png", centerX,centerY+(30*yscale))
	bg:scale(0.8*xscale,0.8*yscale)
	screenGroup:insert(bg)
	
	bubble = display.newImage("images/bubble.png", centerX-20*xscale,centerY+100*yscale)
	bubble:scale(0.74*xscale,0.43*yscale)
	bubble.alpha = 0.7
	screenGroup:insert(bubble)

	dog = display.newImage(companionText, centerX-260*xscale, centerY+118*yscale)
	dog:scale(0.2*xscale, 0.2*yscale)
	dog:rotate(30)
	screenGroup:insert(dog)


	if (first) then
		myText = display.newText(ddinstructions, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
		myText:setFillColor(0)
		screenGroup:insert(myText)
		ddShowNumbers(screenGroup)
		--ddShowMultiple(screenGroup)
	end
	ddnewQuestion(screenGroup)

	home = display.newImage("images/home.png",display.contentWidth-20*xscale,22*yscale)
	home:scale(0.3*xscale,0.3*yscale)
	home:addEventListener("tap", ddgoHome)
	screenGroup:insert(home)

end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )	

	if round == -1 then
			for row in db:nrows("SELECT * FROM ddScore ORDER BY id DESC") do
			  round = row.round+1
			  break
			end
	end
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	
end

-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )	
end

function ddnewQuestion(n) -- this will make a new question
	local screenGroup = n
	if (first) then
		local myfunction = function() ddmakeFirstDisappear(screenGroup) end
		continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
		continue:scale(0.3*xscale,0.3*yscale)
		continue:addEventListener("tap", myfunction)
		screenGroup:insert(continue)
	else 
		ddGame(n)
	end
end

function ddShowNumbers(n)
	local screenGroup = n
	asteroidnum = math.random(5,10)*2
	groups = 2
	ddshowGroups(screenGroup)
	asteroids = {}
	for j = 0 ,1, 1 do
		for i =1, asteroidnum/2, 1  do
			asteroids[((asteroidnum/2)*j)+i] = display.newImage("images/asteroid.png",((i*38)+20)*xscale, centerY-40*yscale-(j+1)*40*yscale)
			asteroids[((asteroidnum/2)*j)+i]:scale(0.12*xscale, 0.12*yscale)
			if first == false then
				asteroids[((asteroidnum/2)*j)+i]:addEventListener("touch",dragAsteroid)
			end
			--physics.addBody(asteroids[(6*j)+i],{radius = 10})
			screenGroup:insert(asteroids[((asteroidnum/2)*j)+i])
		end
	end
	if first == false then
		startTime = system.getTimer()
	end
end

function ddshowGroups(n)
	local screenGroup = n
	
	group1 = display.newImage("images/bubble.png",centerX-130*xscale,centerY-10*yscale)
	group1:scale(.3*xscale,.3*yscale)
	group1.alpha = 0.7
	screenGroup:insert(group1)

	group2 = display.newImage("images/bubble.png",centerX+130*xscale,centerY-10*yscale)
	group2:scale(.3*xscale,.3*yscale)
	group2.alpha = 0.7
	screenGroup:insert(group2)

	group1count = asteroidnum/2
	group2count = asteroidnum/2

	if first == false then
		group1counter = display.newText(0,group1.x+80*xscale,group1.y+20*yscale, "Comic Relief",16)
		group1counter:setFillColor(0)
		screenGroup:insert(group1counter)

		group2counter = display.newText(0,group2.x+80*xscale,group2.y+20*yscale, "Comic Relief",16)
		group2counter:setFillColor(0)
		screenGroup:insert(group2counter)
	end
	
end

function dragAsteroid(event)
	if event.phase == "began" then
		focus = event.target
		focus.markX = focus.x    -- store x location of object
        focus.markY = focus.y
       
	end
	if event.phase == "moved" then
        local x = (event.x - event.xStart) + focus.markX
        local y = (event.y - event.yStart) + focus.markY
        
        focus.x, focus.y = x, y  

    end

    if event.phase == "ended" or event.phase == "cancelled" then
    	ddcheckEndGame()
    end

 
end

function ddcheckEndGame()
	group1count = asteroidnum/2
	group2count = asteroidnum/2
	local g1counter = 0
	local g2counter = 0

	for i = 1,asteroidnum,1 do
    	if hasCollided(asteroids[i],group1) then
    		group1count = group1count-1
    		g1counter=g1counter+1
    	end
    	if hasCollided(asteroids[i],group2) then
    		group2count = group2count-1
    		g2counter = g2counter+1
    	end
    end
    group1counter.text = g1counter
    group2counter.text = g2counter
    if group1count==0 and group2count==0 then
    	endddGame()
    end
  
end

function hasCollided(obj1, obj2)
    if obj1 == nil then
        return false
    end
    if obj2 == nil then
        return false
    end

    local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
    local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
    local up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
    local down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax
    return (left or right) and (up or down)
end


function ddmakeFirstDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText(ddinstructions1, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 16 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myfunction = function() ddmakeSecondDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myfunction)
	screenGroup:insert(continue)
end

function ddmakeSecondDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText(ddinstructions2, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myfunction = function() ddmakeThirdDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myfunction)
	screenGroup:insert(continue)
end

function ddmakeThirdDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText(ddinstructions3, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myfunction = function() ddmakeFourthDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myfunction)
	screenGroup:insert(continue)

end

function ddmakeFourthDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)
	ddinstructions4 = "In this example you would divide the field of "..asteroidnum.." asteroids into two equal groups of "..(asteroidnum/2).."."
	ddinstructions4 = ddinstructions4.." Good luck out there."
	myText = display.newText(ddinstructions4, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)



	first = false
	go = display.newImage("images/go.png", centerX+200*xscale, centerY+120*yscale)
	go:scale(0.5*xscale,0.5*yscale)
	go:addEventListener("tap", ddnewSceneListener)
	screenGroup:insert(go)

	ddShowAnswer(screenGroup)
end

function ddShowAnswer(n)
	local screenGroup = n

	for j = 1 , asteroidnum, 1 do
		screenGroup:remove(asteroids[j])
	end

	for j = 1 , asteroidnum/2, 1 do
		asteroids[j] = display.newImage("images/asteroid.png",(group1.x-100*xscale+(j*20))*xscale, 140*yscale)
		asteroids[j]:scale(0.12*xscale, 0.12*yscale)
		screenGroup:insert(asteroids[j])
	end

	for j = 1 , asteroidnum/2, 1 do
		asteroids[j] = display.newImage("images/asteroid.png",(group2.x-80*xscale+(j*20))*xscale, 140*yscale)
		asteroids[j]:scale(0.12*xscale, 0.12*yscale)
		screenGroup:insert(asteroids[j])
	end

end

function ddnewSceneListener()
	storyboard.purgeScene("divisiondash")
	storyboard.reloadScene()
end


function showddGameInstructions(n)
	local screenGroup = n
	ddGameInstructions= "Split the field of "..asteroidnum.." asteroids into "..groups.. " equal groups, by dragging them into position."
	

	myText = display.newText(ddGameInstructions, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)
end

function ddGame(n)
	local screenGroup = n
	ddShowNumbers(screenGroup)
	showddGameInstructions(screenGroup)

end

function endddGame(n)
	local screenGroup = endGroup
	screenGroup:remove(myText)
	myText = display.newText("Congratulations! You successfully divided "..asteroidnum.." by two, to form two groups of "..(asteroidnum/2)..".", centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)
	unlockMap("dd1")
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	storeDD(1,totalTime,asteroidnum,2,asteroidnum,round,1)

	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", ddgoHome)
	screenGroup:insert(continue)

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