/*-------------------------------------------------------------------------------------------------------------------------
	Set Speed
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Speed Strength"
PLUGIN.Description = "Set the movement speed of players"
PLUGIN.Author = "Divran"
PLUGIN.Chat = "speed"
PLUGIN.Usage = "<player> [Movement Speed]"

function PLUGIN:Call( ply, args )
	// First check if the caller is an admin
	if ply:IsAdmin() then
	
		// Find the player to slay
		local pl = Evolve:FindPlayer( args[1] )
		
		if pl then
			// Is the caller allowed to slay this player?
			if !ply:SameOrBetterThan( pl ) then
				return false, "You can't set the movement speed of a player with a higher rank!"
			end
			
			// Is the Speed strength a number or nothing?
			local Speed = 250
			if args[2] and tonumber(args[2]) then
				Speed = tonumber( args[2] )
			elseif args[2] then
				return false, "The speed must be numeric!"
			end
			
			pl:SetWalkSpeed( math.Clamp( Speed, 1, 10000000 ) ) 
			pl:SetRunSpeed( math.Clamp( Speed + 250, 1, 10000000 ) ) 
			
			return true, ply:Nick() .. " has set " .. pl:Nick() .. "'s movement speed to " .. math.Clamp( Speed, 1, 10000000 ) .. "."
		else
			return false, "Player not found!"
		end
		
	else
		return false, "You are not an administrator!"
	end
end

Evolve:RegisterPlugin( PLUGIN )