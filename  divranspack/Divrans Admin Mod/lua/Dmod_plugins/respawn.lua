-------------------------------------------------------------------------------------------------------------------------
-- Respawn
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "respawn" -- The chat command you need to use this plugin
DmodPlugin.Name = "Respawn" -- The name of the plugin
DmodPlugin.Description = "Allows you to make someone instantly Respawn" -- The description shown in the Menu
DmodPlugin.ShowInMenu = true -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Creator = "Divran" -- Who created it?
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end


local function Dmod_Respawn( ply, Args )
	if (Args[2]) then
		if (Dmod_FindPlayer(Args[2])) then
			local T = Dmod_FindPlayer(Args[2])
			T:Spawn()
			Dmod_Message(true, ply, ply:Nick() .. " respawned " .. T:Nick() .. ".")
		else
			Dmod_Message(false, ply, "No player named '"..Args[2].."' found.")
		end
	else
		ply:Spawn()
		Dmod_Message( true, ply, ply:Nick() .. " respawned.")
	end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Respawn)