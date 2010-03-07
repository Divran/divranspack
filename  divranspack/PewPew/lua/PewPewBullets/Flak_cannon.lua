-- Basic Cannon

local BULLET = {}

-- General Information
BULLET.Name = "Flak Cannon"
BULLET.Category = "Cannons"
BULLET.Author = "Divran"
BULLET.Description = "Shoots bullets which explode in midair, making it easier to shoot down airplanes."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/combatmodels/tankshell.mdl"
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"arty/40mm.wav"}
BULLET.ExplosionSound = {"weapons/pipe_bomb1.wav","weapons/pipe_bomb2.wav","weapons/pipe_bomb3.wav"}
BULLET.FireEffect = "cannon_flare"
BULLET.ExplosionEffect = "pewpew_smokepuff"

-- Movement
BULLET.Speed = 135
BULLET.Gravity = 0.06
BULLET.RecoilForce = 400
BULLET.Spread = 2

-- Damage
BULLET.DamageType = "BlastDamage"
BULLET.Damage = 300
BULLET.Radius = 850
BULLET.RangeDamageMul = 0.5
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.PlayerDamage = 500
BULLET.PlayerDamageRadius = 1000

-- Reloading/Ammo
BULLET.Reloadtime = 2
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

-- Other
BULLET.Lifetime = {0.7,1.2}
BULLET.ExplodeAfterDeath = true
BULLET.EnergyPerShot = 2000

pewpew:AddBullet( BULLET )