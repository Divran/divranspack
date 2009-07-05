-------------------------------------------------------------------------------------------------------------------------
-- Ammo
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "ammo" -- The chat command you need to use this plugin
DmodPlugin.Name = "Ammo" -- The name of the plugin
DmodPlugin.Description = "Give loads of ammo to someone." -- The description shown in the Menu
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
				for k, v in pairs(T:GetWeapons()) do
					T:GiveAmmo(1337,v:GetPrimaryAmmoType(),true)
					T:GiveAmmo(1337,v:GetSecondaryAmmoType(),true)
				end
			Dmod_Message(true, ply, ply:Nick() .. " gave loads of ammo to " .. T:Nick() .. ".")
		else
			Dmod_Message(false, ply, "No player named '"..Args[2].."' found.")
		end
	else
		for k, v in pairs(T:GetWeapons()) do
			T:GiveAmmo(1337,v:GetPrimaryAmmoType(),true)
			T:GiveAmmo(1337,v:GetSecondaryAmmoType(),true)
		end
		Dmod_Message( true, ply, ply:Nick() .. " got loads of ammo.")
	end
end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Plugin )