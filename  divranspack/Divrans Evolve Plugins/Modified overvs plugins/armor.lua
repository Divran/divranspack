/*-------------------------------------------------------------------------------------------------------------------------
	Set armor
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Armor"
PLUGIN.Description = "Set the armor of players"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "armor"
PLUGIN.Usage = "<player> [armor]"

function PLUGIN:Call( ply, args )
	// First check if the caller is an admin
	if ply:IsAdmin() then
	
		// Find the player to slay
		local pl = Evolve:FindPlayer( args[1] )
		
		if pl then
			// Is the caller allowed to slay this player?
			if !ply:SameOrBetterThan( pl ) then
				return false, "You can't set the armor of a player with a higher rank!"
			end
			
			// Is the health a number or nothing?
			local Armor = 100
			if args[2] and tonumber(args[2]) then
				Armor = tonumber( args[2] )
			elseif args[2] then
				return false, "The armor must be numeric!"
			end
			
			if Armor > 10000 then
				return false, "The armor can't be over 10000!"
			end
			
			math.Clamp( Armor, 1, 99999 )
			
			return true, ply:Nick() .. " has set " .. pl:Nick() .. "'s armor to " .. math.Clamp( Armor, 1, 99999 ) .. "."
		else
			return false, "Player not found!"
		end
		
	else
		return false, "You are not an administrator!"
	end
end

Evolve:RegisterPlugin( PLUGIN )