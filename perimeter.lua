---------------------------------------------------------------------------------
--
-- perimeter.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
storyboard.purgeAll()
require "dbFile"
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY
first = true
local round = -1
questionCount = 0
local instructions = "Welcome to the Moon of Multiplication. Here, you will put your multiplication skills to the test."
local instructions1 = "One thing multiplication is useful for is finding the perimeter of a shape. Perimeter is just a term used to define the distance surrounding a shape."
local instructions2 = "For shapes that have sides with equal lengths, multiplying the side length by the number of sides will give you the permiter."
local instructions3 = "Find the number of sides, and multiply that number by the length of each side to find the perimeter."
local instructions4
local instructions5 = "Watch your back out there."
local polygon
local sides
local length

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	bg = display.newImage("images/mmmoonbg.png", centerX,centerY+30*yscale)
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
		myText = display.newText( instructions, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
		myText:setFillColor(0)
		screenGroup:insert(myText)
	end

	home = display.newImage("images/home.png",display.contentWidth-20*xscale,22*yscale)
	home:scale(0.3*xscale,0.3*yscale)
	home:addEventListener("tap", perimetergoHome)
	screenGroup:insert(home)
	
	if first==false then
		hintbutton = display.newImage(companionText,display.contentWidth-20*xscale,90*yscale)
		hintbutton:scale(-0.14*xscale,0.14*yscale)

		local function perimeterhint()
			provideHint(screenGroup,instructions2)
		end
		hintbutton:addEventListener("tap",perimeterhint)
		screenGroup:insert(hintbutton)
	end

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	if questionCount>=10 then
		round = -1
		questionCount = 0
		storyboard.gotoScene("showmmscore", "fade", 200)
	else

		if round == -1 then
			for row in db:nrows("SELECT * FROM mmScore ORDER BY id DESC") do
			  round = row.round+1
			  break
			end
		end

		local screenGroup = self.view
		perimetergenerateAnswers()
		perimetergenerateAnswerText()
		perimeterdisplayNumbers(screenGroup)

		instructions4 = "In this case, the perimeter is "..sides*length.. " since there are "..sides.. " sides with length of "..length.."."
		perimeternewQuestion(screenGroup)
	end
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	
end
function perimetergoHome()
	first = true
	round = -1
	questionCount = 0
	storyboard.purgeScene("perimeter")
	storyboard.gotoScene( "mmmoonselection")
end

function perimeternewQuestion(n)
	local screenGroup = n

	if (first) then
		continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
		continue:scale(0.3*xscale,0.3*yscale)
		local myFunction = function() perimetermakeFirstDisappear(screenGroup) end
		continue:addEventListener("tap", myFunction)
		screenGroup:insert(continue)
	else 
		perimetershowChoices(screenGroup)
	end

end

function perimetermakeFirstDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( instructions1, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 16 )
	myText:setFillColor(0)
	screenGroup:insert(myText)
	local myFunction = function() perimetermakeSecondDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)
	screenGroup:insert(continue)
	continue:addEventListener("tap", myFunction)
	--showAnswer(screenGroup)
end

function perimetermakeSecondDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( instructions2, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 16 )
	myText:setFillColor(0)
	screenGroup:insert(myText)
	local myFunction = function() perimetermakeThirdDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)
	screenGroup:insert(continue)
	continue:addEventListener("tap", myFunction)
	--showAnswer(screenGroup)
end

function perimetermakeThirdDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( instructions3, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 16 )
	myText:setFillColor(0)
	screenGroup:insert(myText)
	local myFunction = function() perimetermakeFourthDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)
	screenGroup:insert(continue)
	continue:addEventListener("tap", myFunction)
	--showAnswer(screenGroup)
end
function perimetermakeFourthDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)
	screenGroup:remove(valueText)
	myText = display.newText( instructions4, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	solution = display.newText("Perimeter: "..length*sides, centerX, centerY-30*yscale, "Comic Relief", 20)
	solution.anchorX = 0
	solution:setFillColor(0)
	screenGroup:insert(solution)

	local myFunction = function() perimetermakeFifthDisappear(screenGroup) end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)
end

function perimetermakeFifthDisappear(n)
	local screenGroup = n
	screenGroup:remove(myText)
	screenGroup:remove(continue)

	myText = display.newText( instructions5, centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	first = false
	go = display.newImage("images/go.png", centerX+200*xscale, centerY+120*yscale)
	go:scale(0.5*xscale,0.5*yscale)
	go:addEventListener("tap", perimeternewSceneListener)
	screenGroup:insert(go)
end

function perimeternewSceneListener()
	storyboard.purgeScene("perimeter")
	storyboard.reloadScene()
end

function perimetergenerateAnswers()
	polygonnum = math.random(1,5)
	if polygonnum == 1 then
		polygon = "images/triangle.png"
		sides = 3
	end
	if polygonnum == 2 then
		polygon = "images/square.png"
		sides = 4
	end
	if polygonnum == 3 then
		polygon = "images/pentagon.png"
		sides = 5
	end
	if polygonnum == 4 then
		polygon = "images/hexagon.png"
		sides = 6
	end
	if polygonnum == 5 then
		polygon = "images/octagon.png"
		sides = 8
	end
	length = math.random(2,5)
	
end

function perimetershowChoices(n)
	local screenGroup = n
	startTime = system.getTimer()
	questionText =display.newText( "What is the perimeter of this shape?", centerX, centerY+140*yscale,400*xscale,200*yscale, "Comic Relief", 18 )
	questionText:setFillColor(0)
	screenGroup:insert(questionText)
	
	a={-185,-60,65,190}
	b = {}
	count = 4

	while (count>0) do --randomize the array of x values
		local r = math.random(1,count)
		b[count] = centerX+a[r]*xscale
		table.remove(a, r)
		count=count-1
	end
	
	answer = display.newText(answerText,b[1],centerY+100*yscale, "Comic Relief", 20)
	answer:setFillColor(0)
	function perimeterlistener()
		perimetercorrectResponseListener(screenGroup)
	end
	answer:addEventListener("tap", perimeterlistener)
	screenGroup:insert(answer)

	answer1 = nil
	answer1 = display.newText(answer1Text,b[2],centerY+100*yscale, "Comic Relief", 20)
	answer1:setFillColor(0)
	local function listener1()
		perimeterincorrectResponseListener1(screenGroup)
	end
	answer1:addEventListener("tap", listener1)
	screenGroup:insert(answer1)

	answer2 = nil
	answer2 = display.newText(answer2Text,b[3],centerY+100*yscale, "Comic Relief", 20)
	answer2:setFillColor(0)
	local function listener2()
		perimeterincorrectResponseListener2(screenGroup)
	end
	answer2:addEventListener("tap", listener2)
	screenGroup:insert(answer2)

	answer3 = nil
	answer3 = display.newText(answer3Text,b[4],centerY+100*yscale, "Comic Relief", 20)
	answer3:setFillColor(0)
	local function listener3()
		perimeterincorrectResponseListener3(screenGroup)
	end
	answer3:addEventListener("tap", listener3)
	screenGroup:insert(answer3)

end

function perimetergenerateAnswerText()

	if length == 5 then
		answerText = sides*5
		answer1Text = sides*4
		answer2Text =  sides*3
		answer3Text =  sides*2
	end
	if length == 4 then
		answer1Text =  sides*5
		answerText =  sides*4
		answer2Text =  sides*3
		answer3Text =  sides*2
	end
	if length == 3 then
		answer2Text =  sides*5
		answer1Text =  sides*4
		answerText =  sides*3
		answer3Text =  sides*2
	end
	if length == 2 then
		answer3Text =  sides*5
		answer1Text =  sides*4
		answer2Text = sides*3
		answerText =  sides*2
	end

end

function perimeterdisplayNumbers(n)
	local screenGroup = n
	question = display.newText("Sides: "..sides, centerX+60*xscale, centerY-90*yscale, "Comic Relief", 20)
	question:setFillColor(0)
	screenGroup:insert(question)

	local screenGroup = n
	question1 = display.newText("Side length: "..length, centerX+60*xscale, centerY-60*yscale, "Comic Relief", 20)
	question1:setFillColor(0)
	screenGroup:insert(question1)

	local polygonPic = display.newImage(polygon,centerX-100*xscale,centerY-50*yscale)
	polygonPic:scale(0.5,0.5)
	screenGroup:insert(polygonPic)
end


function perimetercorrectResponseListener(n)
	local screenGroup = n
	screenGroup:remove(valueText)
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	storeRepeat(1,totalTime,answerText,answerText,round,4)
	questionCount = questionCount + 1

		solution = display.newText("Perimeter: "..length*sides, centerX, centerY-30*yscale, "Comic Relief", 20)
	solution.anchorX = 0
	solution:setFillColor(0)
	screenGroup:insert(solution)


	perimeterremoveAnswers(screenGroup)
	local reward = display.newText("Good Job!", centerX+70*xscale,centerY+50,300,0,"Comic Relief", 30)
	reward:setFillColor(0)
	screenGroup:insert(reward)

	local myFunction = function() perimeternewSceneListener() end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
	screenGroup:insert(continue)

end


function perimeterincorrectResponseListener1(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	questionCount = questionCount + 1
	storeRepeat(0,totalTime,answerText,answer1Text,round,4)
	perimeterwrongAnswer(screenGroup)
	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end

function perimeterincorrectResponseListener2(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	questionCount = questionCount + 1
	storeRepeat(0,totalTime,answerText,answer2Text,round,4)
	perimeterwrongAnswer(screenGroup)

	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end

function perimeterincorrectResponseListener3(n)
	local screenGroup = n
	local totalTime = math.floor((system.getTimer()-startTime)/1000)
	questionCount = questionCount + 1
	storeRepeat(0,totalTime,answerText,answer3Text,round,4)
	perimeterwrongAnswer(screenGroup)
	--storyboard.purgeScene("exponentialenergy")
	--storyboard.gotoScene("tryagain")
end


function perimeterremoveAnswers(n)
	local screenGroup = n
	--screenGroup:remove(answer)
	screenGroup:remove(valueText)
	screenGroup:remove(answer1)
	screenGroup:remove(answer2)
	screenGroup:remove(answer3)
	screenGroup:remove(questionText)
	answer:removeEventListener("tap",perimeterlistener)
	

end

function perimeterwrongAnswer(n)
	local screenGroup = n
	perimeterremoveAnswers(screenGroup)

		solution = display.newText("Perimeter: "..length*sides, centerX, centerY-30*yscale, "Comic Relief", 20)
	solution.anchorX = 0
	solution:setFillColor(0)
	screenGroup:insert(solution)


	questionText =display.newText( "Oops, the correct answer was", centerX, centerY+140*yscale,450*xscale,200*yscale, "Comic Relief", 18 )
	questionText:setFillColor(0)
	screenGroup:insert(questionText)

	local myFunction = function() perimeternewSceneListener() end
	continue = display.newImage("images/continue.png", centerX+200*xscale, centerY+130*yscale)
	continue:scale(0.3*xscale,0.3*yscale)

	continue:addEventListener("tap", myFunction)
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