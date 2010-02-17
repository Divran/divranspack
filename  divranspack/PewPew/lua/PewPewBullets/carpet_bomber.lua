-- Bomb Rack

local BULLET = {}

-- General Information
BULLET.Name = "Carpet Bomber"
BULLET.Category = "Explosives"
BULLET.Author = "Divran"
BULLET.Description = "Drops dozens of small bombs."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/props_phx/ww2bomb.mdl"
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"npc/attack_helicopter/aheli_mine_drop1.wav"}
BULLET.ExplosionSound = {"weapons/explode3.wav","weapons/explode4.wav","weapons/explode5.wav"}
BULLET.FireEffect = nil
BULLET.ExplosionEffect = "gcombat_explosion"

-- Movement
BULLET.Speed = nil
BULLET.PitchChange = nil
BULLET.RecoilForce = nil
BULLET.Spread = nil

-- Damage
BULLET.DamageType = "BlastDamage"
BULLET.Damage = 200
BULLET.Radius = 200
BULLET.RangeDamageMul = 0.6
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.PlayerDamage = 600
BULLET.PlayerDamageRadius = 600

-- Reloading/Ammo
BULLET.Reloadtime = 0.2
BULLET.Ammo = 25
BULLET.AmmoReloadtime = 15

-- Custom Functions 
-- (If you set the override var to true, the cannon/bullet will run these instead. Use these functions to do stuff which is not possible with the above variables)

-- Wire Input
BULLET.WireInputOverride = false
function BULLET:WireInput( inputname, value )
	-- Nothing
end

-- Fire (Is called before the cannon is about to fire)
BULLET.FireOverride = false
function BULLET:Fire( self )
	-- Nothing
end

-- Initialize (Is called when the entity initializes)
BULLET.InitializeOverride = true
function BULLET:InitializeFunc(self)
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	
	
	constraint.NoCollide(self.Entity, self.Cannon.Entity, 0, 0)
	
	local V = VectorRand() * 50
	V.z = 0
	
	self.Entity:SetPos( self.Entity:GetPos() + self.Entity:GetUp() * 60 + V )
	self.Entity:NextThink(CurTime())
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:SetVelocity(self.Cannon:GetVelocity()+self.Cannon:GetUp()*50+V*3)
	end
	
	self.Timer = CurTime() + 50
	self.Collided = false
end

-- Think (Is called a lot of times :p)
BULLET.ThinkOverride = true
function BULLET:ThinkFunc( self )
	local vel = self:GetVelocity() -- For some reason setting the angle every tick makes it move REALLY slowly, so I used this hacky method of angling it
	self:SetAngles( vel:Angle() )
	self.Entity:GetPhysicsObject():SetVelocity( vel )
	if (self.Collided == true or CurTime() > self.Timer) then
		if (pewpew.PewPewDamage) then
			util.BlastDamage(self.Entity, self.Entity, self.Entity:GetPos(), self.Bullet.Damage, self.Bullet.Radius)
		end
		pewpew:BlastDamage(self:GetPos(), self.Bullet.Radius, self.Bullet.Damage, self.Bullet.RangeDamageMul)
		
		if (self.Bullet.ExplosionEffect) then
			local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos())
			effectdata:SetStart(self:GetPos())
			effectdata:SetNormal(self.Entity:GetUp())
			util.Effect(self.Bullet.ExplosionEffect, effectdata)
		end
		
		-- Sounds
		if (self.Bullet.ExplosionSound) then
			local soundpath = ""
			if (table.Count(self.Bullet.ExplosionSound) > 1) then
				soundpath = table.Random(self.Bullet.ExplosionSound)
			else
				soundpath = self.Bullet.ExplosionSound[1]
			end
			WorldSound( soundpath, self.Entity:GetPos(),100,100)
		end
		
		self:Remove()
	end
end

-- Explode (Is called when the bullet explodes) Note: this will not run if you override the think function (unless you call it from there as well)
BULLET.ExplodeOverride = false
function BULLET:Explode( self, trace )
	-- Nothing
end

-- This is called when the bullet collides (Advanced users only. It only works if you first override initialize and change it to vphysics)
BULLET.PhysicsCollideOverride = true
function BULLET:PhysicsCollideFunc(CollisionData, PhysObj)
	if (self.Collided == false) then
		self.Collided = true
	end
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