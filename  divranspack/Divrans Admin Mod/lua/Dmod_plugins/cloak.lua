-------------------------------------------------------------------------------------------------------------------------
-- Cloak
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "cloak" -- The chat command you need to use this plugin
DmodPlugin.Name = "Cloak" -- The name of the plugin
DmodPlugin.Description = "Make someone invisible." -- The description shown in the Menu
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
			if (T.Cloaked == false) then
				Dmod_CloakControl( T, true )
				Dmod_Message(true, ply, ply:Nick() .. " cloaked " .. T:Nick() .. ".","normal")
			else
				Dmod_Message(false, ply, T:Nick() .. " is already cloaked!","warning")
			end
		else
			Dmod_Message(false, ply, "No player named '"..Args[2].."' found.","warning")
		end
	else
		if (ply.Cloaked == false) then
			Dmod_CloakControl( ply, true )
			Dmod_Message(true, ply, ply:Nick() .. " cloaked him/herself.","normal")
		else
			Dmod_Message(false, ply, "You are already cloaked!","warning")
		end
	end
end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Plugin )

-------------------------------------------------------------------------------------------------------------------------
-- Cloak Control
-------------------------------------------------------------------------------------------------------------------------

function Dmod_CloakControl( ply, Bool )
	if (Bool) then
		if (ply.Cloaked == false) then
			ply:SetRenderMode( RENDERMODE_TRANSALPHA )
			local r,g,b,a = ply:GetColor()
			ply:SetColor(r,g,b,0)
			if (ply:GetActiveWeapon():IsValid()) then
				local Wpn = ply:GetActiveWeapon()
				Wpn:SetRenderMode( RENDERMODE_TRANSALPHA )
				local r,g,b,a = Wpn:GetColor()
				Wpn:SetColor(r,g,b,0)
				if (Wpn:GetClass() == "gmod_tool") then Wpn:DrawWorldModel( false ) end
			end
			ply.Cloaked = true
		end
	else
		if (ply.Cloaked == true) then
			ply:SetRenderMode( RENDERMODE_NORMAL )
			local r,g,b,a = ply:GetColor()
			ply:SetColor(r,g,b,255)
			if (ply:GetActiveWeapon():IsValid()) then
				local Wpn = ply:GetActiveWeapon()
				Wpn:SetRenderMode( RENDERMODE_NORMAL )
				local r,g,b,a = Wpn:GetColor()
				Wpn:SetColor(r,g,b,255)
				if (Wpn:GetClass() == "gmod_tool") then Wpn:DrawWorldModel( true ) end
			end
			ply.Cloaked = false
		end
	end
end


local function Dmod_CloakSpawn( )
	for _, ply in pairs(player.GetAll()) do
		if (ply.Cloaked == true) then
			ply:SetRenderMode( RENDERMODE_TRANSALPHA )
			local r,g,b,a = ply:GetColor()
			ply:SetColor(r,g,b,0)
			if (ply:GetActiveWeapon():IsValid()) then
				local Wpn = ply:GetActiveWeapon()
				Wpn:SetRenderMode( RENDERMODE_TRANSALPHA )
				local r,g,b,a = Wpn:GetColor()
				Wpn:SetColor(r,g,b,0)
				if (Wpn:GetClass() == "gmod_tool") then Wpn:DrawWorldModel( false ) end
			end
		end
	end
end
hook.Add( "Think", "Dmod_CloakSpawn", Dmod_CloakSpawn )
