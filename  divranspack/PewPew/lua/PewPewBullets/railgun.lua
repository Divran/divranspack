-- Railgun

local BULLET = {}

-- General Information
BULLET.Name = "Railgun"
BULLET.Category = "Cannons"
BULLET.Author = "Divran"
BULLET.Description = "Fires fast moving rounds which are almost not affected by gravity at all."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/combatmodels/tankshell_120mm.mdl"
BULLET.Material = nil
BULLET.Color = Color( 0, 255, 255 )
BULLET.Trail = { StartSize = 40,
				 EndSize = 35,
				 Length = 1,
				 Texture = "trails/laser.vmt",
				 Color = Color( 0, 255, 255, 255 ) }

-- Effects / Sounds
BULLET.FireSound = {"LightDemon/Railgun.wav"}
BULLET.ExplosionSound = nil
BULLET.FireEffect = nil
BULLET.ExplosionEffect = "gcombat_explosion"

-- Movement
BULLET.Speed = 90
BULLET.PitchChange = 0.007
BULLET.RecoilForce = 65
BULLET.Spread = 0.15

-- Damage
BULLET.DamageType = "BlastDamage" -- Look in gcombat_damagecontrol.lua for available damage types
BULLET.Damage = 100
BULLET.Radius = 75
BULLET.RangeDamageMul = 0.9
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.PlayerDamageRadius = 58
BULLET.PlayerDamage = 70

-- Reload/Ammo
BULLET.Reloadtime = 0.4
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

pewpew:AddBullet( BULLET )