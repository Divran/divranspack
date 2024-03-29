-------------------------------------------------------------------------------------------------------------------------
-- Me
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "me" -- The chat command you need to use this plugin
DmodPlugin.Name = "Me" -- The name of the plugin
DmodPlugin.Description = "Use for roleplaying or if you just want to be funny :)" -- The description shown in the Menu
DmodPlugin.ShowInMenu = false -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Type = "other" -- Where in the Menu will it show?
DmodPlugin.Creator = "Divran" -- Who created it?
DmodPlugin.RequiredRank = "Guest" -- The rank required to use this command. Can be "Guest", "Respected", "Admin", "Super Admin", or "Owner".
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end


local function Dmod_Plugin( ply, Args )
if (Dmod_CheckRequiredRank(ply, DmodPlugin.RequiredRank)) then
	if (Dmod_GetReason( Args, 2 ) != "No reason") then
		Dmod_Message( true, ply, ply:Nick() .. " " .. Dmod_GetReason( Args, 2 ), "normal" )
	else
		Dmod_Message( false, ply, "You must enter a message!","warning" )
	end
end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Plugin )