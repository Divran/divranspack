-------------------------------------------------------------------------------------------------------------------------
-- Admin Noclip
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "adminnoclip" -- The chat command you need to use this plugin
DmodPlugin.Name = "Admin Noclip" -- The name of the plugin
DmodPlugin.Description = "Block non-admins from using noclip." -- The description shown in the Menu
DmodPlugin.ShowInMenu = true -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Creator = "Divran" -- Who created it?
DmodPlugin.RequiredRank = "admin" -- The rank required to use this command. Can be "guest", "admin", "super admin", or "owner".
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end


local function Dmod_AdminNoclip( ply, Args )
	if (Dmod_CheckRequiredRank(ply, DmodPlugin.RequiredRank)) then
		Dmod_ServerAdminNoclip( ply )
	end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_AdminNoclip)