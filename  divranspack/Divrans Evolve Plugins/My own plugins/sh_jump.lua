/*-------------------------------------------------------------------------------------------------------------------------
	Set the jump power of a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Jump"
PLUGIN.Description = "Set the jump power of a player."
PLUGIN.Author = "Divran"
PLUGIN.ChatCommand = "jump"
PLUGIN.Usage = "[players] [jump power]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin( ) ) then
		local pls = evolve:findPlayer( args, ply, true )
		if ( #pls > 0 and !pls[1]:IsValid( ) ) then pls = { } end
		local Jump = 160
		if ( tonumber( args[ #args ] ) ) then Jump = tonumber( args[ #args ] ) end
		
		for _, pl in pairs( pls ) do
			pl:SetJumpPower( Jump ) 
		end
		
		if ( #pls > 0 ) then
			evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has set the jump power of ", evolve.colors.red, evolve:createPlayerList( pls ), evolve.colors.white, " to " .. Jump .. "." )
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
		RunConsoleCommand( "ev", "Jump", unpack( players ) )
	else
		args = { }
		args[1] = { "Low (100)", 100 }
		args[2] = { "Default (160)", 160 }
		args[3] = { "High (1000)", 1000 }
		args[4] = { "Very High (5000)", 5000 }
		args[5] = { "Over 9000! (9001)", 9001 }
		args[6] = { "Extremely High (9999999999)", 9999999999 }
		return "Jump", evolve.category.actions, args
	end
end

evolve:registerPlugin( PLUGIN )