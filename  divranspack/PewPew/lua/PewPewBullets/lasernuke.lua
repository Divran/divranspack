-- Basic Laser

local BULLET = {}

-- General Information
BULLET.Name = "Laser Nuke"
BULLET.Category = "AdminOnly"
BULLET.Author = "Divran"
BULLET.Description = "BLAAAAAARGH"
BULLET.AdminOnly = true
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = nil
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"npc/strider/fire.wav"}
BULLET.ExplosionSound = { "ambient/explosions/citadel_end_explosion1.wav", "ambient/explosions/citadel_end_explosion2.wav" }
BULLET.FireEffect = "Deathbeam2"
BULLET.ExplosionEffect = "breachsplode"

-- Movement
BULLET.Speed = nil
BULLET.PitchChange = nil
BULLET.RecoilForce = nil
BULLET.Spread = nil

-- Damage
BULLET.DamageType = nil -- custom
BULLET.Damage = 9001
BULLET.Radius = 7000
BULLET.RangeDamageMul = 0.6
BULLET.NumberOfSlices = nil
BULLET.PlayerDamage = 5000
BULLET.PlayerDamageRadius = 5000

-- Reloading/Ammo
BULLET.Reloadtime = 11
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

-- Custom Functions 
-- (If you set the override var to true, the cannon/bullet will run these instead. Use these functions to do stuff which is not possible with the above variables)

-- Fire (Is called before the cannon is about to fire)
BULLET.FireOverride = true
function BULLET:Fire( self )
	-- Get the start position
	local boxsize = self.Entity:OBBMaxs() - self.Entity:OBBMins()
	local startpos = self.Entity:GetPos() + self.Entity:GetUp() * (boxsize.z / 2 + 10)
	
	-- Start a trace
	local tr = {}
	tr.start = startpos
	tr.endpos = self.Entity:GetUp() * 10000
	tr.filter = self.Entity
	local trace = util.TraceLine( tr )
	
	-- Deal damage
	local HitPos = trace.HitPos
	
	-- If the first trace didn't hit anything..
	if (!trace.Hit) then
		-- Start a new trace
		tr = {}
		local startpos2 = startpos + self.Entity:GetUp() * 10000
		tr.start = startpos2
		tr.endpos = startpos2 + self.Entity:GetUp() * 10000
		trace = util.TraceLine( tr )
		
		-- Deal damage
		HitPos = trace.HitPos
	end
	
	-- Effects
	self:EmitSound( self.Bullet.FireSound[1] )
	local effectdata = EffectData()
	effectdata:SetOrigin( HitPos or (startpos + self.Entity:GetUp() * 10000) )
	effectdata:SetStart( startpos )
	util.Effect( self.Bullet.ExplosionEffect, effectdata )
	
	local effectdata = EffectData()
	effectdata:SetOrigin( HitPos )
	effectdata:SetStart( startpos )
	util.Effect( self.Bullet.FireEffect, effectdata )
	
	-- Sounds
	if (self.Bullet.ExplosionSound) then
		local soundpath = ""
		if (table.Count(self.Bullet.ExplosionSound) > 1) then
			soundpath = table.Random(self.Bullet.ExplosionSound)
		else
			soundpath = self.Bullet.ExplosionSound[1]
		end
		WorldSound( soundpath, trace.HitPos+trace.HitNormal*5,100,100)
	end
	
	if (pewpew.PewPewDamage) then
		if (trace.Entity and trace.Entity:IsValid()) then
			pewpew:PointDamage( trace.Entity, self.Bullet.Damage )
			pewpew:BlastDamage( trace.HitPos, self.Bullet.Radius, self.Bullet.Damage, self.Bullet.RangeDamageMul, trace.Entity )
		else
			pewpew:BlastDamage( trace.HitPos, self.Bullet.Radius, self.Bullet.Damage, self.Bullet.RangeDamageMul )
		end
		util.BlastDamage( self.Entity, self.Entity, trace.HitPos + trace.HitNormal * 10, self.Bullet.PlayerDamageRadius, self.Bullet.PlayerDamage )
	end
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