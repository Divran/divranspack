/*-------------------------------------------------------------------------------------------------------------------------
	Slapping
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Slap"
PLUGIN.Description = "Slap players"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "slap"
PLUGIN.Usage = "<player> [damage]"

function PLUGIN:Call( ply, args )
	// First check if the caller is an admin
	if ply:IsAdmin() then
	
		// Find the player to slap
		local pl = Evolve:FindPlayer( args[1] )
		
		if pl then
			// Is the caller allowed to slap this player?
			if !ply:SameOrBetterThan( pl ) then
				return false, "You can't slap a player with a higher rank!"
			end
			
			// Is the damage a number or nothing?
			local dmg = 10
			if args[2] and tonumber( args[2] ) then
				dmg = tonumber( args[2] )
				if dmg < 1 then
					return false, "The damage must be greater than zero!"
				end
			elseif args[2] then
				return false, "The damage must be numeric!"
			end
			
			pl:SetHealth( pl:Health( ) - dmg )
			
			-- Here's the stuff I added
			pl:ViewPunch( Angle(math.random(-45,45), math.random(-45,45), math.random(-45,45) ) )
			pl:SetVelocity( Vector( math.Round(math.random(-1,1)) * 600, math.Round(math.random(-1,1)) * 600, math.Round(math.random(-0.1,2)) * 400) )
			local Rand = math.Round(math.random(1,2))
			if (Rand == 1) then pl:EmitSound("player/pl_fallpain1.wav",100,100) end
			if (Rand == 2) then pl:EmitSound("player/pl_fallpain3.wav",100,100) end
			-----------
			
			if pl:Health( ) < 1 then pl:Kill( ) end
			
			return true, ply:Nick() .. " slapped " .. pl:Nick() .. " with " .. dmg .. " damage."
		else
			return false, "Player not found!"
		end
		
	else
		return false, "You are not an administrator!"
	end
end

Evolve:RegisterPlugin( PLUGIN )