-------------------------------------------------------------------------------------------------------------------------
-- Teleport
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "tp" -- The chat command you need to use this plugin
DmodPlugin.Name = "Teleport" -- The name of the plugin
DmodPlugin.Description = "" -- The description shown in the Menu
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
			local Pos = ply:GetEyeTrace()
			T:SetPos( Pos.HitPos + Vector(0,0,1) )
			T:SetLocalVelocity( Vector( 0,0,0 ) )
			Dmod_Message(true, ply, ply:Nick() .. " teleported " .. T:Nick() .. ".")
		else
			Dmod_Message(false, ply, "No player named '"..Args[2].."' found.")
		end
	else
		local Pos = ply:GetEyeTrace()
		ply:SetPos( Pos.HitPos + Vector(0,0,1) )
		ply:SetLocalVelocity( Vector( 0,0,0 ) )
		Dmod_Message( true, ply, ply:Nick() .. " teleported.")
	end
end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Plugin )