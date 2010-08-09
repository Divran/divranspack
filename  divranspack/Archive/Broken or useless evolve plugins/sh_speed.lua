/*-------------------------------------------------------------------------------------------------------------------------
	Set the speed of a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Speed"
PLUGIN.Description = "Set the movement speed of a player."
PLUGIN.Author = "Divran"
PLUGIN.ChatCommand = "speed"
PLUGIN.Usage = "[players] [speed]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin( ) ) then
		local pls = evolve:findPlayer( args, ply, true )
		if ( #pls > 0 and !pls[1]:IsValid( ) ) then pls = { } end
		local Speed = 250
		if ( tonumber( args[ #args ] ) ) then Speed = tonumber( args[ #args ] ) end
		
		for _, pl in pairs( pls ) do
			pl:SetWalkSpeed( Speed ) 
			pl:SetRunSpeed( Speed * 2 ) 
		end
		
		if ( #pls > 0 ) then
			evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has set the movement speed of ", evolve.colors.red, evolve:createPlayerList( pls ), evolve.colors.white, " to " .. Speed .. "." )
		else
			evolve:notify( ply, evolve.colors.red, "No matching players found." )
		end
	else
		evolve:notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		table.insert( players, arg )
		RunConsoleCommand( "ev", "speed", unpack( players ) )
	else
		args = { }
		args[1] = { "Slow (50)", 50 }
		args[2] = { "Default (250)", 250 }
		args[3] = { "Fast (1000)", 1000 }
		args[4] = { "Very fast (3000)", 3000 }
		args[5] = { "Over 9000! (9001)", 9001 }
		args[6] = { "Extremely fast (9999999999)", 9999999999 }
		return "Speed", evolve.category.actions, args
	end
end

evolve:registerPlugin( PLUGIN )