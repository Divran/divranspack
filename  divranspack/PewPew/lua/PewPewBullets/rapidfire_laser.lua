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
	-- Calculate initial position of bullet
	local boxsize = self.Entity:OBBMaxs() - self.Entity:OBBMins()
	local startpos
	local direction
	
	if (self.Direction == 1) then -- Up
		direction = self.Entity:GetUp()
		startpos = self.Entity:LocalToWorld(self.Entity:OBBCenter()) + direction * (boxsize.z/2)
	elseif (self.Direction == 2) then -- Down
		direction = self.Entity:GetUp() * -1
		startpos = self.Entity:LocalToWorld(self.Entity:OBBCenter()) + direction * (boxsize.z/2)
	elseif (self.Direction == 3) then -- Left
		direction = self.Entity:GetRight() * -1
		startpos = self.Entity:LocalToWorld(self.Entity:OBBCenter()) + direction * (boxsize.y/2)
	elseif (self.Direction == 4) then -- Right
		direction = self.Entity:GetRight()
		startpos = self.Entity:LocalToWorld(self.Entity:OBBCenter()) + direction * (boxsize.y/2)
	elseif (self.Direction == 5) then -- Forward
		direction = self.Entity:GetForward()
		startpos = self.Entity:LocalToWorld(self.Entity:OBBCenter()) + direction * (boxsize.x/2)
	elseif (self.Direction == 6) then -- Back
		direction = self.Entity:GetForward() * -1
		startpos = self.Entity:LocalToWorld(self.Entity:OBBCenter()) + direction * (boxsize.x/2)
	end
	
	local num = self.Bullet.Spread
	if (num) then
		local spread = Angle(math.Rand(-num,num),math.Rand(-num,num),0)
		direction:Rotate(spread)
	end
	
	-- Deal damage
	local tr = {}
	tr.start = startpos
	tr.endpos = startpos + direction * 100000 -- Whatever
	local trace = util.TraceLine( tr )
	local HitPos = trace.HitPos or StartPos + direction * 100000
	if(trace.HitNonWorld and !pewpew:FindSafeZone(self.Entity:GetPos())) then
		pewpew:PointDamage(trace.Entity, self.Bullet.Damage, self)
	end
	
	-- Effects
	self:EmitSound( self.Bullet.FireSound[1] )
	
	local effectdata = EffectData()
	effectdata:SetOrigin( HitPos  )
	effectdata:SetStart( startpos )
	util.Effect( self.Bullet.ExplosionEffect, effectdata )
end

pewpew:AddBullet( BULLET )