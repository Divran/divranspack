-- Basic Laser

local BULLET = {}

-- General Information
BULLET.Name = "Rapid Fire Laser"
BULLET.Category = "Lasers"
BULLET.Author = "Colonel Thirty Two"
BULLET.Description = "Laser emitter with a high rate of fire."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = nil
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"col32/gun4.wav"}
BULLET.ExplosionSound = nil
BULLET.FireEffect = nil
BULLET.ExplosionEffect = "ISSmallPulseBeam"

-- Movement
BULLET.Speed = nil
BULLET.Gravity = nil
BULLET.RecoilForce = nil
BULLET.Spread = 0.3

-- Damage
BULLET.DamageType = "PointDamage"
BULLET.Damage = 25
BULLET.Radius = nil
BULLET.RangeDamageMul = nil
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.PlayerDamageRadius = nil
BULLET.PlayerDamage = nil

-- Reloading/Ammo
BULLET.Reloadtime = 0.1
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

BULLET.Lifetime = nil
BULLET.ExplodeAfterDeath = false
BULLET.EnergyPerShot = 200

BULLET.CustomInputs = nil
BULLET.CustomOutputs = nil

-- Fire (Is called before the cannon is about to fire)
BULLET.FireOverride = true
function BULLET:Fire( self )
	-- Get the start position
	local boxsize = self.Entity:OBBMaxs() - self.Entity:OBBMins()
	local startpos = self.Entity:LocalToWorld(self.Entity:OBBCenter()) + self.Entity:GetUp() * (boxsize.z / 2 + 10)
	
	local spread = Angle(math.Rand(-BULLET.Spread,BULLET.Spread),math.Rand(-BULLET.Spread,BULLET.Spread),0)
	local direction = self.Entity:GetUp()
	direction:Rotate(spread)
	
	-- Deal damage
	local tr = {}
	tr.start = startpos
	tr.endpos = startpos + direction * 100000 -- Whatever
	local trace = util.TraceLine( tr )
	local HitPos = trace.HitPos or StartPos + direction * 100000
	if(trace.HitNonWorld) then
		pewpew:PointDamage(trace.Entity, self.Bullet.Damage, self)
	end
	
	-- Effects
	self:EmitSound( self.Bullet.FireSound[1] )
	
	local effectdata = EffectData()
	effectdata:SetOrigin( HitPos or (startpos + direction * self.Bullet.SliceDistance)  )
	effectdata:SetStart( startpos )
	util.Effect( self.Bullet.ExplosionEffect, effectdata )
end

pewpew:AddBullet( BULLET )