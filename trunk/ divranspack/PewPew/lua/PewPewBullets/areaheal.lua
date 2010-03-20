-- Regenerator

local BULLET = {}

-- General Information
BULLET.Name = "Regenerator"
BULLET.Category = "Defense"
BULLET.Author = "Divran"
BULLET.Description = "This healer will slowly regenerate the health of all nearby entities. Has 700 range."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Effects / Sounds
BULLET.FireSound = nil
BULLET.FireEffect = "pewpew_healthbeam"

-- Damage
BULLET.DamageType = "DefenseDamage"
BULLET.Damage = 50
BULLET.Radius = nil
BULLET.RangeDamageMul = nil
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.Duration = nil
BULLET.PlayerDamage = nil
BULLET.PlayerDamageRadius = nil

-- Reloading/Ammo
BULLET.Reloadtime = 0.3
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

-- Other
BULLET.Lifetime = nil
BULLET.ExplodeAfterDeath = false
BULLET.EnergyPerShot = 2000

BULLET.CustomInputs = { "Fire" }
BULLET.CustomOutputs = { }

-- Custom Functions (Only for adv users)
-- (If you set the override var to true, the cannon/bullet will run these instead. Use these functions to do stuff which is not possible with the above variables)

-- Fire (Is called before the cannon is about to fire)
BULLET.FireOverride = true
function BULLET:Fire( self )
	-- Find all entities
	local entities = ents.FindInSphere( self.Entity:GetPos(), 700 )
	
	-- Effect start position
	local boxsize = self.Entity:OBBMaxs() - self.Entity:OBBMins()
	local startpos = self.Entity:LocalToWorld(self.Entity:OBBCenter()) + self.Entity:GetUp() * (boxsize.z / 2 + 10)
	
	-- Loop through all entities and heal them
	for _, e in pairs( entities ) do
		if (pewpew:CheckValid( e )) then
			local hp = pewpew:GetHealth( e )
			local maxhp = pewpew:GetMaxHealth( e )
			if (hp and maxhp and hp < maxhp) then
				pewpew:RepairHealth( e, self.Bullet.Damage )
				local effectdata = EffectData()
				effectdata:SetOrigin( e:GetPos() )
				effectdata:SetStart( startpos )
				util.Effect( self.Bullet.FireEffect, effectdata )
			end
		end
	end
end

pewpew:AddBullet( BULLET )