-------------------------------------------------------------------------------------------------------------------------
-- Clear Decals
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "decals" -- The chat command you need to use this plugin
DmodPlugin.Name = "Clear Decals" -- The name of the plugin
DmodPlugin.Description = "Clear all the decals on the server (bullet holes, explosion marks)" -- The description shown in the Menu
DmodPlugin.ShowInMenu = true -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Creator = "Divran" -- Who created it?
DmodPlugin.RequiredRank = "admin" -- The rank required to use this command. Can be "guest", "admin", "super admin", or "owner".
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end


local function Dmod_Decals( ply, Args )
if (Dmod_CheckRequiredRank(ply, DmodPlugin.RequiredRank)) then
	for k, v in pairs(player.GetAll()) do
		v:ConCommand("r_cleardecals 1")
	end
	Dmod_Message( true, ply, ply:Nick() .. " cleared all the decals.")
end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Decals)