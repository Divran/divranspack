-------------------------------------------------------------------------------------------------------------------------
-- Bring
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "bring" -- The chat command you need to use this plugin
DmodPlugin.Name = "Bring" -- The name of the plugin
DmodPlugin.Description = "Teleport someone to you." -- The description shown in the Menu
DmodPlugin.ShowInMenu = true -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Type = "other" -- Where in the Menu will it show?
DmodPlugin.Creator = "Divran" -- Who created it?
DmodPlugin.RequiredRank = "admin" -- The rank required to use this command. Can be "guest", "admin", "super admin", or "owner".
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end


local function Dmod_Plugin( ply, Args )
if (Dmod_CheckRequiredRank(ply, DmodPlugin.RequiredRank)) then
	if (Args[2]) then
		if (Dmod_FindPlayer(Args[2])) then
			local T = Dmod_FindPlayer(Args[2])
			T:SetPos( ply:GetPos() + ply:GetForward() * 100 )
			T:SetLocalVelocity( Vector( 0,0,0 ) )
			if (ply != T) then T:SnapEyeAngles( (ply:GetPos() - T:GetPos()):Angle() ) end
			Dmod_Message(true, ply, ply:Nick() .. " brought " .. T:Nick() .. ".","normal")
		else
			Dmod_Message(false, ply, "No player named '"..Args[2].."' found.","warning")
		end
	else
		Dmod_Message( false, ply, "You must enter a name!","warning")
	end
end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Plugin )