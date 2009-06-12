/*-------------------------------------------------------------------------------------------------------------------------
	Teleporting
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Teleport"
PLUGIN.Description = "Teleport to where you aim or certain coordinates"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "tp"
--PLUGIN.Usage = "<player> [coordinates]"

function PLUGIN:Call( ply, args )
	// First check if the caller is an admin
	if ply:IsAdmin() then
	
		// Find the player to teleport if any
		pl = Evolve:FindPlayer( args[1] )
		
		if pl then
			
			if #args == 1 then
				pl:SetPos( ply:GetEyeTrace( ).HitPos + Vector(0,0,10) )
				pl:SetLocalVelocity( Vector(0,0,0) )
			elseif tonumber( args[2] ) and tonumber( args[3] ) and tonumber( args[4] ) then
				pl:SetPos( Vector( args[2], args[3], args[4] ) )
			else
				return false, "Invalid coordinates!"
			end
			
			return true, ply:Nick( ) .. " has teleported " .. pl:Nick( ) .. "."
			
		else
			ply:SetPos( ply:GetEyeTrace().HitPos + Vector(0,0,10) )
			ply:SetLocalVelocity( Vector(0,0,0) )
			return true, ply:Nick() .. " has teleported."
		end
		
	else
		return false, "You are not an administrator!"
	end
end

Evolve:RegisterPlugin( PLUGIN )