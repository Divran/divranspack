-------------------------------------------------------------------------------------------------------------------------
-- Ungod
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "ungod" -- The chat command you need to use this plugin
DmodPlugin.Name = "Ungod" -- The name of the plugin
DmodPlugin.Description = "Make someone vurnable." -- The description shown in the Menu
DmodPlugin.ShowInMenu = true -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Type = "other" -- Where in the Menu will it show?
DmodPlugin.Creator = "Divran" -- Who created it?
DmodPlugin.RequiredRank = "Admin" -- The rank required to use this command. Can be "Guest", "Respected", "Admin", "Super Admin", or "Owner".
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end


local function Dmod_Plugin( ply, Args )
if (Dmod_CheckRequiredRank(ply, DmodPlugin.RequiredRank)) then
	if (Args[2]) then
		if (Dmod_FindPlayer(Args[2])) then
			local T = Dmod_FindPlayer(Args[2])
			T:GodDisable()
			T.GodOn = false
			Dmod_Message(true, ply, ply:Nick() .. " disabled godmode for " .. T:Nick() .. ".","normal")
		else
			Dmod_Message(false, ply, "No player named '"..Args[2].."' found.","warning")
		end
	else
		ply:GodDisable()
		ply.GodOn = false
		Dmod_Message( true, ply, ply:Nick() .. " disabled godmode for him/herself.","normal")
	end
end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Plugin )