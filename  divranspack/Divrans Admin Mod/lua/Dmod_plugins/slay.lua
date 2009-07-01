-------------------------------------------------------------------------------------------------------------------------
-- Slay
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "slay"
DmodPlugin.Name = "Slay"
if SERVER then Dmod_AddPlugin(DmodPlugin) end


local function Dmod_Slay( ply, Args )
	if (Args[2]) then
		if (Dmod_FindPlayer(Args[2])) then
			local T = Dmod_FindPlayer(Args[2])
			T:Kill()
			T:AddFrags(1)
			Dmod_Message(true, ply, ply:Nick() .. " slayed " .. T:Nick() .. ".")
		else
			Dmod_Message(false, ply, "No player named '"..Args[2].."' found.")
		end
	else
		Dmod_Message( false, ply, "You must enter a name!")
	end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Slay)