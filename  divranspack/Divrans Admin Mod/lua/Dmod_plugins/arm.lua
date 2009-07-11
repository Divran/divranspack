-------------------------------------------------------------------------------------------------------------------------
-- Arm
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "arm" -- The chat command you need to use this plugin
DmodPlugin.Name = "Arm" -- The name of the plugin
DmodPlugin.Description = "Give someone new weapons." -- The description shown in the Menu
DmodPlugin.ShowInMenu = true -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Type = "other" -- Where in the Menu will it show?
DmodPlugin.Creator = "Divran" -- Who created it?
DmodPlugin.RequiredRank = "Respected" -- The rank required to use this command. Can be "Guest", "Respected", "Admin", "Super Admin", or "Owner".
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end


local function Dmod_Plugin( ply, Args )
if (Dmod_CheckRequiredRank(ply, DmodPlugin.RequiredRank)) then
	if (Args[2]) then
		if (Dmod_FindPlayer(Args[2])) then
			local T = Dmod_FindPlayer(Args[2])
			Dmod_GiveWpns( T )
			Dmod_Message(true, ply, ply:Nick() .. " gave " .. T:Nick() .. " new weapons.","normal")
		else
			Dmod_Message(false, ply, "No player named '"..Args[2].."' found.","warning")
		end
	else
		Dmod_GiveWpns( ply )
		Dmod_Message( true, ply, ply:Nick() .. " gave him/herself new weapons.","warning")
	end
end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Plugin )

-------------------------------------------------------------------------------------------------------------------------
-- A table of weapons & the Arm function
-------------------------------------------------------------------------------------------------------------------------

local Wpns = {}
function AddWeapons()
	for k, v in pairs(ents.GetAll()) do
		if v:IsWeapon() and !table.HasValue( Wpns, v:GetClass() ) then
			table.insert( Wpns, v:GetClass() )
		end
	end
end
if SERVER then hook.Add("Think", "AddWeapons", AddWeapons) end

function Dmod_GiveWpns( ply )
	for _, v in pairs(Wpns) do
		ply:Give( v )
	end
	ply:SelectWeapon("weapon_physgun")
end
