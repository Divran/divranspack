-- Pewpew Damage Control
-- These functions take care of damage
------------------------------------------------------------------------------------------------------------

-- Entity types in the blacklist will not be harmed by PewPew weaponry.
pewpew.DamageBlacklist = { "gmod_wire", "gmod_ghost" }
-- Entity types in the whitelist will ALWAYS be harmed by PewPew weaponry, even if they are in the blacklist as well.
pewpew.DamageWhitelist = { "gmod_wire_turret", "gmod_wire_forcer", "gmod_wire_grabber" }

-- Serverwide Damage toggle
pewpew.PewPewDamage = true

-- Blast Damage (A normal explosion)  (The damage formula is "clamp(Damage - (distance * RangeDamageMul), 0, Damage)")
function pewpew:BlastDamage( Position, Radius, Damage, RangeDamageMul )
		if (!self.PewPewDamage) then return end
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

-- Point Damage - Deals damage to 1 single entity
function pewpew:PointDamage( TargetEntity, Damage )
	self:DealDamageBase( TargetEntity, Damage )
	-- Might change this later...
end

-- Slice damage - (Deals damage to a number of entities in a line. It is stopped by the world)
function pewpew:SliceDamage( trace, direction, Damage, NumberOfSlices )
		if (!self.PewPewDamage) then return nil end
	if (!trace.Hit) then return nil end
	if (trace.HitWorld) then return trace.HitPos end
	local ent=nil
	local tr = {}
	local currenttrace = trace
	for I=1, NumberOfSlices - 1 do
		ent = currenttrace.Entity
		if (currenttrace.HitWorld) then return currenttrace.HitPos end
		if (self:CheckValid( ent )) then
			self:DealDamageBase( ent, Damage )
			tr = {}
			tr.start = currenttrace.HitPos
			tr.endpos = currenttrace.HitPos + direction * 5000
			tr.filter = ent
			currenttrace = util.TraceLine( tr )
		end
	end
	if (currenttrace.Hit and self:CheckValid( currenttrace.Entity )) then
		self:DealDamageBase( currenttrace.Entity, Damage )
	end
	return currenttrace.HitPos
end

-- Base code for dealing damage
function pewpew:DealDamageBase( TargetEntity, Damage )
		if (!self.PewPewDamage) then return end
	-- Check for errors
	if (!self:CheckValid( TargetEntity )) then return end
	if (!self:CheckAllowed( TargetEntity )) then return end
	if (!Damage or Damage == 0) then return end
	if (!TargetEntity.pewpewHealth) then
		self:SetHealth( TargetEntity )
	end
	-- Check if the entity has too much health (if the player changed the mass to something huge then back again)
	local phys = TargetEntity:GetPhysicsObject()
	if (!phys) then return end
	local mass = phys:GetMass() or 0
	local boxsize = TargetEntity:OBBMaxs() - TargetEntity:OBBMins()
	if (TargetEntity.pewpewHealth > mass / 5 + boxsize:Length()) then
		TargetEntity.pewpewHealth = (mass / 5 + boxsize:Length()) * (mass/TargetEntity.MaxMass)
	end
	-- Deal damage
	TargetEntity.pewpewHealth = TargetEntity.pewpewHealth - math.abs(Damage)
	self:CheckIfDead( TargetEntity )
end

------------------------------------------------------------------------------------------------------------

-- Set the health of a spawned entity
function pewpew:SetHealth( ent )
	if (!self:CheckValid( ent )) then return end
	local phys = ent:GetPhysicsObject()
	if (!phys) then return end
	local mass = phys:GetMass() or 0
	local boxsize = ent:OBBMaxs() - ent:OBBMins()
	ent.pewpewHealth = mass / 5 + boxsize:Length()
	ent.MaxMass = mass
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
	ent.pewpewHealth = math.abs( Health )
end

-- Returns the health of the entity without setting it
function pewpew:GetHealth( ent )
	if (!self:CheckValid( ent )) then return end
	if (ent.pewpewHealth) then
		return ent.pewpewHealth
	else
		local phys = ent:GetPhysicsObject()
		if (!phys) then return end
		local mass = phys:GetMass() or 0
		local boxsize = ent:OBBMaxs() - ent:OBBMins()
		return (mass / 5 + boxsize:Length())
	end
end

------------------------------------------------------------------------------------------------------------

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

function pewpew:CheckValid( entity ) -- Note: this function is copied from E2Lib
	if (entity):IsValid() then
		if entity:IsWorld() then return false end
		if entity:GetMoveType() ~= MOVETYPE_VPHYSICS then return false end
		return entity:GetPhysicsObject():IsValid()
	end
end

function pewpew:CheckAllowed( entity )
	for _, str in pairs( self.DamageWhitelist ) do
		if (entity:GetClass() == str) then return true end
	end
	for _, str in pairs( self.DamageBlacklist ) do
		if (string.find( entity:GetClass(), str )) then return false end
	end
	return true
end

------------------------------------------------------------------------------------------------------------

local function ToggleDamage( ply, command, arg )
	if ( !ply or !ply:IsValid() ) then return end
	if (ply:IsAdmin()) then
		pewpew.PewPewDamage = !pewpew.PewPewDamage
		if (pewpew.PewPewDamage) then
			for _, v in pairs( player.GetAll() ) do
				v:ChatPrint( ply:Nick() .. " has toggled PewPew Damage and it is now ON!")
			end
		else
			for _, v in pairs( player.GetAll() ) do
				v:ChatPrint( ply:Nick() .. " has toggled PewPew Damage and it is now OFF!")
			end
		end
	end
end
concommand.Add("PewPew_ToggleDamage", ToggleDamage)

hook.Add("PlayerInitialSpawn", "PewPewPlayerInit", function( ply )
	ply.PewPewDamage = true
end)
