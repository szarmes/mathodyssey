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
questionCount = 0
local round = -1
local dd1instructions = "You will now further explore the nature of Division."
local dd1instructions1 = "You will be given an asteroid field, and a certain number of groups to work with. "
local dd1instructions2 = "Your job is to find out how many asteroids will fit into each group, so that each group contains the same amount of asteroids."
local dd1instructions3 = "To help you figure out the answer, you're allowed to drag the asteroids into each group and see for yourself. This is optional."
local dd1instructions4 
local groups
local asteroidnum
local asteroids
local endGroup

local function dd1goHome()
	first = true
	round = -1
	mmcorrectCount = 0
	storyboard.purgeScene("divisiondash1")
	storyboard.gotoScene( "ddselection" )
end


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	endGroup = screenGroup
	bg = display.newImage("images/ddbg.png", centerX,centerY+(30*yscale))
	bg:scale(0.8*xscale,0.8*yscale)
	screenGroup:insert(bg)
	
	if (first) then

		bubble = display.newImage("images/bubble.png", centerX-20*xscale,centerY+100*yscale)
		bubble:scale(0.74*xscale,0.43*yscale)
		bubble.alpha = 0.7
		screenGroup:insert(bubble)

		dog = display.newImage(companionText, centerX-260*xscale, centerY+118*yscale)
		dog:scale(0.2*xscale, 0.2*yscale)
		dog:rotate(30)
		screenGroup:insert(dog)
		--dd1ShowMultiple(screenGroup)

		myText = display.newText(dd1instructions, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
		myText:setFillColor(0)
		screenGroup:insert(myText)
		dd1ShowNumbers(screenGroup)
	end
	dd1newQuestion(screenGroup)

	home = display.newImage("images/home.png",display.contentWidth-20*xscale,22*yscale)
	home:scale(0.3*xscale,0.3*yscale)
	home:addEventListener("tap", dd1goHome)
	screenGroup:insert(home)

	if first==false then
		hintbutton = display.newImage(companionText,display.contentWidth-20*xscale,90*yscale)
		hintbutton:scale(-0.14*xscale,0.14*yscale)

		local function dd1hint()
			hintbutton:removeEventListener("tap", dd1hint)
			provideHint(screenGroup,dd1instructions3)
		end
		hintbutton:addEventListener("tap",dd1hint)
		screenGroup:insert(hintbutton)
	end

end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )	
	if questionCount>=10 then
		round = -1
		questionCount = 0
		storyboard.gotoScene("showddscore", "fade", 200)
	else
		if round == -1 then
				for row in db:nrows("SELECT * FROM ddScore ORDER BY id DESC") do
				  round = row.round+1
				  break
				end
		end
	end
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	
end

-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )	
end

function dd1newQuestion(n) -- this will make a new question
	local screenGroup = n
	if (first) then
		local myfunction = function() dd1makeFirstDisappear(screenGroup) end
		continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
		continue:scale(0.3*xscale,0.3*yscale)
		continue:addEventListener("tap", myfunction)
		screenGroup:insert(continue)
	else 
		dd1Game(n)
	end
end

function dd1ShowNumbers(n)
	local screenGroup = n
	asteroidnum = math.random(4,10)*2
	groupnum = math.random(2,4)
	while asteroidnum%groupnum~=0 do
		groupnum = math.random(2,4)
	end
	dd1showGroups(screenGroup)
	asteroids = {}
	for j = 0 ,1, 1 do
		for i =1, asteroidnum/2, 1  do
			asteroids[((asteroidnum/2)*j)+i] = display.newImage("images/asteroid.png",((i*30))*xscale, centerY-40*yscale-(j+1)*40*yscale)
			asteroids[((asteroidnum/2)*j)+i]:scale(0.08*xscale, 0.08*yscale)
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

function dd1showGroups(n)
	local screenGroup = n
	groups = {}
	for i = 1,groupnum,1 do
		groups[i] = display.newImage("images/bubble.png",centerX-300*xscale+(400/groupnum)*i,centerY-10*yscale)
		groups[i]:scale(.3*xscale*1.7/groupnum,.3*yscale)
		groups[i].alpha = 0.7
		screenGroup:insert(groups[i])
		groups[i].count = 0
		if first == false then
			groups[i].counter = display.newText(0,groups[i].x+80/groupnum*xscale,groups[i].y+20*yscale, "Comic Relief",18)
			groups[i].counter:setFillColor(0)
			screenGroup:insert(groups[i].counter)
		end
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
    	dd1checkGroupCounts()
    end

 
end

function dd1checkGroupCounts()
	for j = 1,groupnum,1 do
		groups[j].count = 0
		for i = 1,asteroidnum,1 do
	    	if hasCollided(asteroids[i],groups[j]) then
	    		groups[j].count = groups[j].count +1
	    	end
	    end
	    groups[j].counter.text = groups[j].count
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


function dd1makeFirstDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText(dd1instructions1, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myfunction = function() dd1makeSecondDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myfunction)
	screenGroup:insert(continue)
end

function dd1makeSecondDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText(dd1instructions2, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 16 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myfunction = function() dd1makeThirdDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myfunction)
	screenGroup:insert(continue)
end

function dd1makeThirdDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText(dd1instructions3, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 16 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	local myfunction = function() dd1makeFourthDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myfunction)
	screenGroup:insert(continue)

end

function dd1makeFourthDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)
	dd1instructions4 = "In this example you would divide the field of "..asteroidnum.." asteroids into "..groupnum.." equal groups of "..(asteroidnum/groupnum).."."
	dd1instructions4 = dd1instructions4.." Good luck out there."
	myText = display.newText(dd1instructions4, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)



	first = false
	go = display.newImage("images/go.png", centerX+200*xscale, centerY+120*yscale)
	go:scale(0.5*xscale,0.5*yscale)
	go:addEventListener("tap", dd1newSceneListener)
	screenGroup:insert(go)

	dd1ShowAnswer(screenGroup)
end

function dd1ShowAnswer(n)
	local screenGroup = n

	for j = 1 , asteroidnum, 1 do
		screenGroup:remove(asteroids[j])
	end
	for i = 1,groupnum, 1 do
		for j = 1 , asteroidnum/groupnum, 1 do
			asteroids[j] = display.newImage("images/asteroid.png",(groups[i].x-200/groupnum*xscale+(j*15))*xscale, 140*yscale)
			asteroids[j]:scale(0.08*xscale, 0.08*yscale)
			screenGroup:insert(asteroids[j])
		end
	end


end

function dd1newSceneListener()
	storyboard.purgeScene("divisiondash1")
	storyboard.reloadScene()
end




function dd1Game(n)
	local screenGroup = n
	dd1ShowNumbers(screenGroup)
	dd1showChoices(screenGroup)

end


function dd1showChoices(n)
	local screenGroup = n
	startTime = system.getTimer()
	questionText = display.newText("If you divide "..asteroidnum.. " asteroids into "..groupnum.." groups, how many asteroids are in each group?", centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	questionText:setFillColor(0)
	screenGroup:insert(questionText)

	a={-205,-80,45,170}
	b = {}
	count = 4

	while (count>0) do --randomize the array of x values
		local r = math.random(1,count)
		b[count] = centerX+a[r]*xscale
		table.remove(a, r)
		count=count-1
	end
	dd1generateAnswerText()
	
	answer = display.newText(answerText,b[1],centerY+120*yscale, "Comic Relief",24)
	answer:setFillColor(0)
	function dd1listener()
		dd1correctResponseListener(screenGroup)
	end
	answer:addEventListener("tap", dd1listener)
	screenGroup:insert(answer)

	answer1 = display.newText(answer1Text,b[2],centerY+120*yscale, "Comic Relief", 24)
	answer1:setFillColor(0,0,0)
	local function listener1()
		dd1incorrectResponseListener1(screenGroup)
	end
	answer1:addEventListener("tap", listener1)
	screenGroup:insert(answer1)

	answer2 = display.newText(answer2Text,b[3],centerY+120*yscale, "Comic Relief", 24)
	answer2:setFillColor(0,0,0)
	local function listener2()
		dd1incorrectResponseListener2(screenGroup)
	end
	answer2:addEventListener("tap", listener2)
	screenGroup:insert(answer2)

	answer3 = display.newText(answer3Text,b[4],centerY+120*yscale, "Comic Relief", 24)
	answer3:setFillColor(0,0,0)
	local function listener3()
		dd1incorrectResponseListener3(screenGroup)
	end
	answer3:addEventListener("tap", listener3)
	screenGroup:insert(answer3)

end

function dd1generateAnswerText()
	answerText = asteroidnum/groupnum
	answer1Text = math.random(1,10)
	while answer1Text == answerText do
		answer1Text = math.random(1,10)
	end
	answer2Text = math.random(1,10)
	while answer2Text == answerText or answer2Text == answer1Text do
		answer2Text = math.random(1,10)
	end
	answer3Text = math.random(1,10)
	while answer3Text == answerText or answer3Text == answer1Text or answer3Text == answer2Text do
		answer3Text = math.random(1,10)
	end
end


function dd1correctResponseListener(n)
	if hintOn==false then
		local screenGroup = n
		local totalTime = math.floor((system.getTimer()-startTime)/1000)
		storeDD(1,totalTime,asteroidnum,groupnum,answerText,round,2)
		questionCount = questionCount + 1

		dd1removeAnswers(screenGroup)
		local reward = display.newText("Good Job!", centerX+70*xscale,centerY+50,300,0,"Comic Relief", 30)
		reward:setFillColor(0)
		screenGroup:insert(reward)

		local myFunction = function() dd1newSceneListener() end
		continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
		continue:scale(0.3*xscale,0.3*yscale)

		continue:addEventListener("tap", myFunction)
		screenGroup:insert(continue)
	end

	
end


function dd1incorrectResponseListener1(n) 
	if hintOn==false then
		local screenGroup = n
		local totalTime = math.floor((system.getTimer()-startTime)/1000)
		questionCount = questionCount + 1
		storeDD(0,totalTime,asteroidnum,groupnum,answer1Text,round,2)
		dd1wrongAnswer(screenGroup)
	end
	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end

function dd1incorrectResponseListener2(n)
	if hintOn==false then
		local screenGroup = n
		local totalTime = math.floor((system.getTimer()-startTime)/1000)
		questionCount = questionCount + 1
		storeDD(0,totalTime,asteroidnum,groupnum,answer2Text,round,2)
		dd1wrongAnswer(screenGroup)
	end

	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end

function dd1incorrectResponseListener3(n)
	if hintOn==false then
		local screenGroup = n
		local totalTime = math.floor((system.getTimer()-startTime)/1000)
		questionCount = questionCount + 1
		storeDD(0,totalTime,asteroidnum,groupnum,answer3Text,round,2)
		dd1wrongAnswer(screenGroup)
	end
	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end


function dd1removeAnswers(n)
	local screenGroup = n
	--screenGroup:remove(answer)
	
	screenGroup:remove(answer1)
	screenGroup:remove(answer2)
	screenGroup:remove(answer3)
	screenGroup:remove(questionText)
	answer:removeEventListener("tap",dd1listener)
	

end

function dd1wrongAnswer(n)
	local screenGroup = n
	dd1removeAnswers(screenGroup)
	questionText =display.newText( "Oops, the correct answer was", centerX, centerY+140*yscale,450*xscale,200*yscale, "Comic Relief", 18 )
	questionText:setFillColor(0)
	screenGroup:insert(questionText)

	local myFunction = function() dd1newSceneListener() end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
end


function enddd1Game(n)
	local screenGroup = endGroup
	screenGroup:remove(myText)
	myText = display.newText("Congratulations! You successfully divided "..asteroidnum.." by".. groupnum..", to form "..groupnum.." groups of "..(asteroidnum/2)..".", centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	storeDD(1,totalTime,asteroidnum,groupnum,asteroidnum,round,2)

	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", dd1goHome)
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