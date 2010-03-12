-------------------------------------------------------------------------------------------------------------------------
-- Strip
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "strip" -- The chat command you need to use this plugin
DmodPlugin.Name = "Strip" -- The name of the plugin
DmodPlugin.Description = "Remove someone's weapons." -- The description shown in the Menu
DmodPlugin.ShowInMenu = true -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Type = "punishment" -- Where in the Menu will it show?
DmodPlugin.Creator = "Divran" -- Who created it?
DmodPlugin.RequiredRank = "Admin" -- The rank required to use this command. Can be "Guest", "Respected", "Admin", "Super Admin", or "Owner".
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end


local function Dmod_Plugin( ply, Args )
if (Dmod_CheckRequiredRank(ply, DmodPlugin.RequiredRank)) then
	if (Args[2]) then
		if (Dmod_FindPlayer(Args[2])) then
			local T = Dmod_FindPlayer(Args[2])
			T:StripWeapons()
			Dmod_Message(true, ply, ply:Nick() .. " removed " .. T:Nick() .. "'s weapons.","punish")
		else
			Dmod_Message(false, ply, "No player named '"..Args[2].."' found.","warning")
		end
	else
		ply:StripWeapons()
		Dmod_Message( true, ply, ply:Nick() .. " removed his/her own weapons.","punish")
	end
end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Plugin )