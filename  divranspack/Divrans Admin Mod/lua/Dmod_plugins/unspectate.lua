-------------------------------------------------------------------------------------------------------------------------
-- Unspectate
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "unspectate" -- The chat command you need to use this plugin
DmodPlugin.Name = "Unspectate" -- The name of the plugin
DmodPlugin.Description = "Unspectate." -- The description shown in the Menu
DmodPlugin.ShowInMenu = true -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Type = "other" -- Where in the Menu will it show?
DmodPlugin.Creator = "Divran" -- Who created it?
DmodPlugin.RequiredRank = "admin" -- The rank required to use this command. Can be "guest", "admin", "super admin", or "owner".
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end


local function Dmod_Plugin( ply, Args )
if (Dmod_CheckRequiredRank(ply, DmodPlugin.RequiredRank)) then
	if (ply.Spec == true) then
		ply:UnSpectate()
		ply:Spawn()
		timer.Simple( .05, function() ply:SetPos( ply.SpecPos ) end )
		ply.Spec = false
		ply.SpecPos = nil
	else
		Dmod_Message( false, ply, "You are not spectating!" )
	end

end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Plugin )