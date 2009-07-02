-------------------------------------------------------------------------------------------------------------------------
-- God
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "god" -- The chat command you need to use this plugin
DmodPlugin.Name = "God" -- The name of the plugin
DmodPlugin.Description = "Allows you to make someone invurnable." -- The description shown in the Menu
DmodPlugin.ShowInMenu = true -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Creator = "Divran" -- Who created it?
if SERVER then Dmod_AddPlugin(DmodPlugin) end

local function Dmod_God( ply, Args )
	if (Args[2]) then
		if (Dmod_FindPlayer(Args[2])) then
			local T = Dmod_FindPlayer(Args[2])
			T:GodEnable()
			Dmod_Message(true, ply, ply:Nick() .. " enabled godmode for " .. T:Nick() .. ".")
		else
			Dmod_Message(false, ply, "No player named '"..Args[2].."' found.")
		end
	else
		ply:GodEnable()
		Dmod_Message( true, ply, ply:Nick() .. " enabled godmode for him/herself.")
	end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_God)