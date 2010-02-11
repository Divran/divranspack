-- GCombat Autorun
-- Initialize variables
pewpew = {}

AddCSLuaFile("pewpew_damagecontrol.lua")
include("pewpew_damagecontrol.lua")
AddCSLuaFile("pewpew_weaponhandler.lua")
include("pewpew_weaponhandler.lua")

pewpew:LoadBullets()