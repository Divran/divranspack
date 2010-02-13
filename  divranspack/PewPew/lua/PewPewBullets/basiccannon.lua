-- Basic Cannon

local BULLET = {}

-- General Information
BULLET.Name = "Basic Cannon"
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
BULLET.FireSound = {"arty/37mm.wav"}
BULLET.ExplosionSound = {"weapons/explode1.wav","weapons/explode2.wav"}
BULLET.FireEffect = "cannon_flare"
BULLET.ExplosionEffect = "big_splosion"

-- Movement
BULLET.Speed = 50
BULLET.PitchChange = 0.2
BULLET.RecoilForce = 500
BULLET.Spread = 0

-- Damage
BULLET.DamageType = "BlastDamage" -- Look in gcombat_damagecontrol.lua for available damage types
BULLET.Damage = 250
BULLET.Radius = 800
BULLET.RangeDamageMul = 0.3
BULLET.NumberOfSlices = nil
BULLET.PlayerDamage = 150
BULLET.PlayerDamageRadius = 300

-- Reloading/Ammo
BULLET.Reloadtime = 3.5
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

-- This is called when the bullet collides (Advanced users only. It only works if you first override initialize and change it to vphysics)
BULLET.PhysicsCollideOverride = false
function BULLET:PhysicsCollideFunc(CollisionData, PhysObj)
	-- Nothing
end

-- Client side overrides:

BULLET.CLInitializeOverride = false
function BULLET:CLInitializeFunc()
	-- Nothing
end

BULLET.CLThinkOverride = false
function BULLET:CLThinkFunc()
	-- Nothing
end

BULLET.CLDrawOverride = false
function BULLET:CLDrawFunc()
	-- Nothing
end

pewpew:AddBullet( BULLET )