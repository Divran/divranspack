-- Basic Cannon

local BULLET = {}

-- General Information
BULLET.Name = "Basic Artillery"
BULLET.Category = "Artilleries"
BULLET.Author = "Divran"
BULLET.Description = "Aim away from face."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/combatmodels/tankshell.mdl"
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"arty/cannon.wav"}
BULLET.ExplosionSound = {"weapons/explode1.wav","weapons/explode2.wav"}
BULLET.FireEffect = "artyfire"
BULLET.ExplosionEffect = "big_splosion"

-- Movement
BULLET.Speed = 65
BULLET.PitchChange = 0.2
BULLET.RecoilForce = 500
BULLET.Spread = 0

-- Damage
BULLET.DamageType = "BlastDamage"
BULLET.Damage = 1000
BULLET.Radius = 1000
BULLET.RangeDamageMul = 0.3
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.PlayerDamage = 150
BULLET.PlayerDamageRadius = 300

-- Reloading/Ammo
BULLET.Reloadtime = 7.5
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

pewpew:AddBullet( BULLET )