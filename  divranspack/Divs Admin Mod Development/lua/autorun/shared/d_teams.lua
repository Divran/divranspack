if (SERVER) then
	--Player Spawn
	function D_Respawn( ply )
		timer.Simple( 0.2, function()
			if (ply:IsSuperAdmin()) then
				ply:SetTeam(1)
			elseif (ply:IsAdmin()) then
				ply:SetTeam(2)
			else
				ply:SetTeam(3)
			end
		end)
	end
	hook.Add( "PlayerSpawn", "D_Respawn", D_Respawn )
end

team.SetUp(1, "Owner", Color( 50, 50, 50, 255 ))
team.SetUp(2, "Admin", Color( 255, 200, 0, 245 ))
team.SetUp(3, "Guest", Color( 100, 100, 255, 255 ))

if (CLIENT) then
end