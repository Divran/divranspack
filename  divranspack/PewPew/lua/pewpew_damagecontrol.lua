-- Pewpew Damage Control
-- These functions take care of damage

------------------------------------------------------------------------------------------------------------
-- Deal Damage

-- Entity types in the blacklist will not be harmed by PewPew weaponry.
pewpew.DamageBlacklist = { "pewpew_base_bullet", "gmod_wire", "gmod_ghost" }
-- Entity types in the whitelist will ALWAYS be harmed by PewPew weaponry, even if they are in the blacklist as well.
pewpew.DamageWhitelist = { "gmod_wire_turret", "gmod_wire_forcer", "gmod_wire_grabber" }

-- Serverwide Damage toggle
pewpew.PewPewDamage = true

-- Blast Damage (A normal explosion)  (The damage formula is "clamp(Damage - (distance * RangeDamageMul), 0, Damage)")
function pewpew:BlastDamage( Position, Radius, Damage, RangeDamageMul, IgnoreEnt )
		if (!self.PewPewDamage) then return end
	if (!Radius or Radius <= 0) then return end
	if (!Damage or Damage <= 0) then return end
	local ents = ents.FindInSphere( Position, Radius )
	if (!ents or table.Count(ents) == 0) then return end
	local dmg = 0
	local distance = 0
	for _, ent in pairs( ents ) do
		if (self:CheckValid( ent )) then 
			if (IgnoreEnt) then
				if (ent != IgnoreEnt) then
					distance = Position:Distance( ent:GetPos() )
					dmg = math.Clamp(Damage - (distance * RangeDamageMul), 0, Damage)
					self:DealDamageBase( ent, dmg )
				end
			else
				distance = Position:Distance( ent:GetPos() )
				dmg = math.Clamp(Damage - (distance * RangeDamageMul), 0, Damage)
				self:DealDamageBase( ent, dmg )
			end
		end
	end
end

-- Point Damage - (Deals damage to 1 single entity)
function pewpew:PointDamage( TargetEntity, Damage )
	self:DealDamageBase( TargetEntity, Damage )
	-- Might change this later...
end

-- Slice damage - (Deals damage to a number of entities in a line. It is stopped by the world)
function pewpew:SliceDamage( StartPos, Direction, Damage, NumberOfSlices, MaxRange )
		-- Check dmg
		if (!self.PewPewDamage) then return nil end
	local OldPos = StartPos
	-- First trace
	local tr = {}
	tr.start = StartPos
	tr.endpos = StartPos + Direction * MaxRange
	local trace = util.TraceLine( tr )
	-- Check world
	if (!trace.Hit) then return nil end
	if (trace.HitWorld) then return trace.HitPos end
	-- Get ent
	local HitEnt = trace.Entity
	-- Loop
	for I=1, NumberOfSlices do
		-- Check world
		if (OldPos) then
			if (!trace.Hit) then return OldPos end
			-- Check distance
			if (StartPos:Distance(OldPos) > MaxRange) then return OldPos end
		end
		if (HitEnt and self:CheckValid( HitEnt )) then
			-- Deal damage
			self:DealDamageBase( HitEnt, Damage )
			-- New trace
			tr = {}
			tr.start = OldPos
			tr.endpos = OldPos + Direction * MaxRange
			tr.filter = HitEnt
			if (I == NumberOfSlices) then local ret = trace.HitPos end
			trace = util.TraceLine( tr )
			OldPos = trace.HitPos
			HitEnt = trace.Entity
			-- Check world
			if (trace.HitWorld) then return trace.HitPos end
		end
	end
	return ret
end
		

--[[ Old function
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
end ]]

------------------------------------------------------------------------------------------------------------
-- Base Code

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
	if (!phys:IsValid()) then return end
	local mass = phys:GetMass() or 0
	local boxsize = TargetEntity:OBBMaxs() - TargetEntity:OBBMins()
	if (TargetEntity.pewpewHealth > mass / 5 + boxsize:Length()) then
		TargetEntity.pewpewHealth = (mass / 5 + boxsize:Length()) * (mass/TargetEntity.MaxMass)
	end
	-- Check if the entity has a core
	if (TargetEntity.Core and self:CheckValid(TargetEntity.Core)) then
		self:DamageCore( TargetEntity.Core, Damage )
		return
	end
	-- Deal damage
	TargetEntity.pewpewHealth = TargetEntity.pewpewHealth - math.abs(Damage)
	TargetEntity:SetNWInt("pewpewHealth",TargetEntity.pewpewHealth)
	self:CheckIfDead( TargetEntity )
end

------------------------------------------------------------------------------------------------------------
-- Core

-- Dealing damage to cores
function pewpew:DamageCore( ent, Damage )
	if (!self:CheckValid( ent )) then return end
	if (ent:GetClass() != "pewpew_core") then return end
	ent.pewpewCoreHealth = ent.pewpewCoreHealth - math.abs(Damage)
	ent:SetNWInt("pewpewHealth",ent.pewpewCoreHealth)
	-- Wire Output
	Wire_TriggerOutput( ent, "Total Health", ent.pewpewCoreHealth or 0 )
	self:CheckIfDeadCore( ent )
end

-- Repairs the entity by the set amount
function pewpew:RepairCoreHealth( ent, amount )
	-- Check for errors
	if (!self:CheckValid( ent )) then return end
	if (ent:GetClass() != "pewpew_core") then return end
	if (!ent.pewpewCoreHealth or !ent.pewpewCoreMaxHealth) then return end
	if (!amount or amount == 0) then return end
	-- Add health
	ent.pewpewCoreHealth = math.Clamp(ent.pewpewCoreHealth+math.abs(amount),0,ent.pewpewCoreMaxHealth)
	ent:SetNWInt("pewpewHealth",ent.pewpewCoreHealth or 0)
		-- Wire Output
	Wire_TriggerOutput( ent, "Total Health", ent.pewpewCoreHealth or 0 )
end

function pewpew:CheckIfDeadCore( ent )
	if (ent.pewpewCoreHealth <= 0) then
		ent:RemoveAllProps()
	end	
end

------------------------------------------------------------------------------------------------------------
-- Health

-- Set the health of a spawned entity
function pewpew:SetHealth( ent )
	if (!self:CheckValid( ent )) then return end
	local phys = ent:GetPhysicsObject()
	if (!phys:IsValid()) then return end
	local mass = phys:GetMass() or 0
	local boxsize = ent:OBBMaxs() - ent:OBBMins()
	local health = mass / 5 + boxsize:Length()
	ent.pewpewHealth = health
	ent.MaxMass = mass
	ent:SetNWInt("pewpewHealth",health)
	ent:SetNWInt("pewpewMaxHealth",health)
end

-- Repairs the entity by the set amount
function pewpew:RepairHealth( ent, amount )
	-- Check for errors
	if (!self:CheckValid( ent )) then return end
	if (!self:CheckAllowed( ent )) then return end
	if (!ent.pewpewHealth or !ent.MaxMass) then return end
	if (!amount or amount == 0) then return end
	-- Get the max allowed health
	local phys = ent:GetPhysicsObject()
	if (!phys:IsValid()) then return end
	local mass = phys:GetMass() or 0
	local boxsize = ent:OBBMaxs() - ent:OBBMins()
	local maxhealth = (mass / 5 + boxsize:Length())
	-- Add health
	ent.pewpewHealth = math.Clamp(ent.pewpewHealth+math.abs(amount),0,maxhealth)
	-- Make the health changeable again with weight tool
	if (ent.pewpewHealth == maxhealth) then
		ent.pewpewHealth = nil
		ent.MaxMass = nil
	end
	ent:SetNWInt("pewpewHealth",ent.pewpewHealth or 0)
	ent:SetNWInt("pewpewMaxHealth",maxhealth or 0)
end

-- Returns the health of the entity without setting it
function pewpew:GetHealth( ent )
	if (!self:CheckValid( ent )) then return end
	if (!self:CheckAllowed( ent )) then return end
	local phys = ent:GetPhysicsObject()
	if (!phys:IsValid()) then return end
	local mass = phys:GetMass() or 0
	local boxsize = ent:OBBMaxs() - ent:OBBMins()
	if (ent.pewpewHealth) then
		-- Check if the entity has too much health (if the player changed the mass to something huge then back again)
		if (ent.pewpewHealth > mass / 5 + boxsize:Length()) then
			return (mass / 5 + boxsize:Length()) * (mass/ent.MaxMass)
		end
		return ent.pewpewHealth
	else
		return (mass / 5 + boxsize:Length())
	end
end

------------------------------------------------------------------------------------------------------------
-- Checks

-- Check if the entity should be removed
function pewpew:CheckIfDead( ent )
	if (ent.pewpewHealth <= 0) then
		local effectdata = EffectData()
		effectdata:SetOrigin( ent:GetPos() )
		effectdata:SetScale( (ent:OBBMaxs() - ent:OBBMins()):Length() )
		util.Effect( "pewpew_deatheffect", effectdata )
		ent:Remove()
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

function pewpew:CheckValid( entity ) -- Note: this function is mostly copied from E2Lib, then edited
	if (entity):IsValid() then
		if entity:IsWorld() then return false end
		if entity:GetMoveType() ~= MOVETYPE_VPHYSICS then return false end
		return entity:GetPhysicsObject():IsValid()
	end
end

------------------------------------------------------------------------------------------------------------
-- Toggle Damage

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
