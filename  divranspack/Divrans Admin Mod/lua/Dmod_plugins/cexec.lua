-------------------------------------------------------------------------------------------------------------------------
-- Cexec
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "cexec" -- The chat command you need to use this plugin
DmodPlugin.Name = "Cexec" -- The name of the plugin
DmodPlugin.Description = "Execute a command on a client" -- The description shown in the Menu
DmodPlugin.ShowInMenu = false -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Type = "" -- Where in the Menu will it show?
DmodPlugin.Creator = "Divran" -- Who created it?
DmodPlugin.RequiredRank = "super admin" -- The rank required to use this command. Can be "guest", "admin", "super admin", or "owner".
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end


local function Dmod_Plugin( ply, Args )
if (Dmod_CheckRequiredRank(ply, DmodPlugin.RequiredRank)) then
	if (Args[2]) then
		if (Dmod_FindPlayer(Args[2])) then
			local T = Dmod_FindPlayer(Args[2])
			Command = Dmod_GetReason( Args, 3 )
			if (Command != "") then
				Command = string.TrimRight(Command)
				T:ConCommand( Command )
				Dmod_Message(true, ply, ply:Nick() .. " ran the command '" .. Command .. "' on " .. T:Nick() .. ".")
			else
				Dmod_Message( false, ply, "You must enter a command!" )
			end
		else
			Dmod_Message(false, ply, "No player named '"..Args[2].."' found.")
		end
	else
		Dmod_Message( false, ply, "You must enter a name!")
	end
end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Plugin )