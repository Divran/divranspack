-- Basic Cannon

local BULLET = {}

-- General Information
BULLET.Name = "Basic Cannon"

-- Appearance
BULLET.Model = "models/combatmodels/tankshell.mdl"

-- Effects / Sounds
BULLET.FireSound = "arty/37mm.wav"
BULLET.ExplosionSound = "weapons/explode3.wav"
BULLET.FireEffect = "cannon_flare"
BULLET.ExplosionEffect = "gcombat_explosion"

-- Movement
BULLET.Speed = 50
BULLET.PitchChange = 0.2
BULLET.RecoilForce = 200
BULLET.Spread = 0

-- Damage
BULLET.DamageType = "BlastDamage" -- Look in gcombat_damagecontrol.lua for available damage types
BULLET.Damage = 150
BULLET.Radius = 100
BULLET.RangeDamageMul = 0.8
BULLET.PlayerDamageRadius = 200
BULLET.PlayerDamage = 150

-- Other
BULLET.Reloadtime = 2.3

-- Custom Functions 
-- (If you set the override var to true, the cannon/bullet will run these instead. Use these functions to do stuff which is not possible with the above variables)

-- Fire (Is called before the cannon is about to fire)
BULLET.FireOverride = false
function BULLET:Fire( self )
	-- Nothing
end

-- Initialize (Is called when the entity initializes)
BULLET.InitOverride = false
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