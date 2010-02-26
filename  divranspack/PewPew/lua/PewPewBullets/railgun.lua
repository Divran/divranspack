-- Railgun

local BULLET = {}

-- General Information
BULLET.Name = "Railgun"
BULLET.Category = "Cannons"
BULLET.Author = "Divran"
BULLET.Description = "Fires fast moving rounds with deadly accuracy. Slices through armor like a hot knife through butter."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/combatmodels/tankshell_120mm.mdl"
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = { StartSize = 10,
				 EndSize = 2,
				 Length = 0.4,
				 Texture = "trails/smoke.vmt",
				 Color = Color( 255, 255, 255, 255 ) }

-- Effects / Sounds
BULLET.FireSound = {"arty/railgun.wav"}
BULLET.ExplosionSound = nil
BULLET.FireEffect = nil
BULLET.ExplosionEffect = "HEATsplode"

-- Movement
BULLET.Speed = 200
BULLET.Gravity = 0.02
BULLET.RecoilForce = 0
BULLET.Spread = 0

-- Damage
BULLET.DamageType = "SliceDamage"
BULLET.Damage = 550
BULLET.Radius = nil
BULLET.RangeDamageMul = nil
BULLET.NumberOfSlices = 5
BULLET.SliceDistance = 500
BULLET.PlayerDamageRadius = nil
BULLET.PlayerDamage = nil

-- Reload/Ammo
BULLET.Reloadtime = 3
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

pewpew:AddBullet( BULLET )