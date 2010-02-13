-- Basic Machinegun

local BULLET = {}

-- General Information
BULLET.Name = "Basic Machinegun"
BULLET.Author = "Divran"
BULLET.Description = "Rapid fire machinegun with a large magazine."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/combatmodels/tankshell_25mm.mdl"
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil
					

-- Effects / Sounds
BULLET.FireSound = {"arty/20mmauto.wav"}
BULLET.ExplosionSound = nil
BULLET.FireEffect = "muzzleflash"
BULLET.ExplosionEffect = "mghit"

-- Movement
BULLET.Speed = 70
BULLET.PitchChange = 0.2
BULLET.RecoilForce = 30
BULLET.Spread = 0.3

-- Damage
BULLET.DamageType = "PointDamage" -- Look in gcombat_damagecontrol.lua for available damage types
BULLET.Damage = 25
BULLET.Radius = nil
BULLET.RangeDamageMul = nil
BULLET.NumberOfSlices = nil
BULLET.PlayerDamage = 10
BULLET.PlayerDamageRadius = 60

-- Reloading/Ammo
BULLET.Reloadtime = 0.1
BULLET.Ammo = 100
BULLET.AmmoReloadtime = 10

-- Custom Functions 
-- (If you set the override var to true, the cannon will run these instead. Use these functions to do stuff which is not possible with the above variables)

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