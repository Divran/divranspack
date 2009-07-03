-------------------------------------------------------------------------------------------------------------------------
-- Bring
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "bring" -- The chat command you need to use this plugin
DmodPlugin.Name = "Bring" -- The name of the plugin
DmodPlugin.Description = "Allows you to teleport someone to you." -- The description shown in the Menu
DmodPlugin.ShowInMenu = true -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Creator = "Divran" -- Who created it?
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end


local function Dmod_Bring( ply, Args )
	if (Args[2]) then
		if (Dmod_FindPlayer(Args[2])) then
			local T = Dmod_FindPlayer(Args[2])
			T:SetPos( ply:GetPos() + ply:GetForward() * 100 )
			T:SetLocalVelocity( Vector( 0,0,0 ) )
			if (ply != T) then T:SnapEyeAngles( (ply:GetPos() - T:GetPos()):Angle() ) end
			Dmod_Message(true, ply, ply:Nick() .. " brought " .. T:Nick() .. ".")
		else
			Dmod_Message(false, ply, "No player named '"..Args[2].."' found.")
		end
	else
		Dmod_Message( false, ply, "You must enter a name!")
	end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Bring)