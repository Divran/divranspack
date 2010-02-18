-- PewPew Autorun
-- Initialize variables
pewpew = {}

AddCSLuaFile("autorun/client/pewpew_menu.lua")
AddCSLuaFile("autorun/client/pewpew_autorun_client.lua")
AddCSLuaFile("pewpew_damagecontrol.lua")
include("pewpew_damagecontrol.lua")
AddCSLuaFile("pewpew_weaponhandler.lua")
include("pewpew_weaponhandler.lua")

pewpew:LoadBullets()