-- Basic Cannon

local BULLET = {}

-- General Information
BULLET.Name = "Bomb Rack"
BULLET.Author = "Divran"
BULLET.Description = "Drops several bombs straight down onto your enemy."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/props_c17/canister_propane01a.mdl"
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"npc/attack_helicopter/aheli_mine_drop1.wav"}
BULLET.ExplosionSound = {"weapons/explode3.wav","weapons/explode4.wav","weapons/explode5.wav"}
BULLET.FireEffect = nil
BULLET.ExplosionEffect = "athesplode"

-- Movement
BULLET.Speed = 5
BULLET.PitchChange = 0.5
BULLET.RecoilForce = 0
BULLET.Spread = 0

-- Damage
BULLET.DamageType = "BlastDamage" -- Look in gcombat_damagecontrol.lua for available damage types
BULLET.Damage = 650
BULLET.Radius = 500
BULLET.RangeDamageMul = 0.6
BULLET.NumberOfSlices = nil
BULLET.PlayerDamage = 600
BULLET.PlayerDamageRadius = 600

-- Reloading/Ammo
BULLET.Reloadtime = 0.5
BULLET.Ammo = 5
BULLET.AmmoReloadtime = 8

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