-- Basic Laser

local BULLET = {}

-- General Information
BULLET.Name = "Basic Laser"

-- Appearance
BULLET.Model = nil
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = "Lasers/Small/Laser.wav"
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
BULLET.PlayerDamageRadius = nil
BULLET.PlayerDamage = nil

-- Other
BULLET.Reloadtime = 0.7

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
	local HitPos = pewpew:SliceDamage( trace, self.Entity:GetUp(), self.Bullet.Damage, 4 )
	
	-- If the first trace didn't hit anything..
	if (!HitPos) then
		-- Start a new trace
		tr = {}
		local startpos2 = startpos + self.Entity:GetUp() * 10000
		tr.start = startpos2
		tr.endpos = startpos2 + self.Entity:GetUp() * 10000
		trace = util.TraceLine( tr )
		
		-- Deal damage
		HitPos = pewpew:SliceDamage( trace, self.Entity:GetUp(), self.Bullet.Damage, 4 )
	end
	
	-- Effects
	self:EmitSound( self.Bullet.FireSound )
	local effectdata = EffectData()
	effectdata:SetOrigin( HitPos or (startpos + self.Entity:GetUp() * 10000) )
	effectdata:SetStart( startpos )
	util.Effect( self.Bullet.ExplosionEffect, effectdata )
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