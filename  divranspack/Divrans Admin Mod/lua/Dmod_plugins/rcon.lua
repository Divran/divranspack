-------------------------------------------------------------------------------------------------------------------------
-- Dmod Rcon
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "rcon" -- The chat command you need to use this plugin
DmodPlugin.Name = "Rcon" -- The name of the plugin
DmodPlugin.Description = "" -- The description shown in the Menu
DmodPlugin.ShowInMenu = false -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Creator = "Divran" -- Who created it?
DmodPlugin.RequiredRank = "super admin" -- The rank required to use this command. Can be "guest", "admin", "super admin", or "owner".
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end


local function Dmod_Rcon( ply, Args )
if (Dmod_CheckRequiredRank(ply, DmodPlugin.RequiredRank)) then
	Command = Dmod_GetReason( Args, 2 )

	if (Command != "") then
		Command = string.TrimRight(Command)
		game.ConsoleCommand( Command .. "\n" )
		Dmod_Message( true, ply, ply:Nick() .. " ran the command '" .. Command .. "' on the server." )
	else
		Dmod_Message(false, ply, "You must enter a command!" )
	end
end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Rcon)