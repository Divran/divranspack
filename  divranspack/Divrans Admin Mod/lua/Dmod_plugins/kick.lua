-------------------------------------------------------------------------------------------------------------------------
-- Kick
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "kick" -- The chat command you need to use this plugin
DmodPlugin.Name = "Kick" -- The name of the plugin
DmodPlugin.Description = "Allows you to kick someone from your server." -- The description shown in the Menu
DmodPlugin.ShowInMenu = true -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Creator = "Divran" -- Who created it?
if SERVER then Dmod_AddPlugin(DmodPlugin) end


local function Dmod_Kick( ply, Args )
	if (Args[2]) then
		if (Dmod_FindPlayer(Args[2])) then
			local T = Dmod_FindPlayer(Args[2])
			local Reason = Dmod_GetReason(Args, 3)
			T:Kick(Reason)
			Dmod_Message(true, ply, ply:Nick() .. " kicked " .. T:Nick() .. " with the reason '" .. Reason .. "'.")
		else
			Dmod_Message(false, ply, "No player named '"..Args[2].."' found.")
		end
	else
		Dmod_Message( false, ply, "You must enter a name!")
	end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Kick )