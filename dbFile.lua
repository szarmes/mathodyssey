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


function storeTimeTrials(correct,time, correctHa, correctMa, chosenHa, chosenMa, r1,r2,round)

	--Setup the table if it doesn't exist
	local tablesetup = [[CREATE TABLE IF NOT EXISTS timeTrialsScore (id INTEGER PRIMARY KEY, correct INTEGER, 
		time INTEGER, correctHa INTEGER, correctMa INTEGER, chosenHa INTEGER, chosenMa INTEGER, 
		r1 INTEGER, r2 INTEGER, round INTEGER);]]
	db:exec( tablesetup )

	local tablefill =[[INSERT INTO timeTrialsScore VALUES (NULL, ']]..correct..[[',']]..time..[[',']]..correctHa..
		[[',']]..correctMa..[[',']]..chosenHa..[[',']]..chosenMa..[[',']]..r1..[[',']]..r2..[[',']]..round..[['); ]]
	db:exec( tablefill )

end

----------------