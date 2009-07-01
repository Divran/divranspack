-------------------------------------------------------------------------------------------------------------------------
-- Respawn
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "respawn"
DmodPlugin.Name = "respawn"
Dmod_AddPlugin(DmodPlugin)


local function Dmod_Respawn( ply, Args )
	if (Args[2]) then
		if (Dmod_FindPlayer(Args[2])) then
			local T = Dmod_FindPlayer(Args[2])
			T:Spawn()
			Dmod_Message(true, ply, ply:Nick() .. " respawned " .. T:Nick() .. ".")
		else
			Dmod_Message(false, ply, "No player named '"..Args[2].."' found.")
		end
	else
		ply:Spawn()
		Dmod_Message( true, ply, ply:Nick() .. " respawned.")
	end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Respawn)