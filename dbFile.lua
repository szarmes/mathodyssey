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
		[[',']]..chosenum..[[',']]..round..[[',']]..level..[['); ]]
	db:exec( tablefill )

end

----------------