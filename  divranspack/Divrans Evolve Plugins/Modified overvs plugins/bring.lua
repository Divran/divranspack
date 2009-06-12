/*-------------------------------------------------------------------------------------------------------------------------
	Bring
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Bring"
PLUGIN.Description = "Bring a player to you"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "bring"
PLUGIN.Usage = "<player>"

function PLUGIN:Call( ply, args )
	// First check if the caller is an admin
	if ply:IsAdmin() then
	
		// Find the player to bring
		local pl = Evolve:FindPlayer( args[1] )
		
		if pl then
			// Is the caller allowed to bring this player?
			if !ply:SameOrBetterThan( pl ) then
				return false, "You can't bring a player with a higher rank!"
			end
			
			local Pos = ply:GetPos() + ply:GetForward() * 100 -- Get the forward direction
			pl:SetPos( Pos ) -- Teleport
			pl:SetLocalVelocity( Vector( 0,0,0 ) ) -- Set velocity to 0
			if (ply != pl) then pl:SnapEyeAngles( (ply:GetPos() - pl:GetPos()):Angle() ) end -- If the target is not yourself, make the target look at you
			
			return true, ply:Nick() .. " has brought " .. pl:Nick() .. "."
		else
			return false, "Player not found!"
		end
		
	else
		return false, "You are not an administrator!"
	end
end

Evolve:RegisterPlugin( PLUGIN )