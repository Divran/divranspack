-- PewPew Autorun
-- Initialize variables
pewpew = {}

local function RequestWeaponsList( ply, cmd, args )
	if (!ply:IsValid()) then return end
	print(ply:Nick() .. " does not have PewPew installed. Sending Weapons List.")
	datastream.StreamToClients( ply, "PewPew_WeaponsList", pewpew.Categories )
end
concommand.Add("PewPew_RequestWeaponsList",RequestWeaponsList)


include("pewpew_damagecontrol.lua")
include("pewpew_safezones.lua")
include("pewpew_convars.lua")
include("pewpew_weaponhandler.lua")
include("pewpew_damagelog.lua")
include("pewpew_deathnotice.lua")

AddCSLuaFile("pewpew_weaponhandler.lua")
AddCSLuaFile("pewpew_damagecontrol.lua")
AddCSLuaFile("autorun/client/pewpew_autorun_client.lua")
AddCSLuaFile("autorun/client/pewpew_menu.lua")



-- Compability
AddCSLuaFile("pewpew_gcombatcompability.lua")
include("pewpew_gcombatcompability.lua")

pewpew:LoadBullets()

-- Tags
local tags = GetConVar( "sv_tags" ):GetString()
if (!string.find( tags, "PewPew" )) then
	RunConsoleCommand( "sv_tags", tags .. ",PewPew" )
end