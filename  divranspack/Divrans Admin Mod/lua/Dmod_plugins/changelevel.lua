-------------------------------------------------------------------------------------------------------------------------
-- Changelevel
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "changelevel" -- The chat command you need to use this plugin
DmodPlugin.Name = "Changelevel" -- The name of the plugin
DmodPlugin.Description = "" -- The description shown in the Menu
DmodPlugin.ShowInMenu = false -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Creator = "Divran" -- Who created it?
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end


local function Dmod_Changelevel( ply, Args )
	if (Args[2]) then
		if (Args[3]) then
			game.ConsoleCommand( "changegamemode " .. Args[2] .. " " .. Args[3] .. "\n" )
		else
			game.ConsoleCommand( "changelevel " .. Args[2] .. "\n" )
		end
	else
		Dmod_Message(false, ply, "You must enter a map name!" )
	end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Changelevel)