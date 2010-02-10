-- GCombat Autorun
-- Initialize variables
pewpew = {}

AddCSLuaFile("gcombat_damagecontrol.lua")
include("gcombat_damagecontrol.lua")
AddCSLuaFile("gcombat_weaponhandler.lua")
include("gcombat_weaponhandler.lua")

pewpew:LoadBullets()