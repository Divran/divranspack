-------------------------------------------------------------------------------------------------------------------------
-- Noclip
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "noclip" -- The chat command you need to use this plugin
DmodPlugin.Name = "Noclip" -- The name of the plugin
DmodPlugin.Description = "Allows you to noclip and unnoclip someone." -- The description shown in the Menu
DmodPlugin.ShowInMenu = true -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Type = "administration" -- Where in the Menu will it show?
DmodPlugin.Creator = "Divran" -- Who created it?
DmodPlugin.RequiredRank = "admin" -- The rank required to use this command. Can be "guest", "admin", "super admin", or "owner".
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end


local function Dmod_Plugin( ply, Args )
if (Dmod_CheckRequiredRank(ply, DmodPlugin.RequiredRank)) then
	if (Args[2]) then
		if (Dmod_FindPlayer(Args[2])) then
			local T = Dmod_FindPlayer(Args[2])
			if (T:GetMoveType() == MOVETYPE_WALK) then
				T:SetMoveType( MOVETYPE_NOCLIP )
				Dmod_Message( true, ply, ply:Nick() .. " noclipped " .. T:Nick() .. ".")
			elseif (T:GetMoveType() == MOVETYPE_NOCLIP) then
				T:SetMoveType( MOVETYPE_WALK )
				Dmod_Message( true, ply, ply:Nick() .. " unnoclipped " .. T:Nick() .. ".")
			else
				Dmod_Message( false, ply, "Unable to use this command on " .. T:Nick() .. ".")
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