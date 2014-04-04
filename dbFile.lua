require "sqlite3"
local parse = require( "mod_parse" )


-----Database Stuff

local path = system.pathForFile("data.db", system.DocumentsDirectory)
db = sqlite3.open( path )   
 
--Handle the applicationExit event to close the db
function onSystemEvent( event )
        if( event.type == "applicationExit" ) then              
            db:close()
        end
end


--setup the system listener to catch applicationExit
Runtime:addEventListener( "system", onSystemEvent )


function storeTimeTrials(correct,time, correctHa, correctMa, chosenHa, chosenMa, r1,r2,round,level)

	local tablefill =[[INSERT INTO timeTrialsScore VALUES (NULL, ']]..correct..[[',']]..time..[[',']]..correctHa..
		[[',']]..correctMa..[[',']]..chosenHa..[[',']]..chosenMa..[[',']]..r1..[[',']]..r2..[[',']]
		..round..[[',']]..level..[['); ]]
	
	db:exec( tablefill )

	local dataTable = { ["correct"] = correct,["time"] = time, ["correctHa"]=correctHa, ["correctMa"]=correctMa, ["chosenHa"]=chosenHa, ["chosenMa"]=chosenMa, ["r1"]=r1,["r2"]=r2,["round"]=round,["level"]=level}
	if consent==true then
		parse:createObject( "TTData", dataTable, onCreateObject )
	end

end

function storeEE1(correct,time, correcte, chosene, round,level)

	local tablefill =[[INSERT INTO eeScore VALUES (NULL, ']]..correct..[[',']]..time..[[',']]..correcte..
		[[',']]..chosene..[[',NULL, NULL, ']]..round..[[',']]..level..[['); ]]
	db:exec( tablefill )

	local dataTable = { ["correct"] = correct,["time"] = time, ["correcte"]=correcte, ["chosene"]=chosene,["round"]=round,["level"]=level}
	if consent==true then
		parse:createObject( "EE1Data", dataTable, onCreateObject )
	end

end

function storeEE2(correct,time, correctnum, chosennum, round,level)

	local tablefill =[[INSERT INTO eeScore VALUES (NULL, ']]..correct..[[',']]..time..[[',NULL, NULL, ']]..correctnum..
		[[',']]..chosennum..[[',']]..round..[[',']]..level..[['); ]]
	db:exec( tablefill )

	local dataTable = { ["correct"] = correct,["time"] = time, ["correctnum"]=correctnum, ["chosennum"]=chosennum,["round"]=round,["level"]=level}
	if consent==true then
		parse:createObject( "EE2Data", dataTable, onCreateObject )
	end

end

function storeBB(correct,time, correctsign, chosensign, lval,rval, round,level)

	local tablefill =[[INSERT INTO bbScore VALUES (NULL, ']]..correct..[[',']]..time..[[',']]..correctsign..
		[[',']]..chosensign..[[',']]..lval..[[',']]..rval..[[',']]..round..[[',']]..level..[['); ]]
	db:exec( tablefill )

	local dataTable = { ["correct"] = correct,["time"] = time, ["correctsign"]=correctsign, ["chosensign"]=chosensign,["lval"]=lval,["rval"]=rval,["round"]=round,["level"]=level}
	if consent==true then
		parse:createObject( "BBData", dataTable, onCreateObject )
	end

end

function storeDD(correct,time, numerator, denominator, chosennum,round,level)

	local tablefill =[[INSERT INTO ddScore VALUES (NULL, ']]..correct..[[',']]..time..[[',']]..numerator..
		[[',']]..denominator..[[',']]..chosennum..[[',']]..round..[[',']]..level..[['); ]]
	db:exec( tablefill )

	local dataTable = { ["correct"] = correct,["time"] = time, ["numerator"]=numerator, ["denominator"]=denominator,["chosennum"]=chosennum,["round"]=round,["level"]=level}
	if consent==true then
		parse:createObject( "DDData", dataTable, onCreateObject )
	end

end

function storePatterns(correct,time, multiple,round,level)
	local tablefill =[[INSERT INTO mmScore VALUES (NULL, ']]..correct..[[',']]..time..[[',']]..multiple..
		[[',NULL,NULL,NULL, ']]..round..[[',']]..level..[['); ]]
	db:exec( tablefill )

	local dataTable = { ["correct"] = correct,["time"] = time, ["multiple"]=multiple, ["round"]=round,["level"]=level}
	if consent==true then
		parse:createObject( "PatternsData", dataTable, onCreateObject )
	end
end

function storeRepeat(correct,time, correctanswer, chosenanswer,round,level)
	local tablefill =[[INSERT INTO mmScore VALUES (NULL, ']]..correct..[[',']]..time..[[',']]..correctanswer..
		[[',']]..chosenanswer..[[',NULL,NULL, ']]..round..[[',']]..level..[['); ]]
	db:exec( tablefill )
	local dataTable = { ["correct"] = correct,["time"] = time, ["correctanswer"]=correctanswer, ["chosenanswer"]=chosenanswer,["round"]=round,["level"]=level}
	if consent==true then
		parse:createObject( "RepeatData", dataTable, onCreateObject )
	end
end

function storeFirst(n)
	
	local tablefill =[[INSERT INTO firstTime VALUES (NULL, ']]..n..[['); ]]
	db:exec( tablefill )

end

function storeCompanion(n)
	local tablefill =[[Delete from companionSelect]]
	db:exec( tablefill )
	tablefill =[[INSERT INTO companionSelect VALUES (NULL, ']]..n..[['); ]]
	db:exec( tablefill )

end

function storeShip(n)
	local tablefill =[[Delete from shipSelect]]
	db:exec( tablefill )
	tablefill =[[INSERT INTO shipSelect VALUES (NULL, ']]..n..[['); ]]
	db:exec( tablefill )

end

function unlockMap(location)

	local mapcheck = false
	for row in db:nrows("SELECT * FROM mapUnlocks;") do
		if row.location == location then
			mapcheck = true
			break
		end
	end
	if mapcheck == false then

		local tablefill =[[INSERT INTO mapUnlocks VALUES (NULL, ']]..location..[['); ]]
		db:exec( tablefill )
	end
end

function unlockItem(name)

	local itemcheck = false
	for row in db:nrows("SELECT * FROM itemUnlocks;") do
		if row.name == name then
			itemcheck = true
			break
		end
	end
	if itemcheck == false then

		local tablefill =[[INSERT INTO itemUnlocks VALUES (NULL, ']]..name..[['); ]]
		db:exec( tablefill )
	end
end

function storeQuestion(correct,time,left,right,answer,operator)
	
	local tablefill =[[INSERT INTO createdQuestions VALUES (NULL, ']]..correct..[[',']]..time..[[',']]..left..
		[[',']]..right..[[',']]..answer..[[',']]..operator..[['); ]]
	db:exec( tablefill )

end

function storeAnswer(correct,time,left,right,answer,operator)
	
	local tablefill =[[INSERT INTO answeredQuestions VALUES (NULL, ']]..correct..[[',']]..time..[[',']]..left..
		[[',']]..right..[[',']]..answer..[[',']]..operator..[['); ]]
	db:exec( tablefill )

end

function storeLastPlanet(planet)

	local tablefill =[[Delete from lastPlanet]]
	db:exec( tablefill )
	tablefill =[[INSERT INTO lastPlanet VALUES (NULL, ']]..planet..[['); ]]
	db:exec( tablefill )

end

function addCoins(amount)
	local coins = 0
	for row in db:nrows("SELECT * FROM coins;") do
		if row.amount~=nil then
			coins = coins + row.amount
		end
	end
	coins = coins+amount
	local tablefill =[[Delete from coins]]
	db:exec( tablefill )
	tablefill =[[INSERT INTO coins VALUES (NULL, ']]..coins..[['); ]]
	db:exec( tablefill )

end

function storeLastPulled(date)
	local tablefill =[[Delete from lastPulled]]
	db:exec( tablefill )
	tablefill =[[INSERT INTO lastPulled VALUES (NULL, NULL,']]..date..[['); ]]
	db:exec( tablefill )

end


----------------