-- Basic Missile

local BULLET = {}

-- General Information
BULLET.Name = "Basic Rocket Launcher"
BULLET.Category = "Rockets"
BULLET.Author = "Divran"
BULLET.Description = "Rocket launcher with 6 rockets."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/aamissile.mdl"
BULLET.Material = "phoenix_storms/gear"
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
BULLET.Spread = 1.5

-- Damage
BULLET.DamageType = "BlastDamage" -- Look in gcombat_damagecontrol.lua for available damage types
BULLET.Damage = 180
BULLET.Radius = 300
BULLET.RangeDamageMul = 0.5
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.PlayerDamage = 150
BULLET.PlayerDamageRadius = 400

-- Reloading/Ammo
BULLET.Reloadtime = 0.3
BULLET.Ammo = 6
BULLET.AmmoReloadtime = 8

-- Custom Functions 
-- (If you set the override var to true, the cannon/bullet will run these instead. Use these functions to do stuff which is not possible with the above variables)

-- Initialize (Is called when the bullet initializes)
BULLET.InitializeOverride = true
function BULLET:InitializeFunc( self )   
	self.Entity:PhysicsInit( SOLID_VPHYSICS ) 	
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )     
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

pewpew:AddBullet( BULLET )