if SERVER then
	--Player Spawn
	function Dmod_TeamColors( ply )
		timer.Simple( 0.2, function()
		-- PUT YOUR STEAM ID HERE TO BECOME OWNER:
			if (ply:SteamID() == "STEAM_0:0:9583907") then
				ply:SetTeam(4)
			elseif (ply:IsSuperAdmin()) then
				ply:SetTeam(3)
			elseif (ply:IsAdmin()) then
				ply:SetTeam(2)
			else
				ply:SetTeam(1)
			end
		end)
	end
	hook.Add( "PlayerSpawn", "Dmod_TeamColors", Dmod_TeamColors )
end
	
	-- Change color and Name in Scoreboard here, if you want.
team.SetUp(4, "Owner", Color( 50, 50, 50, 255 )) -- Black (Well, almost)
team.SetUp(3, "Super Admin", Color( 255, 200, 0, 255 )) -- Gold
team.SetUp(2, "Admin", Color(200, 80, 80, 255 )	) -- Dark Red
team.SetUp(1, "Guest", Color( 100, 100, 255, 255 )) -- Dark Blue