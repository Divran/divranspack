-------------------------------------------------------------------------------------------------------------------------
-- Jail
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "jail" -- The chat command you need to use this plugin
DmodPlugin.Name = "Jail" -- The name of the plugin
DmodPlugin.Description = "Jail someone (without a cage)." -- The description shown in the Menu
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
			if (T.Jailed == false) then
				local Pos1 = ply:GetEyeTrace()
				local Pos2 = Pos1.HitPos + Vector(0,0,10)
				Dmod_ControlJail( T, true, Pos2, false )
				Dmod_Message(true, ply, ply:Nick() .. " jailed " .. T:Nick() .. ".","punish")
			else
				Dmod_Message(false, ply, T:Nick() .. " is already caged or jailed!","warning")
			end
		else
			Dmod_Message(false, ply, "No player named '"..Args[2].."' found.","warning")
		end
	else
		Dmod_Message( false, ply, "You must enter a name!","warning")
	end
end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Plugin )

-------------------------------------------------------------------------------------------------------------------------
-- Jail Control
-------------------------------------------------------------------------------------------------------------------------

local function Dmod_BlockStuff( ply )
	if (ply.Jailed == true) then 
		Dmod_Message( false, ply, "You are caged or jailed!","warning" )
		return false 
	end
end
hook.Add( "PlayerSpawnProp", "", Dmod_BlockStuff )
hook.Add( "PlayerSpawnSENT", "", Dmod_BlockStuff )
hook.Add( "PlayerSpawnNPC", "", Dmod_BlockStuff )
hook.Add( "PlayerSpawnSWEP", "", Dmod_BlockStuff )
hook.Add( "PlayerSpawnVehicle", "", Dmod_BlockStuff )
hook.Add( "CanTool", "", Dmod_BlockStuff )

local function Dmod_BlockWeapons( ply )
	timer.Simple( 0.05, function() if (ply.JailOn == true) then ply:StripWeapons() end end )
end
hook.Add( "PlayerCanPickupWeapon", "", Dmod_BlockWeapons )


