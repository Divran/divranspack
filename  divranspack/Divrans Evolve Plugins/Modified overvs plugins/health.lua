/*-------------------------------------------------------------------------------------------------------------------------
	Set health
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Health"
PLUGIN.Description = "Set the health of players"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "hp"
PLUGIN.Usage = "<player> [health]"

function PLUGIN:Call( ply, args )
	// First check if the caller is an admin
	if ply:IsAdmin() then
	
		// Find the player to slay
		local pl = Evolve:FindPlayer( args[1] )
		
		if pl then
			// Is the caller allowed to slay this player?
			if !ply:SameOrBetterThan( pl ) then
				return false, "You can't set the health of a player with a higher rank!"
			end
			
			// Is the health a number or nothing?
			local HP = 100
			if args[2] and tonumber(args[2]) then
				HP = tonumber( args[2] )
			elseif args[2] then
				return false, "The health must be numeric!"
			end
			
			pl:SetHealth( math.Clamp( HP, 1, 99999 ) ) 
			
			return true, ply:Nick() .. " has set " .. pl:Nick() .. "'s health to " .. math.Clamp( HP, 1, 99999 ) .. "."
		else
			return false, "Player not found!"
		end
		
	else
		return false, "You are not an administrator!"
	end
end

Evolve:RegisterPlugin( PLUGIN )