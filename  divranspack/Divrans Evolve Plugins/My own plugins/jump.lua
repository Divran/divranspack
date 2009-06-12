/*-------------------------------------------------------------------------------------------------------------------------
	Set Jump
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Jump power"
PLUGIN.Description = "Set the Jump power of players"
PLUGIN.Author = "Divran"
PLUGIN.Chat = "jump"
PLUGIN.Usage = "<player> [jump power]"

function PLUGIN:Call( ply, args )
	// First check if the caller is an admin
	if ply:IsAdmin() then
	
		// Find the player to slay
		local pl = Evolve:FindPlayer( args[1] )
		
		if pl then
			// Is the caller allowed to slay this player?
			if !ply:SameOrBetterThan( pl ) then
				return false, "You can't set the jump power of a player with a higher rank!"
			end
			
			// Is the jump power a number or nothing?
			local Jump = 160
			if args[2] and tonumber(args[2]) then
				Jump = tonumber( args[2] )
			elseif args[2] then
				return false, "The health must be numeric!"
			end
			
			pl:SetJumpPower( math.Clamp( Jump, 1, 10000000 ) ) 
			
			return true, ply:Nick() .. " has set " .. pl:Nick() .. "'s jump power to " .. math.Clamp( Jump, 1, 99999 ) .. "."
		else
			return false, "Player not found!"
		end
		
	else
		return false, "You are not an administrator!"
	end
end

Evolve:RegisterPlugin( PLUGIN )