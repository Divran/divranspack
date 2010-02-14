-- Basic Laser

local BULLET = {}

-- General Information
BULLET.Name = "Basic Laser"
BULLET.Category = "Lasers"
BULLET.Author = "Divran"
BULLET.Description = "Fires a laser beam which slices through and damages 4 props."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = nil
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"Lasers/Small/Laser.wav"}
BULLET.ExplosionSound = nil
BULLET.FireEffect = nil
BULLET.ExplosionEffect = "ISSmallPulseBeam"

-- Movement
BULLET.Speed = nil
BULLET.PitchChange = nil
BULLET.RecoilForce = nil
BULLET.Spread = nil

-- Damage
BULLET.DamageType = nil -- Look in gcombat_damagecontrol.lua for available damage types
BULLET.Damage = 85
BULLET.Radius = nil
BULLET.RangeDamageMul = nil
BULLET.NumberOfSlices = 4
BULLET.PlayerDamageRadius = nil
BULLET.PlayerDamage = nil

-- Reloading/Ammo
BULLET.Reloadtime = 0.7
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

-- Custom Functions 
-- (If you set the override var to true, the cannon/bullet will run these instead. Use these functions to do stuff which is not possible with the above variables)

-- Fire (Is called before the cannon is about to fire)
BULLET.FireOverride = true
function BULLET:Fire( self )
	-- Get the start position
	local boxsize = self.Entity:OBBMaxs() - self.Entity:OBBMins()
	local startpos = self.Entity:GetPos() + self.Entity:GetUp() * (boxsize.x / 2 + 10)
	
	-- Start a trace
	local tr = {}
	tr.start = startpos
	tr.endpos = self.Entity:GetUp() * 10000
	tr.filter = self.Entity
	local trace = util.TraceLine( tr )
	
	-- Deal damage
	local HitPos = pewpew:SliceDamage( trace, self.Entity:GetUp(), self.Bullet.Damage, self.Bullet.NumberOfSlices )
	
	-- If the first trace didn't hit anything..
	if (!HitPos) then
		-- Start a new trace
		tr = {}
		local startpos2 = startpos + self.Entity:GetUp() * 10000
		tr.start = startpos2
		tr.endpos = startpos2 + self.Entity:GetUp() * 10000
		trace = util.TraceLine( tr )
		
		-- Deal damage
		HitPos = pewpew:SliceDamage( trace, self.Entity:GetUp(), self.Bullet.Damage, self.Bullet.NumberOfSlices  )
	end
	
	-- Effects
	self:EmitSound( self.Bullet.FireSound[1] )
	local effectdata = EffectData()
	effectdata:SetOrigin( HitPos or (startpos + self.Entity:GetUp() * 10000) )
	effectdata:SetStart( startpos )
	util.Effect( self.Bullet.ExplosionEffect, effectdata )
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