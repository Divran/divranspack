-- Basic Missile

local BULLET = {}

-- General Information
BULLET.Name = "Basic Missile"
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/aamissile.mdl"
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"arty/rocket.wav"}
BULLET.ExplosionSound = {"weapons/explode3.wav","weapons/explode4.wav","weapons/explode5.wav"}
BULLET.FireEffect = nil
BULLET.ExplosionEffect = "v2splode"

-- Movement
BULLET.Speed = 30
BULLET.PitchChange = 0
BULLET.RecoilForce = 0
BULLET.Spread = 1

-- Damage
BULLET.DamageType = "BlastDamage" -- Look in gcombat_damagecontrol.lua for available damage types
BULLET.Damage = 200
BULLET.Radius = 400
BULLET.RangeDamageMul = 0.5
BULLET.PlayerDamage = 150
BULLET.PlayerDamageRadius = 400

-- Other
BULLET.Reloadtime = 0.3
BULLET.NumberOfSlices = nil
BULLET.Ammo = 6
BULLET.AmmoReloadtime = 6

-- Custom Functions 
-- (If you set the override var to true, the cannon/bullet will run these instead. Use these functions to do stuff which is not possible with the above variables)

-- Fire (Is called before the cannon is about to fire)
BULLET.FireOverride = false
function BULLET:Fire( self )
	-- Nothing
end

-- Initialize (Is called when the bullet initializes)
BULLET.InitializeOverride = true
function BULLET:InitializeFunc( self )   
	self.flightvector = self.Entity:GetUp()
	self.Entity:PhysicsInit( SOLID_VPHYSICS ) 	
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_VPHYSICS )    
	self.FlightDirection = self.Entity:GetUp()
	self.Exploded = false
	
	-- Trail
	if (self.Bullet.Trail) then
		local trail = self.Bullet.Trail
		util.SpriteTrail( self.Entity, 0, trail.Color, false, trail.StartSize, trail.EndSize, trail.Length, 1/(trail.StartSize+trail.EndSize)*0.5, trail.Texture )
	end
	
	-- Material
	if (self.Bullet.Material) then
		self.Entity:SetMaterial( self.Bullet.Material )
	end
	
	-- Color
	if (self.Bullet.Color) then
		local C = self.Bullet.Color
		self.Entity:SetColor( C.r, C.g, C.b, 255 )
	end
	
	local trail = ents.Create("env_fire_trail")
	trail:SetPos( self.Entity:GetPos() - self.Entity:GetUp() * 20 )
	trail:Spawn()
	trail:SetParent( self.Entity )
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