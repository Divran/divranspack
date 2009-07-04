-------------------------------------------------------------------------------------------------------------------------
-- Goto
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "goto" -- The chat command you need to use this plugin
DmodPlugin.Name = "Goto" -- The name of the plugin
DmodPlugin.Description = "Teleport yourself to someone." -- The description shown in the Menu
DmodPlugin.ShowInMenu = true -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Creator = "Divran" -- Who created it?
DmodPlugin.RequiredRank = "admin" -- The rank required to use this command. Can be "guest", "admin", "super admin", or "owner".
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end


local function Dmod_Goto( ply, Args )
if (Dmod_CheckRequiredRank(ply, DmodPlugin.RequiredRank)) then
	if (Args[2]) then
		if (Dmod_FindPlayer(Args[2])) then
			local T = Dmod_FindPlayer(Args[2])
			local Pos = T:GetPos() + T:GetForward() * 100
			ply:SetPos( Pos )
			ply:SetLocalVelocity( Vector( 0,0,0 ) )
			if (ply != T) then ply:SnapEyeAngles( (T:GetPos() - ply:GetPos()):Angle() ) end
			Dmod_Message(true, ply, ply:Nick() .. " went to " .. T:Nick() .. ".")
		else
			Dmod_Message(false, ply, "No player named '"..Args[2].."' found.")
		end
	else
		Dmod_Message( false, ply, "You must enter a name.")
	end
end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Goto)