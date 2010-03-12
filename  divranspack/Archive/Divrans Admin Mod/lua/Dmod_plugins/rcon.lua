-------------------------------------------------------------------------------------------------------------------------
-- Dmod Rcon
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "rcon" -- The chat command you need to use this plugin
DmodPlugin.Name = "Rcon" -- The name of the plugin
DmodPlugin.Description = "Run a console command on the server (Remote Console)." -- The description shown in the Menu
DmodPlugin.ShowInMenu = false -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Type = "administration" -- Where in the Menu will it show?
DmodPlugin.Creator = "Divran" -- Who created it?
DmodPlugin.RequiredRank = "Super Admin" -- The rank required to use this command. Can be "Guest", "Respected", "Admin", "Super Admin", or "Owner".
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end


local function Dmod_Plugin( ply, Args )
if (Dmod_CheckRequiredRank(ply, DmodPlugin.RequiredRank)) then
	Command = Dmod_GetReason( Args, 2 )

	if (Args[2] != "") then
		Command = string.TrimRight(Command)
		game.ConsoleCommand( Command .. "\n" )
		Dmod_Message( true, ply, ply:Nick() .. " ran the command '" .. Command .. "' on the server.","normal" )
	else
		Dmod_Message(false, ply, "You must enter a command!","warning" )
	end
end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Plugin )