-------------------------------------------------------------------------------------------------------------------------
-- Ungod
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "ungod"
DmodPlugin.Name = "Ungod"
if SERVER then Dmod_AddPlugin(DmodPlugin) end

local function Dmod_Ungod( ply, Args )
	if (Args[2]) then
		if (Dmod_FindPlayer(Args[2])) then
			local T = Dmod_FindPlayer(Args[2])
			T:GodDisable()
			Dmod_Message(true, ply, ply:Nick() .. " disabled godmode for " .. T:Nick() .. ".")
		else
			Dmod_Message(false, ply, "No player named '"..Args[2].."' found.")
		end
	else
		ply:GodDisable()
		Dmod_Message( true, ply, ply:Nick() .. " disabled godmode for him/herself.")
	end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Ungod)