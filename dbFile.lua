require "sqlite3"

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

end

function storeEE1(correct,time, correcte, chosene, round,level)

	local tablefill =[[INSERT INTO eeScore VALUES (NULL, ']]..correct..[[',']]..time..[[',']]..correcte..
		[[',']]..chosene..[[',NULL, NULL, ']]..round..[[',']]..level..[['); ]]
	db:exec( tablefill )

end

function storeEE2(correct,time, correctnum, chosennum, round,level)

	local tablefill =[[INSERT INTO eeScore VALUES (NULL, ']]..correct..[[',']]..time..[[',NULL, NULL, ']]..correctnum..
		[[',']]..chosennum..[[',']]..round..[[',']]..level..[['); ]]
	db:exec( tablefill )

end

function storeBB(correct,time, correctsign, chosensign, lval,rval, round,level)

	local tablefill =[[INSERT INTO bbScore VALUES (NULL, ']]..correct..[[',']]..time..[[',']]..correctsign..
		[[',']]..chosensign..[[',']]..lval..[[',']]..rval..[[',']]..round..[[',']]..level..[['); ]]
	db:exec( tablefill )

end

function storePatterns(correct,time, multiple,round,level)
	local tablefill =[[INSERT INTO mmScore VALUES (NULL, ']]..correct..[[',']]..time..[[',']]..multiple..
		[[',NULL,NULL,NULL, ']]..round..[[',']]..level..[['); ]]
	db:exec( tablefill )
end

function storeRepeat(correct,time, correctanswer, chosenanswer,round,level)
	local tablefill =[[INSERT INTO mmScore VALUES (NULL, ']]..correct..[[',']]..time..[[',']]..correctanswer..
		[[',']]..chosenanswer..[[',NULL,NULL, ']]..round..[[',']]..level..[['); ]]
	db:exec( tablefill )

end

function storeFirst(n)
	
	local tablefill =[[INSERT INTO firstTime VALUES (NULL, ']]..n..[['); ]]
	db:exec( tablefill )

end

function storeCompanion(n)
	
	local tablefill =[[INSERT INTO companionSelect VALUES (NULL, ']]..n..[['); ]]
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


----------------