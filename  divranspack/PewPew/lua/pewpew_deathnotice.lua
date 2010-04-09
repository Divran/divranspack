-- PewPew DeathNotice
-- Fixes the death notice so that it doesn't just say "pewpew_base_bullet"

-- Wait 1 second to give the gamemode time to load
timer.Simple(1,function()
	-- Save the PlayerDeath function
	local OldFunc = GAMEMODE.PlayerDeath
	-- Override the PlayerDeath function
	function GAMEMODE:PlayerDeath( Victim, Inflictor, Attacker )
		-- Check if the attacker is a pewpew bullet
		if (Attacker:GetClass() == "pewpew_base_bullet") then
			-- Check if its name is valid
			if (Attacker.Bullet and Attacker.Bullet.Name and Attacker.Bullet.Name != "") then
				-- Send umsg
				umsg.Start("PlayerKilled")
					umsg.Entity( Victim )
					umsg.String( "suicide" )
					umsg.String( "(PewPew) " .. Attacker.Bullet.Name )
				umsg.End()
			end
			
			-- Set spawn time
			Victim.NextSpawnTime = CurTime() + 2
			Victim.DeathTime = CurTime()
			return
		end
		
		-- Check if the attacker is a pewpew cannon
		if (Attacker:GetClass() == "pewpew_base_cannon") then
			-- Check if its name is valid
			if (Attacker.Bullet and Attacker.Bullet.Name and Attacker.Bullet.Name != "") then
				-- Send umsg
				umsg.Start("PlayerKilled")
					umsg.Entity( Victim )
					umsg.String( "suicide" )
					umsg.String( "(PewPew) " .. Attacker.Bullet.Name )
				umsg.End()
			end
			
			-- Set spawn time
			Victim.NextSpawnTime = CurTime() + 2
			Victim.DeathTime = CurTime()
			return
		end
		
		OldFunc( GAMEMODE, Victim, Inflictor, Attacker )
	end
end)