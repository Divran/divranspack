-- Basic Cannon

local BULLET = {}

-- General Information
BULLET.Name = "Laser Sword"
BULLET.Category = "CloseCombat"
BULLET.Author = "Divran"
BULLET.Description = "May the force be with you."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = nil
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = nil
BULLET.ExplosionSound = nil
BULLET.FireEffect = "pewpew_swordeffect"
BULLET.ExplosionEffect = nil
BULLET.EmptyMagSound = nil

-- Movement
BULLET.Speed = nil
BULLET.Gravity = nil
BULLET.RecoilForce = nil
BULLET.Spread = nil

-- Damage
BULLET.DamageType = "SliceDamage"
BULLET.Damage = 200
BULLET.Radius = nil
BULLET.RangeDamageMul = nil
BULLET.NumberOfSlices = 3
BULLET.SliceDistance = 500
BULLET.Duration = nil
BULLET.PlayerDamage = nil
BULLET.PlayerDamageRadius = nil

-- Reloading/Ammo
BULLET.Reloadtime = 0.05
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

BULLET.EnergyPerShot = 75

-- Custom Functions 
-- (If you set the override var to true, the cannon/bullet will run these instead. Use these functions to do stuff which is not possible with the above variables)

-- Fire (Is called before the cannon is about to fire)
BULLET.FireOverride = true
function BULLET:Fire( self )
	-- Get the start position
	local boxsize = self.Entity:OBBMaxs() - self.Entity:OBBMins()
	local startpos = self.Entity:LocalToWorld(self.Entity:OBBCenter()) + self.Entity:GetUp() * (boxsize.z / 2 + 2)
	
	-- Deal damage
	local HitPos = pewpew:SliceDamage( startpos, self.Entity:GetUp(), self.Bullet.Damage, self.Bullet.NumberOfSlices, self.Bullet.SliceDistance, self.Entity )
	
	local effectdata = EffectData()
	effectdata:SetStart( startpos )
	effectdata:SetOrigin( HitPos or (startpos + self.Entity:GetUp() * self.Bullet.SliceDistance) )
	util.Effect( self.Bullet.FireEffect, effectdata )
end

pewpew:AddBullet( BULLET )