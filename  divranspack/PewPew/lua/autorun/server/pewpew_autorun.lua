-- PewPew Autorun
-- Initialize variables
pewpew = {}

AddCSLuaFile("autorun/client/pewpew_menu.lua")
AddCSLuaFile("pewpew_damagecontrol.lua")
include("pewpew_damagecontrol.lua")
AddCSLuaFile("pewpew_weaponhandler.lua")
include("pewpew_weaponhandler.lua")
include("pewpew_damagelog.lua")
include("pewpew_deathnotice.lua")
AddCSLuaFile("autorun/client/pewpew_autorun_client.lua")


-- Compability
AddCSLuaFile("pewpew_gcombatcompability.lua")
include("pewpew_gcombatcompability.lua")

pewpew:LoadBullets()

-- Tags
local tags = GetConVar( "sv_tags" ):GetString()
if (!string.find( tags, "PewPew" )) then
	RunConsoleCommand( "sv_tags", tags .. ",PewPew" )
end