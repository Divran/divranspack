-- Basic Cannon

local BULLET = {}

-- General Information
BULLET.Name = "Delayed Sticky-Bomb Launcher"
BULLET.Category = "Cannons"
BULLET.Author = "Free Fall"
BULLET.Description = "Fires a bomb that will stick to whatever it hits and explodes short time after"
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/Roller.mdl"

-- Effects / Sounds
BULLET.FireSound = {"arty/25mm.wav"}
BULLET.ExplosionSound = {"weapons/explode1.wav","weapons/explode2.wav"}
BULLET.FireEffect = "cannon_flare"
BULLET.ExplosionEffect = "big_splosion"

-- Movement
BULLET.Speed = 5000
BULLET.RecoilForce = 800
BULLET.Spread = 0

-- Damage
BULLET.DamageType = "BlastDamage"
BULLET.Damage = 300
BULLET.Radius = 800
BULLET.RangeDamageMul = 0.3
BULLET.PlayerDamage = 150
BULLET.PlayerDamageRadius = 300

-- Reloading/Ammo
BULLET.Reloadtime = 3.5

BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

BULLET.FireOverride = false

BULLET.InitializeOverride = true
function BULLET:InitializeFunc(self)
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	
	self.Propelled = false
	self.Sticked = false
	self.StickBlow = 0
	
	constraint.NoCollide(self.Entity, self.Cannon.Entity, 0, 0)
	
	self.Entity:NextThink(CurTime())
end

BULLET.ThinkOverride = true
function BULLET:ThinkFunc( self )
	if (not self.Propelled) then
		local phys = self.Entity:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:ApplyForceCenter(self.Entity:GetUp() * phys:GetMass() * self.Bullet.Speed)
		end
		
		self.Propelled = true
	end
	
	if (self.StickEntity and not self.Sticked) then
		constraint.Weld(self.Entity, self.StickEntity, 0, 0, 0, true)
		
		self.Sticked = true
		self.StickBlow = CurTime() + (math.random(20, 50) / 10)
	end
	
	if (self.Sticked and CurTime() >= self.StickBlow) then
		if (self.Bullet.PlayerDamageRadius and self.Bullet.PlayerDamage and pewpew.PewPewDamage) then
			util.BlastDamage(self.Entity, self.Entity, self:GetPos(), self.Bullet.PlayerDamageRadius, self.Bullet.PlayerDamage)
		end
		
		if (self.Bullet.ExplosionEffect) then
			local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos())
			effectdata:SetStart(self:GetPos())
			effectdata:SetNormal(self:GetUp())
			util.Effect(self.Bullet.ExplosionEffect, effectdata)
		end
		
		if (self.Bullet.ExplosionSound) then
			local soundpath = ""
			if (table.Count(self.Bullet.ExplosionSound) > 1) then
				soundpath = table.Random(self.Bullet.ExplosionSound)
			else
				soundpath = self.Bullet.ExplosionSound[1]
			end
			WorldSound(soundpath, self:GetPos(), 100, 100)
		end
		
		pewpew:BlastDamage(self:GetPos(), self.Bullet.Radius, self.Bullet.Damage, self.Bullet.RangeDamageMul)
		
		self.Entity:Remove()
	end
	
	self.Entity:NextThink(CurTime() + 0.25)
	return true
end

BULLET.ExplodeOverride = false

BULLET.PhysicsCollideOverride = true
function BULLET:PhysicsCollideFunc(CollisionData, PhysObj)
	if (not (self.Cannon:IsValid() and PhysObj == self.Cannon:GetPhysicsObject()) and self.Propelled and not self.Sticked) then
		local Entity = CollisionData.HitEntity
	
		self.StickEntity = Entity
		
		self.Entity:NextThink(CurTime())
	end
end

-- Client side overrides:

BULLET.CLInitializeOverride = false

BULLET.CLThinkOverride = false

BULLET.CLDrawOverride = false

pewpew:AddBullet( BULLET )