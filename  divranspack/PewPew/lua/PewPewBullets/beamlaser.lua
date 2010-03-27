-- Basic Laser

local BULLET = {}

-- General Information
BULLET.Name = "Beam laser"
BULLET.Category = "Lasers"
BULLET.Author = "Divran"
BULLET.Description = "Fires a constant laser beam."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false


-- Effects / Sounds
BULLET.FireSound = nil
BULLET.ExplosionSound = nil
BULLET.FireEffect = nil
BULLET.ExplosionEffect = "pewpew_laserbeam"


-- Damage
BULLET.DamageType = "PointDamage"
BULLET.Damage = 5

-- Reloading/Ammo
BULLET.Reloadtime = 0.01
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

BULLET.EnergyPerShot = 10

-- Custom Functions 
-- (If you set the override var to true, the cannon/bullet will run these instead. Use these functions to do stuff which is not possible with the above variables)

-- Fire (Is called before the cannon is about to fire)
BULLET.FireOverride = true
function BULLET:Fire( self, Pos, Dir )
	local startpos
	local Dir
	
	local boxsize = self.Entity:OBBMaxs() - self.Entity:OBBMins()
	
	if (self.Direction == 1) then -- Up
		Dir = self.Entity:GetUp()
		startpos = self.Entity:LocalToWorld(self.Entity:OBBCenter()) + Dir * (boxsize.z/2)
	elseif (self.Direction == 2) then -- Down
		Dir = self.Entity:GetUp() * -1
		startpos = self.Entity:LocalToWorld(self.Entity:OBBCenter()) + Dir * (boxsize.z/2)
	elseif (self.Direction == 3) then -- Left
		Dir = self.Entity:GetRight() * -1
		startpos = self.Entity:LocalToWorld(self.Entity:OBBCenter()) + Dir * (boxsize.y/2)
	elseif (self.Direction == 4) then -- Right
		Dir = self.Entity:GetRight()
		startpos = self.Entity:LocalToWorld(self.Entity:OBBCenter()) + Dir * (boxsize.y/2)
	elseif (self.Direction == 5) then -- Forward
		Dir = self.Entity:GetForward()
		startpos = self.Entity:LocalToWorld(self.Entity:OBBCenter()) + Dir * (boxsize.x/2)
	elseif (self.Direction == 6) then -- Back
		Dir = self.Entity:GetForward() * -1
		startpos = self.Entity:LocalToWorld(self.Entity:OBBCenter()) + Dir * (boxsize.x/2)
	end
	
	-- Deal damage
	local tr = {}
	tr.start = startpos
	tr.endpos = startpos + Dir * 100000
	tr.filter = self.Entity
	local trace = util.TraceLine( tr )
	
	if (trace.Entity and trace.Entity:IsValid() and !pewpew:FindSafeZone( self.Entity:GetPos() )) then
		pewpew:PointDamage( trace.Entity, self.Bullet.Damage, self.Entity )
	end
	
	local effectdata = EffectData()
	effectdata:SetOrigin( trace.HitPos or ( startpos + self.Entity:GetUp() * 100000 )  )
	effectdata:SetStart( startpos )
	effectdata:SetEntity( self.Entity )
	util.Effect( self.Bullet.ExplosionEffect, effectdata )
end

pewpew:AddBullet( BULLET )