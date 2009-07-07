-------------------------------------------------------------------------------------------------------------------------
-- Uncage
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "uncage" -- The chat command you need to use this plugin
DmodPlugin.Name = "Uncage" -- The name of the plugin
DmodPlugin.Description = "Uncage someone." -- The description shown in the Menu
DmodPlugin.ShowInMenu = true -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Type = "punishment" -- Where in the Menu will it show?
DmodPlugin.Creator = "Divran" -- Who created it?
DmodPlugin.RequiredRank = "admin" -- The rank required to use this command. Can be "guest", "admin", "super admin", or "owner".
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end


local function Dmod_Plugin( ply, Args )
if (Dmod_CheckRequiredRank(ply, DmodPlugin.RequiredRank)) then
	if (Args[2]) then
		if (Dmod_FindPlayer(Args[2])) then
			local T = Dmod_FindPlayer(Args[2])
			if (T.Jailed == true) then
				Dmod_ControlJail( T, false, nil, true )
				Dmod_Message(true, ply, ply:Nick() .. " uncaged " .. T:Nick() .. ".","punish" )
			else
				Dmod_Message(false, ply, T:Nick() .. " is not caged or jailed!","warning")
			end
		else
			Dmod_Message(false, ply, "No player named '".. Args[2].."' found.","warning")
		end
	else
		Dmod_Message(false, ply, "You must enter a name!","warning" )
	end
end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Plugin )