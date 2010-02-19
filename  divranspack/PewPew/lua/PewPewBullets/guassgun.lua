-- Railgun

local BULLET = {}

-- General Information
BULLET.Name = "Guass Gun"
BULLET.Category = "Cannons"
BULLET.Author = "Divran"
BULLET.Description = "An electro-magnetic powered cannon."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/combatmodels/tankshell_40mm.mdl"
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"arty/25mm.wav"}
BULLET.ExplosionSound = nil
BULLET.FireEffect = nil
BULLET.ExplosionEffect = "gcombat_explosion"

-- Movement
BULLET.Speed = 150
BULLET.PitchChange = 0.007
BULLET.RecoilForce = 0
BULLET.Spread = 0.05

-- Damage
BULLET.DamageType = "BlastDamage" -- Look in gcombat_damagecontrol.lua for available damage types
BULLET.Damage = 60
BULLET.Radius = 75
BULLET.RangeDamageMul = 0.9
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.PlayerDamageRadius = 58
BULLET.PlayerDamage = 70

-- Reload/Ammo
BULLET.Reloadtime = 0.2
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

pewpew:AddBullet( BULLET )