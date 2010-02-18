-- Laser Machinegun

local BULLET = {}

-- General Information
BULLET.Name = "Laser Machinegun"
BULLET.Category = "Lasers"
BULLET.Author = "Divran"
BULLET.Description = "Fires small laser bolts extremely fast."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/PenisColada/redlaser_small.mdl"
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"Lasers/SPulse/PulseLaser.wav"}
BULLET.ExplosionSound = nil
BULLET.FireEffect = nil
BULLET.ExplosionEffect = nil

-- Movement
BULLET.Speed = 90
BULLET.PitchChange = 0.01
BULLET.RecoilForce = 10
BULLET.Spread = 0.4

-- Damage
BULLET.DamageType = "PointDamage"
BULLET.Damage = 25
BULLET.Radius = nil
BULLET.RangeDamageMul = nil
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.PlayerDamage = 45
BULLET.PlayerDamageRadius = 40

-- Reloading/Ammo
BULLET.Reloadtime = 0.07
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

pewpew:AddBullet( BULLET )