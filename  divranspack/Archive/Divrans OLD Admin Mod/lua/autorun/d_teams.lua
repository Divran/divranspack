if (SERVER) then
	--Player Spawn
	function D_Respawn( ply )
		timer.Simple( 0.2, function()
		-- PUT YOUR STEAM ID HERE TO BECOME OWNER:
			if (ply:SteamID() == "STEAM_0:0:00") then
				ply:SetTeam(1)
			elseif (ply:IsSuperAdmin()) then
				ply:SetTeam(2)
			elseif (ply:IsAdmin()) then
				ply:SetTeam(3)
			else
				ply:SetTeam(4)
			end
		end)
	end
	hook.Add( "PlayerSpawn", "D_Respawn", D_Respawn )
end

-- Change color and Name in Scoreboard here, if you want.
team.SetUp(1, "Owner", Color( 50, 50, 50, 255 )) -- Black (Well, almost)
team.SetUp(2, "Super Admin", Color( 255, 200, 0, 255 )) -- Gold
team.SetUp(3, "Admin", Color(200, 80, 80, 255 )	) -- Dark Red
team.SetUp(4, "Guest", Color( 100, 100, 255, 255 )) -- Dark Blue

if (CLIENT) then
end