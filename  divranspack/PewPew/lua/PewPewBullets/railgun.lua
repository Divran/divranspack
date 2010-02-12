-- Railgun

local BULLET = {}

-- General Information
BULLET.Name = "Railgun"
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
BULLET.Damage = 80
BULLET.Radius = 75
BULLET.RangeDamageMul = 0.5
BULLET.PlayerDamageRadius = 58
BULLET.PlayerDamage = 70

-- Other
BULLET.Reloadtime = 0.6
BULLET.NumberOfSlices = nil
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

-- Custom Functions 
-- (If you set the override var to true, the cannon/bullet will run these instead. Use these functions to do stuff which is not possible with the above variables)

-- Fire (Is called before the cannon is about to fire)
BULLET.FireOverride = false
function BULLET:Fire( self )
	-- Nothing
end

-- Initialize (Is called when the bullet initializes)
BULLET.InitializeOverride = false
function BULLET:InitializeFunc( self )   
	-- Nothing
end

-- Think (Is called a lot of times :p)
BULLET.ThinkOverride = false
function BULLET:ThinkFunc( self )
	-- Nothing
end

-- Explode (Is called when the bullet explodes) Note: this will not run if you override the think function (unless you call it from there as well)
BULLET.ExplodeOverride = false
function BULLET:Explode( self, trace )
	-- Nothing
end


pewpew:AddBullet( BULLET )