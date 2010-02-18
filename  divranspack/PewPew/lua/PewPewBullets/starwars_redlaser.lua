-- Red Laser

local BULLET = {}

-- General Information
BULLET.Name = "Red Star Wars Laser"
BULLET.Category = "Lasers"
BULLET.Author = "Divran"
BULLET.Description = "The red Star Wars laser."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/PenisColada/redlaser.mdl"
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"starwars/red.wav"}
BULLET.ExplosionSound = nil
BULLET.FireEffect = nil
BULLET.ExplosionEffect = nil

-- Movement
BULLET.Speed = 85
BULLET.PitchChange = 0.01
BULLET.RecoilForce = 0
BULLET.Spread = 0.05

-- Damage
BULLET.DamageType = "PointDamage"
BULLET.Damage = 280
BULLET.Radius = nil
BULLET.RangeDamageMul = nil
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.PlayerDamage = 125
BULLET.PlayerDamageRadius = 75

-- Reloading/Ammo
BULLET.Reloadtime = 0.35
BULLET.Ammo = 3
BULLET.AmmoReloadtime = 1

pewpew:AddBullet( BULLET )