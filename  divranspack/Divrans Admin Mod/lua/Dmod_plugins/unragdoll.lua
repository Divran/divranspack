-------------------------------------------------------------------------------------------------------------------------
-- Unragdoll
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "unragdoll" -- The chat command you need to use this plugin
DmodPlugin.Name = "Unragdoll" -- The name of the plugin
DmodPlugin.Description = "Unragdollize someone." -- The description shown in the Menu
DmodPlugin.ShowInMenu = true -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Type = "punishment" -- Where in the Menu will it show?
DmodPlugin.Creator = "Divran" -- Who created it?
DmodPlugin.RequiredRank = "Admin" -- The rank required to use this command. Can be "Guest", "Respected", "Admin", "Super Admin", or "Owner".
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end


local function Dmod_Plugin( ply, Args )
if (Dmod_CheckRequiredRank(ply, DmodPlugin.RequiredRank)) then
	if (Args[2]) then
		if (Dmod_FindPlayer(Args[2])) then
			local T = Dmod_FindPlayer(Args[2])
				if (!T.Ragdolled) then
					Dmod_Message( false, ply, T:Nick() .. " is not ragdolled!","warning" )
				else
					Dmod_RagdollControl( T, false )
					Dmod_Message(true, ply, ply:Nick() .. " unragdollized " .. T:Nick() .. ".","punish")
				end
		else
			Dmod_Message(false, ply, "No player named '"..Args[2].."' found.","warning")
		end
	else
		if (!ply.Ragdolled) then
			Dmod_Message( false, ply, "You are not ragdolled!","warning" )
		else
			Dmod_RagdollControl( ply, false )
			Dmod_Message(true, ply, ply:Nick() .. " unragdollized him/herself.","punish")
		end
	end
end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Plugin )