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
BULLET.DamageType = "SliceDamage" -- Look in gcombat_damagecontrol.lua for available damage types
BULLET.Damage = 85
BULLET.Radius = nil
BULLET.RangeDamageMul = nil
BULLET.NumberOfSlices = 4
BULLET.SliceDistance = 50000
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
	local startpos = self.Entity:LocalToWorld(self.Entity:OBBCenter()) + self.Entity:GetUp() * (boxsize.z / 2 + 10)
	
	-- Deal damage
	local HitPos = pewpew:SliceDamage( startpos, self.Entity:GetUp(), self.Bullet.Damage, self.Bullet.NumberOfSlices, self.Bullet.SliceDistance )
	
	-- Effects
	self:EmitSound( self.Bullet.FireSound[1] )
	
	if (HitPos) then
		local effectdata = EffectData()
		effectdata:SetOrigin( HitPos )
		effectdata:SetStart( startpos )
		util.Effect( self.Bullet.ExplosionEffect, effectdata )
	end
end

pewpew:AddBullet( BULLET )