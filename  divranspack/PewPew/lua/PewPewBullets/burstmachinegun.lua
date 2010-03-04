-- Burst Machinegun

local BULLET = {}

-- General Information
BULLET.Name = "Burst Machinegun"
BULLET.Category = "Machineguns"
BULLET.Author = "Divran"
BULLET.Description = "Fires 5 shots in quick succession followed by a brief pause."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/combatmodels/tankshell_25mm.mdl"
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil
					

-- Effects / Sounds
BULLET.FireSound = {"arty/20mm.wav"}
BULLET.ExplosionSound = nil
BULLET.FireEffect = "muzzleflash"
BULLET.ExplosionEffect = "mghit"

-- Movement
BULLET.Speed = 100
BULLET.Gravity = 0.05
BULLET.RecoilForce = 55
BULLET.Spread = 0.1

-- Damage
BULLET.DamageType = "PointDamage"
BULLET.Damage = 75
BULLET.Radius = nil
BULLET.RangeDamageMul = nil
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.PlayerDamage = nil
BULLET.PlayerDamageRadius = nil

-- Reloading/Ammo
BULLET.Reloadtime = 0.08
BULLET.Ammo = 5
BULLET.AmmoReloadtime = 0.8

pewpew:AddBullet( BULLET )