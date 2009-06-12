/*-------------------------------------------------------------------------------------------------------------------------
	Send
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Send"
PLUGIN.Description = "Send a player to another player"
PLUGIN.Author = "Divran"
PLUGIN.Chat = "send"
PLUGIN.Usage = "<player> <player>"

function PLUGIN:Call( ply, args )
	// First check if the caller is an admin
	if ply:IsAdmin() then
	
		// Find the players to send
		local pl = Evolve:FindPlayer( args[1] )
		local pl2 = Evolve:FindPlayer( args[2] )
		
		if (pl and pl2) then
			// Is the caller allowed to send this player?
			if !ply:SameOrBetterThan( pl ) then
				return false, "You can't send a player with a higher rank!"
			end
			
			//Is the caller allowed to send this player too?
			if !ply:SameOrBetterThan( pl2 ) then
				return false, "You can't send a player with a higher rank!"
			end
			
			local Pos = pl2:GetPos() + pl2:GetForward() * 100 -- Get the forward direction
			pl:SetPos( Pos ) -- Teleport
			pl:SetLocalVelocity( Vector( 0,0,0 ) ) -- Set velocity to 0
			if (pl != pl2) then pl:SnapEyeAngles( (pl2:GetPos() - pl:GetPos()):Angle() ) end -- If the target is not yourself, make the target look at you
			
			return true, ply:Nick() .. " has sent " .. pl:Nick() .. " to " .. pl2:Nick() .. "."
		else
			return false, "One of the players were not found!"
		end
		
	else
		return false, "You are not an administrator!"
	end
end

Evolve:RegisterPlugin( PLUGIN )