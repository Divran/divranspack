-- Pewpew Damage Control
-- These functions take care of dealing damage to other entities
------------------------------------------------------------------------------------------------------------

-- Blast Damage (A normal explosion)  (The damage formula is "clamp(Damage - (distance * RangeDamageMul), 0, Damage)")
function pewpew:BlastDamage( Position, Radius, Damage, RangeDamageMul )
	local ents = ents.FindInSphere( Position, Radius )
	if (!ents or table.Count(ents) == 0) then return end
	if (!Damage or Damage <= 0) then return end
	if (!Radius or Radius <= 0) then return end
	local dmg = 0
	local distance = 0
	for _, ent in pairs( ents ) do
		if (self:CheckValid( ent )) then 
			distance = Position:Distance( ent:GetPos() )
			dmg = math.Clamp(Damage - (distance * RangeDamageMul), 0, Damage)
			self:DealDamageBase( ent, dmg )
		end
	end
end

-- Point Damage - Deals damage to 1 single entity (Good for lasers and machineguns)
function pewpew:PointDamage( TargetEntity, Damage )
	self:CheckValid( TargetEntity )
	if (!Damage or Damage <= 0) then return end
	self:DealDamageBase( TargetEntity, Damage )
end

------------------------------------------------------------------------------------------------------------
-- Base code for dealing damage
function pewpew:DealDamageBase( TargetEntity, Damage )
	if (!self:CheckValid( TargetEntity )) then return end
	if (!Damage) then return end
	if (!TargetEntity.pewpewHealth) then
		self:SetHealth( TargetEntity )
	end
	TargetEntity.pewpewHealth = TargetEntity.pewpewHealth - math.abs(Damage)
	self:CheckIfDead( TargetEntity )
end

-- Set the health of a spawned entity
function pewpew:SetHealth( ent )
	if (!self:CheckValid( ent )) then return end
	local phys = ent:GetPhysicsObject()
	if (!phys) then return end
	local mass = phys:GetMass() or 0
	local boxsize = ent:OBBMaxs() - ent:OBBMins()
	ent.pewpewHealth = math.Round(mass * 2 + boxsize:Length() / 3)
end

-- Add to the existing health
function pewpew:AddHealth( ent, Health )
	if (!self:CheckValid( ent )) then return end
	if (!ent.pewpewHealth) then
		self:SetHealth( TargetEntity )
	end
	ent.pewpewHealth = ent.pewpewHealth + math.abs(Health)
end

-- Set health to anything you want
function pewpew:SetCustomHealth( ent, Health )
	if (!self:CheckValid( ent )) then return end
	if (!ent.pewpewHealth) then
		self:SetHealth( TargetEntity )
	end
	ent.pewpewHealth = clamp( Health, 0, Health )
end

-- Returns the health of the entity
function pewpew:GetHealth( ent )
	if (!self:CheckValid( ent )) then return end
	return ent.pewpewHealth or 0
end

-- Check if the entity should be removed
function pewpew:CheckIfDead( ent )
	if (ent.pewpewHealth < 0) then
		local effectdata = EffectData()
		effectdata:SetOrigin( ent:GetPos() )
		effectdata:SetStart( ent:GetPos() )
		effectdata:SetNormal( Vector(0,0,1) )
		util.Effect( "spawneffect", effectdata )
		ent:Remove()
	end
end

function pewpew:CheckValid( entity ) -- Note: copied from E2Lib
	if (entity):IsValid() then
		if entity:IsWorld() then return false end
		if entity:GetMoveType() ~= MOVETYPE_VPHYSICS then return false end
		return entity:GetPhysicsObject():IsValid()
	end
end
------------------------------------------------------------------------------------------------------------