/*-------------------------------------------------------------------------------------------------------------------------
	Send a player to another player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Send"
PLUGIN.Description = "Send a player to another player."
PLUGIN.Author = "Divran"
PLUGIN.ChatCommand = "send"
PLUGIN.Usage = "[players] [player]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin( ) and ply:IsValid( ) ) then
		local pl = evolve:findPlayer( args[#args], ply )
		table.remove( args, #args )
		local pls = evolve:findPlayer( args, ply )
		
		if ( #pls > 0 ) then
			for i, pl in pairs( pls ) do
				pl:SetPos( pl:GetPos() + Vector(0,0,i * 128) )
			end
			evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has sent ", evolve.colors.red, evolve:createPlayerList( pls ), evolve.colors.white, " to ", evolve.colors.red, pl:Nick(), evolve.colors.white, "." )
		else
			evolve:notify( ply, evolve.colors.white, "Did you mean ", evolve.colors.red, evolve:createPlayerList( pl, true ), evolve.colors.white, "?" )
		end
	else
		evolve:notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		RunConsoleCommand( "ev", "send", unpack( players ) )
	else
		return "Send", evolve.category.teleportation
	end
end

evolve:registerPlugin( PLUGIN )