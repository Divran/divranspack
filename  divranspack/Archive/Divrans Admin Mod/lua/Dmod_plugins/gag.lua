-------------------------------------------------------------------------------------------------------------------------
-- Gag
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "gag" -- The chat command you need to use this plugin
DmodPlugin.Name = "Gag" -- The name of the plugin
DmodPlugin.Description = "Gag someone, making them unable to write in the chat." -- The description shown in the Menu
DmodPlugin.ShowInMenu = true -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Type = "administration" -- Where in the Menu will it show?
DmodPlugin.Creator = "Divran" -- Who created it?
DmodPlugin.RequiredRank = "Admin" -- The rank required to use this command. Can be "Guest", "Respected", "Admin", "Super Admin", or "Owner".
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end


local function Dmod_Plugin( ply, Args )
if (Dmod_CheckRequiredRank(ply, DmodPlugin.RequiredRank)) then
	if (Args[2]) then
		if (Dmod_FindPlayer(Args[2])) then
			local T = Dmod_FindPlayer(Args[2])
			T.Gagged = true
			Dmod_Message(true, ply, ply:Nick() .. " gagged " .. T:Nick() .. ".","punish")
		else
			Dmod_Message(false, ply, "No player named '"..Args[2].."' found.","warning")
		end
	else
		Dmod_Message( false, ply, "You must enter a name!","warning")
	end
end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Plugin )

-------------------------------------------------------------------------------------------------------------------------
-- Gag Control
-------------------------------------------------------------------------------------------------------------------------

local function Dmod_ControlGag( ply )
	if (ply.Gagged) then
		Dmod_Message( false, ply, "You are gagged!", "warning" )
		return ""
	end
end
hook.Add("PlayerSay", "ControlGag", Dmod_ControlGag )