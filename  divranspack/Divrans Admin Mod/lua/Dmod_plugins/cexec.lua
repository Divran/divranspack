-------------------------------------------------------------------------------------------------------------------------
-- Cexec
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "cexec" -- The chat command you need to use this plugin
DmodPlugin.Name = "Cexec" -- The name of the plugin
DmodPlugin.Description = "Execute a command on a client" -- The description shown in the Menu
DmodPlugin.ShowInMenu = false -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Type = "administration" -- Where in the Menu will it show?
DmodPlugin.Creator = "Divran" -- Who created it?
DmodPlugin.RequiredRank = "Super Admin" -- The rank required to use this command. Can be "Guest", "Respected", "Admin", "Super Admin", or "Owner".
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end


local function Dmod_Plugin( ply, Args )
if (Dmod_CheckRequiredRank(ply, DmodPlugin.RequiredRank)) then
	if (Args[2]) then
		if (Dmod_FindPlayer(Args[2])) then
			local T = Dmod_FindPlayer(Args[2])
			Command = Dmod_GetReason( Args, 3 )
			if (Args[3] != "") then
				Command = string.TrimRight(Command)
				T:ConCommand( Command )
				Dmod_Message(true, ply, ply:Nick() .. " ran the command '" .. Command .. "' on " .. T:Nick() .. ".", "punish")
			else
				Dmod_Message( false, ply, "You must enter a command!","warning" )
			end
		else
			Dmod_Message(false, ply, "No player named '"..Args[2].."' found.","warning")
		end
	else
		Dmod_Message( false, ply, "You must enter a name!","warning")
	end
end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Plugin )