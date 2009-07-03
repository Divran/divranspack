-------------------------------------------------------------------------------------------------------------------------
-- Sbox Max
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "sbox" -- The chat command you need to use this plugin
DmodPlugin.Name = "Sbox limits" -- The name of the plugin
DmodPlugin.Description = "" -- The description shown in the Menu
DmodPlugin.ShowInMenu = false -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Creator = "Divran" -- Who created it?
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end


local function Dmod_ChangeSbox( ply, Args )
	if (Args[2]) then
		if (Args[3]) then
			game.ConsoleCommand( "sbox_max" .. Args[2] .. " " .. Args[3] .. "\n" )
			Dmod_Message( true, ply, ply:Nick() .. " changed sbox_max" .. Args[2] )
		else
			Dmod_Message( false, ply, "You must enter a number!" )
		end
	else
		Dmod_Message(false, ply, "You must enter a map name!" )
	end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_ChangeSbox)