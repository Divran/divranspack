-------------------------------------------------------------------------------------------------------------------------
-- Admin Noclip
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "adminnoclip" -- The chat command you need to use this plugin
DmodPlugin.Name = "Admin Noclip" -- The name of the plugin
DmodPlugin.Description = "Block non-admins from using noclip." -- The description shown in the Menu
DmodPlugin.ShowInMenu = true -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Type = "administration" -- Where in the Menu will it show?
DmodPlugin.Creator = "Divran" -- Who created it?
DmodPlugin.RequiredRank = "Admin" -- The rank required to use this command. Can be "Guest", "Respected", "Admin", "Super Admin", or "Owner".
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end


local function Dmod_Plugin( ply, Args )
	if (Dmod_CheckRequiredRank(ply, DmodPlugin.RequiredRank)) then
		if AdminNoclip then AdminNoclip = false else AdminNoclip = true end
		if (AdminNoclip) then Dmod_Message( true, ply, ply:Nick() .. " enabled Admin Only Noclip.", "normal" ) end
		if (!AdminNoclip) then Dmod_Message( true, ply, ply:Nick() .. " disabled Admin Only Noclip.", "normal" ) end
	end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Plugin )

-------------------------------------------------------------------------------------------------------------------------
-- Noclip Control
-------------------------------------------------------------------------------------------------------------------------

local function Dmod_DisableNoclip( ply )
	if ((AdminNoclip == true and !Dmod_CheckRequiredRank( ply, "Admin", false )) or ply.Jailed == true) then
		if (ply.Jailed == true) then Dmod_Message( false, ply, "You are caged or jailed!", "warning" ) end
		return false
	end
		return true
end
hook.Add("PlayerNoClip", "", Dmod_DisableNoclip)