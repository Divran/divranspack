-- Basic Cannon

local BULLET = {}

-- General Information
BULLET.Name = "Medium Laser"
BULLET.Category = "Lasers"
BULLET.Author = "Colonel Thirty Two"
BULLET.Description = "Laser weapon with medium rate of fire. Does not slice through entities."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = nil
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"Lasers/Medium/Laser.wav"}
BULLET.ExplosionSound = nil
BULLET.FireEffect = nil
BULLET.ExplosionEffect = "MedLaser"

-- Movement
BULLET.Speed = nil
BULLET.Gravity = nil
BULLET.RecoilForce = nil
BULLET.Spread = nil

-- Damage
BULLET.DamageType = "PointDamage"
BULLET.Damage = 155
BULLET.Radius = nil
BULLET.RangeDamageMul = nil
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.PlayerDamageRadius = nil
BULLET.PlayerDamage = 50

-- Reloading/Ammo
BULLET.Reloadtime = 0.5
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

BULLET.Lifetime = {0,0} 
BULLET.ExplodeAfterDeath = false
BULLET.EnergyPerShot = 600


-- Fire (Is called before the cannon is about to fire)
BULLET.FireOverride = true
function BULLET:Fire( self )
	local startpos
	local direction
	
	local boxsize = self.Entity:OBBMaxs() - self.Entity:OBBMins()

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
	effectdata:SetOrigin( HitPos or (startpos + direction * self.Bullet.SliceDistance)  )
	effectdata:SetStart( startpos )
	util.Effect( self.Bullet.ExplosionEffect, effectdata )
end

pewpew:AddBullet( BULLET )