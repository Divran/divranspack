-------------------------------------------------------------------------------------------------------------------------
-- Spectate
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "spectate" -- The chat command you need to use this plugin
DmodPlugin.Name = "Spectate" -- The name of the plugin
DmodPlugin.Description = "Spectate someone." -- The description shown in the Menu
DmodPlugin.ShowInMenu = false -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Type = "" -- Where in the Menu will it show?
DmodPlugin.Creator = "Divran" -- Who created it?
DmodPlugin.RequiredRank = "admin" -- The rank required to use this command. Can be "guest", "admin", "super admin", or "owner".
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end


local function Dmod_Plugin( ply, Args )
if (Dmod_CheckRequiredRank(ply, DmodPlugin.RequiredRank)) then
	if (Args[2]) then
		if (Dmod_FindPlayer(Args[2])) then
			local T = Dmod_FindPlayer(Args[2])
			if (Args[3] == "chase") then
				ply.SpecPos = ply:GetPos() + Vector(0,0,10)
				ply.Spec = true
				ply:Spectate( OBS_MODE_CHASE )
				ply:SpectateEntity( T )
				ply:StripWeapons()
				Dmod_Message( false, ply, "You are now spectating " .. T:Nick() .. " in chase mode." )
			elseif (Args[3] == "firstperson") then
				ply.SpecPos = ply:GetPos() + Vector(0,0,10)
				ply.Spec = true
				ply:Spectate( OBS_MODE_IN_EYE )
				ply:SpectateEntity( T )
				ply:StripWeapons()
				Dmod_Message( false, ply, "You are now spectating " .. T:Nick() .. " in first person mode." )
			else
				Dmod_Message( false, ply, "Invalid mode. Modes are: 'chase' and 'firstperson'.")
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