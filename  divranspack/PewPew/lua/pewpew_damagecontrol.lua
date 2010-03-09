-- Pewpew Damage Control
-- These functions take care of damage
------------------------------------------------------------------------------------------------------------

-- Entities in the Never Ever hit list will NEVER EVER take damage by PewPew weaponry.
pewpew.NeverEverList = { "pewpew_base_bullet", "gmod_ghost" }
-- Entity types in the blacklist will deal their damage to the first non-blacklisted entity they are constrained to. If they are not constrained to one, they take the damage themselves
pewpew.DamageBlacklist = { "gmod_wire" }
-- Entity types in the whitelist will ALWAYS be harmed by PewPew weaponry, even if they are in the blacklist as well.
pewpew.DamageWhitelist = { "gmod_wire_turret", "gmod_wire_forcer", "gmod_wire_grabber" }

-- Default Values
pewpew.Installed = true -- Yep it's installed :)
pewpew.Damage = true
pewpew.Firing = true
pewpew.Numpads = true
pewpew.DamageMul = 1
pewpew.CoreDamageMul = 1
pewpew.CoreDamageOnly = false
pewpew.RepairToolHeal = 75
pewpew.RepairToolHealCores = 200
pewpew.EnergyUsage = false

if (CAF and CAF.GetAddon("Resource Distribution") and CAF.GetAddon("Life Support")) then
	pewpew.EnergyUsage = true
end

------------------------------------------------------------------------------------------------------------

-- Blast Damage (A normal explosion)  (The damage formula is "clamp(Damage - (distance * RangeDamageMul), 0, Damage)")
function pewpew:BlastDamage( Position, Radius, Damage, RangeDamageMul, IgnoreEnt )
		if (!self.Damage) then return end
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
					if (ent.Core and ent.Core:IsValid()) then dmg = dmg / 2 end
					self:DealDamageBase( ent, dmg )
				end
			else
				distance = Position:Distance( ent:GetPos() )
				dmg = math.Clamp(Damage - (distance * RangeDamageMul), 0, Damage)
				if (ent.Core and ent.Core:IsValid()) then dmg = dmg / 2 end
				self:DealDamageBase( ent, dmg )
			end
		end
	end
end

-- Point Damage - (Deals damage to 1 single entity)
function pewpew:PointDamage( TargetEntity, Damage, DamageDealer )
	if (TargetEntity:IsPlayer()) then
		if (DamageDealer and DamageDealer:IsValid()) then
			TargetEntity:TakeDamage( Damage, DamageDealer )
		end
	else
		self:DealDamageBase( TargetEntity, Damage )
	end
end

-- Slice damage - (Deals damage to a number of entities in a line. It is stopped by the world)
function pewpew:SliceDamage( StartPos, Direction, Damage, NumberOfSlices, MaxRange, DamageDealer )
	-- First trace
	local tr = {}
	tr.start = StartPos
	tr.endpos = StartPos + Direction * MaxRange
	local trace = util.TraceLine( tr )
	local Hit = trace.Hit
	local HitWorld = trace.HitWorld
	local HitPos = trace.HitPos
	local HitEnt = trace.Entity
	
	-- Check dmg
	if (!self.Damage) then
		if (Hit) then
			return HitPos
		else
			return StartPos + Direction * MaxRange
		end
	end
	
	local ret = HitPos
	for I=1, NumberOfSlices do
		if (HitEnt and HitEnt:IsValid()) then -- if the trace hit an entity
			if (StartPos:Distance(HitPos) > MaxRange) then -- check distance
				return StartPos + Direction * MaxRange
			else
				if (HitEnt:IsPlayer()) then
					HitEnt:TakeDamage( Damage, DamageDealer ) -- deal damage to players
				elseif (self:CheckValid( HitEnt )) then
					self:DealDamageBase( HitEnt, Damage ) -- Deal damage to entities
				end
				-- new trace
				local tr = {}
				tr.start = HitPos
				tr.endpos = HitPos + Direction * MaxRange
				tr.filter = HitEnt
				ret = HitPos
				local trace = util.TraceLine( tr )
				Hit = trace.Hit
				HitWorld = trace.HitWorld
				HitPos = trace.HitPos
				HitEnt = trace.Entity
			end
		elseif (HitWorld) then-- if the trace hit the world
			if (StartPos:Distance(HitPos) > MaxRange) then -- check distance
				return StartPos + Direction * MaxRange
			else
				return HitPos
			end
		elseif (!Hit) then -- if the trace hit nothing
			return StartPos + Direction * MaxRange
		end
	end
	return ret or HitPos or StartPos + Direction * MaxRange
end

-- EMPDamage - (Electro Magnetic Pulse. Disables all wiring within the radius for the duration)
pewpew.EMPAffected = {}

-- Override TriggerInput
local OriginalFunc = WireLib.TriggerInput
function WireLib.TriggerInput(ent, name, value, ...)
	-- My addition
	if (pewpew.EMPAffected[ent:EntIndex()] and pewpew.EMPAffected[ent:EntIndex()][1]) then  -- if it is affected
		if (CurTime() < pewpew.EMPAffected[ent:EntIndex()][2]) then -- if the time isn't up yet
			return
		else -- if the time is up
			pewpew.EMPAffected[ent:EntIndex()] = nil 
		end
	end
	
	OriginalFunc( ent, name, value, ... )
end

-- Add to EMPAffected
function pewpew:EMPDamage( Position, Radius, Duration )
		-- Check damage
		if (!self.Damage) then return end
	-- Check for errors
	if (!Position or !Radius or !Duration) then return end
	
	-- Find all entities in the radius
	local ents = ents.FindInSphere( Position, Radius )
	
	-- Loop through all found entities
	for _, ent in pairs(ents) do
		if (ent.TriggerInput) then
			if (!self.EMPAffected[ent:EntIndex()]) then self.EMPAffected[ent:EntIndex()] = {} end
			if (self.EMPAffected[ent:EntIndex()][1]) then -- if it is already affected
				self.EMPAffected[ent:EntIndex()][2] = CurTime() + Duration -- edit the duration
			else
				self.EMPAffected[ent:EntIndex()][1] = true -- affect it
				self.EMPAffected[ent:EntIndex()][2] = CurTime() + Duration -- set duration
			end
		end
	end
end

-- Fire Damage (Damages an entity over time) (DO NOT USE THIS YET.)
function pewpew:FireDamage( TargetEntity, DPS, Duration )
		-- Check damage
		if (!self.Damage) then return end
	-- Check for errors
	if (!TargetEntity or !self:CheckValid(TargetEntity) or !DPS or !Duration) then return end
	
	-- Effect
	TargetEntity:Ignite( Duration )
	
	-- Initial damage
	self:DealDamageBase( TargetEntity, DPS/10 )
	
	-- Start a timer
	local timername = "pewpew_firedamage_"..TargetEntity:EntIndex()..CurTime()
	timer.Create( timername, 0.1, Duration*10, function( TargetEntity, DPS, timername ) 
		-- Damage
		pewpew:DealDamageBase( TargetEntity, DPS/10 )
		-- Auto remove timer if dead
		if (!TargetEntity or !TargetEntity:IsValid()) then timer.Remove( timername ) end
	end, TargetEntity, DPS, timername )
end

------------------------------------------------------------------------------------------------------------
-- Base Code

-- Base code for dealing damage
function pewpew:DealDamageBase( TargetEntity, Damage )
		if (!self.Damage) then return end
	-- Check for errors
	if (!self:CheckValid( TargetEntity )) then return end
	if (!TargetEntity.pewpew) then TargetEntity.pewpew = {} end
	if (!Damage or Damage == 0) then return end
	-- Check if allowed
	if (!self:CheckNeverEverList( TargetEntity )) then return end
	if (!self:CheckAllowed( TargetEntity )) then
		local temp = constraint.GetAllConstrainedEntities( TargetEntity )
		local OldEnt = TargetEntity
		for _, ent in pairs( temp ) do
			if (self:CheckAllowed( ent )) then
				TargetEntity = ent
				break
			end
		end
	end
	Damage = Damage * self.DamageMul
	if (!TargetEntity.pewpew.Health) then
		self:SetHealth( TargetEntity )
	end
	-- Check if the entity has too much health (if the player changed the mass to something huge then back again)
	local phys = TargetEntity:GetPhysicsObject()
	if (!phys:IsValid()) then return end
	local mass = phys:GetMass() or 0
	--local boxsize = TargetEntity:OBBMaxs() - TargetEntity:OBBMins()
	local volume = phys:GetVolume() / 1000
	if (TargetEntity.pewpew.Health > mass / 5 + volume) then
		TargetEntity.pewpew.Health = (mass / 5 + volume) * (mass/TargetEntity.pewpew.MaxMass)
	end
	-- Check if the entity has a core
	if (TargetEntity.pewpew.Core and self:CheckValid(TargetEntity.pewpew.Core)) then
		self:DamageCore( TargetEntity.pewpew.Core, Damage )
		return
	end
	if (self.CoreDamageOnly) then return end
	-- Deal damage
	TargetEntity.pewpew.Health = TargetEntity.pewpew.Health - math.abs(Damage)
	TargetEntity:SetNWInt("pewpewHealth",TargetEntity.pewpew.Health)
	self:CheckIfDead( TargetEntity )
end

------------------------------------------------------------------------------------------------------------
-- Core

-- Dealing damage to cores
function pewpew:DamageCore( ent, Damage )
	if (!self:CheckValid( ent )) then return end
	if (!ent.pewpew) then ent.pewpew = {} end
	if (ent:GetClass() != "pewpew_core") then return end
	ent.pewpew.CoreHealth = ent.pewpew.CoreHealth - math.abs(Damage) * self.CoreDamageMul
	ent:SetNWInt("pewpewHealth",ent.pewpew.CoreHealth)
	-- Wire Output
	Wire_TriggerOutput( ent, "Health", ent.pewpew.CoreHealth or 0 )
	self:CheckIfDeadCore( ent )
end

-- Repairs the entity by the set amount
function pewpew:RepairCoreHealth( ent, amount )
	-- Check for errors
	if (!self:CheckValid( ent )) then return end
	if (!ent.pewpew) then ent.pewpew = {} end
	if (ent:GetClass() != "pewpew_core") then return end
	if (!ent.pewpew.CoreHealth or !ent.pewpew.CoreMaxHealth) then return end
	if (!amount or amount == 0) then return end
	-- Add health
	ent.pewpew.CoreHealth = math.Clamp(ent.pewpew.CoreHealth+math.abs(amount),0,ent.pewpew.CoreMaxHealth)
	ent:SetNWInt("pewpewHealth",ent.pewpew.CoreHealth or 0)
		-- Wire Output
	Wire_TriggerOutput( ent, "Health", ent.pewpew.CoreHealth or 0 )
end

function pewpew:CheckIfDeadCore( ent )
	if (!ent.pewpew) then ent.pewpew = {} return end
	if (ent.pewpew.CoreHealth <= 0) then
		ent:RemoveAllProps()
	end	
end

------------------------------------------------------------------------------------------------------------
-- Health

-- Set the health of a spawned entity
function pewpew:SetHealth( ent )
	if (!self:CheckValid( ent )) then return end
	if (!ent.pewpew) then ent.pewpew = {} end
	local phys = ent:GetPhysicsObject()
	if (!phys:IsValid()) then return end
	local mass = phys:GetMass() or 0
	local volume = 0
	if (!phys:GetVolume()) then volume = 100 end
	volume = phys:GetVolume() / 1000
	local health = mass / 5 + volume
	ent.pewpew.Health = health
	ent.pewpew.MaxMass = mass
	ent:SetNWInt("pewpewHealth",health)
	ent:SetNWInt("pewpewMaxHealth",health)
end

-- Repairs the entity by the set amount
function pewpew:RepairHealth( ent, amount )
	-- Check for errors
	if (!self:CheckValid( ent )) then return end
	if (!self:CheckAllowed( ent )) then return end
	if (!ent.pewpew) then ent.pewpew = {} end
	if (!ent.pewpew.Health or !ent.MaxMass) then return end
	if (!amount or amount == 0) then return end
	-- Get the max allowed health
	local phys = ent:GetPhysicsObject()
	if (!phys:IsValid()) then return end
	local mass = phys:GetMass() or 0
	--local boxsize = TargetEntity:OBBMaxs() - TargetEntity:OBBMins()
	local volume = phys:GetVolume() / 1000
	local maxhealth = (mass / 5 + volume)
	-- Add health
	ent.pewpew.Health = math.Clamp(ent.pewpew.Health+math.abs(amount),0,maxhealth)
	-- Make the health changeable again with weight tool
	if (ent.pewpew.Health == maxhealth) then
		ent.pewpew.Health = nil
		ent.pewpew.MaxMass = nil
	end
	ent:SetNWInt("pewpewHealth",ent.pewpew.Health or 0)
	ent:SetNWInt("pewpewMaxHealth",maxhealth or 0)
end

-- Returns the health of the entity without setting it
function pewpew:GetHealth( ent )
	if (!self:CheckValid( ent )) then return end
	if (!self:CheckAllowed( ent )) then return end
	if (!ent.pewpew) then ent.pewpew = {} end
	local phys = ent:GetPhysicsObject()
	if (!phys:IsValid()) then return end
	local mass = phys:GetMass() or 0
	--local boxsize = TargetEntity:OBBMaxs() - TargetEntity:OBBMins()
	local volume = phys:GetVolume() / 1000
	if (ent.pewpew.Health) then
		-- Check if the entity has too much health (if the player changed the mass to something huge then back again)
		if (ent.pewpew.Health > mass / 5 + volume) then
			return (mass / 5 + volume) * (mass/ent.pewpew.MaxMass)
		end
		return ent.pewpew.Health
	else
		return (mass / 5 + volume)
	end
end

------------------------------------------------------------------------------------------------------------
-- Checks

-- Check if the entity should be removed
function pewpew:CheckIfDead( ent )
	if (!ent.pewpew) then ent.pewpew = {} end
	if (ent.pewpew.Health <= 0) then
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

function pewpew:CheckNeverEverList( entity )
	for _, str in pairs( self.NeverEverList ) do
		if (entity:GetClass() == str) then return false end
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
	if ( (ply:IsValid() and ply:IsAdmin()) or !ply:IsValid() ) then
		if (!arg[1]) then return end
		local bool = false
		if (tonumber(arg[1]) != 0) then bool = true end
		pewpew.Damage = bool
		local name = "Console"
		if (ply:IsValid()) then name = ply:Nick() end
		local msg = " has changed PewPew Damage and it is now "
		if (pewpew.Damage) then
			for _, v in pairs( player.GetAll() ) do
				v:ChatPrint( name .. msg .. "ON!")
			end
		else
			for _, v in pairs( player.GetAll() ) do
				v:ChatPrint( name .. msg .. "OFF!")
			end
		end
	end
end
concommand.Add("PewPew_ToggleDamage", ToggleDamage)

-- Toggle Firing
local function ToggleFiring( ply, command, arg )
	if ( (ply:IsValid() and ply:IsAdmin()) or !ply:IsValid() ) then
		if (!arg[1]) then return end
		local bool = false
		if (tonumber(arg[1]) != 0) then bool = true end
		pewpew.Firing = bool
		local name = "Console"
		if (ply:IsValid()) then name = ply:Nick() end
		local msg = " has changed PewPew Firing and it is now "
		if (pewpew.Firing) then
			for _, v in pairs( player.GetAll() ) do
				v:ChatPrint( name .. msg .. "ON!")
			end
		else
			for _, v in pairs( player.GetAll() ) do
				v:ChatPrint( name .. msg .. "OFF!")
			end
		end
	end
end
concommand.Add("PewPew_ToggleFiring", ToggleFiring)

-- Toggle Numpads
local function ToggleNumpads( ply, command, arg )
	if ( (ply:IsValid() and ply:IsAdmin()) or !ply:IsValid() ) then
		if (!arg[1]) then return end
		local bool = false
		if (tonumber(arg[1]) != 0) then bool = true end
		pewpew.Numpads = bool
		local name = "Console"
		if (ply:IsValid()) then name = ply:Nick() end
		local msg = " has changed PewPew Numpads and they are now "
		if (pewpew.Numpads) then
			for _, v in pairs( player.GetAll() ) do
				v:ChatPrint( name .. msg .. "ENABLED!")
			end
		else
			for _, v in pairs( player.GetAll() ) do
				v:ChatPrint( name .. msg .. "DISABLED!")
			end
		end
	end
end
concommand.Add("PewPew_ToggleNumpads", ToggleNumpads)

-- Damage Multiplier
local function DamageMul( ply, command, arg )
	if ( (ply:IsValid() and ply:IsAdmin()) or !ply:IsValid() ) then
		if ( !arg[1] ) then return end
		pewpew.DamageMul = math.max( arg[1], 0.01 )
		local name = "Console"
		local msg = " has changed the PewPew Damage Multiplier to "
		if (ply:IsValid()) then name = ply:Nick() end
		for _, v in pairs( player.GetAll() ) do
			v:ChatPrint( name .. msg .. pewpew.DamageMul)
		end
	end
end
concommand.Add("PewPew_DamageMul",DamageMul)

-- Damage Multiplier vs cores
local function CoreDamageMul( ply, command, arg )
	if ( (ply:IsValid() and ply:IsAdmin()) or !ply:IsValid() ) then
		if ( !arg[1] ) then return end
		pewpew.CoreDamageMul = math.max( arg[1], 0.01 )
		local name = "Console"
		local msg = " has changed the PewPew Core Damage Multiplier to "
		if (ply:IsValid()) then name = ply:Nick() end
		for _, v in pairs( player.GetAll() ) do
			v:ChatPrint( name .. msg .. pewpew.CoreDamageMul)
		end
	end
end
concommand.Add("PewPew_CoreDamageMul",CoreDamageMul)

-- Core Damage only
local function ToggleCoreDamageOnly( ply, command, arg )
	if ( (ply:IsValid() and ply:IsAdmin()) or !ply:IsValid() ) then
		if (!arg[1]) then return end
		local bool = false
		if (tonumber(arg[1]) != 0) then bool = true end
		pewpew.CoreDamageOnly = bool
		local name = "Console"
		if (ply:IsValid()) then name = ply:Nick() end
		local msg = " has changed PewPew Core Damage Only and it is now "
		if (pewpew.CoreDamageOnly) then
			for _, v in pairs( player.GetAll() ) do
				v:ChatPrint( name .. msg .. "ON!")
			end
		else
			for _, v in pairs( player.GetAll() ) do
				v:ChatPrint( name .. msg .. "OFF!")
			end
		end
	end
end
concommand.Add("PewPew_ToggleCoreDamageOnly", ToggleCoreDamageOnly)

-- Repair tool rate
local function RepairToolHeal( ply, command, arg )
	if ( (ply:IsValid() and ply:IsAdmin()) or !ply:IsValid() ) then
		if ( !arg[1] ) then return end
		pewpew.RepairToolHeal = math.max( arg[1], 20 )
		local name = "Console"
		if (ply:IsValid()) then name = ply:Nick() end
		local msg = " has changed the speed at which the Repair Tool heals to "
		for _, v in pairs( player.GetAll() ) do
			v:ChatPrint( name .. msg .. pewpew.RepairToolHeal)
		end
	end
end
concommand.Add("PewPew_RepairToolHeal",RepairToolHeal)

-- Repair tool rate vs cores
local function RepairToolHealCores( ply, command, arg )
	if ( (ply:IsValid() and ply:IsAdmin()) or !ply:IsValid() ) then
		if ( !arg[1] ) then return end
		pewpew.RepairToolHealCores = math.max( arg[1], 20 )
		local name = "Console"
		if (ply:IsValid()) then name = ply:Nick() end
		local msg = " has changed the speed at which the Repair Tool heals cores to "
		for _, v in pairs( player.GetAll() ) do
			v:ChatPrint( name .. msg .. pewpew.RepairToolHealCores)
		end
	end
end
concommand.Add("PewPew_RepairToolHealCores",RepairToolHealCores)

-- Toggle Life Support
local function ToggleEnergyUsage( ply, command, arg )
	if ( (ply:IsValid() and ply:IsAdmin()) or !ply:IsValid() ) then
		if (CAF and CAF.GetAddon("Resource Distribution") and CAF.GetAddon("Life Support")) then
			if (!arg[1]) then return end
			local bool = false
			if (tonumber(arg[1]) != 0) then bool = true end
			pewpew.EnergyUsage = bool
			local name = "Console"
			if (ply:IsValid()) then name = ply:Nick() end
			local msg = " has changed PewPew Energy Usage and it is now "
			if (pewpew.EnergyUsage) then
				for _, v in pairs( player.GetAll() ) do
					v:ChatPrint( name .. msg .. "ENABLED!")
				end
			else
				for _, v in pairs( player.GetAll() ) do
					v:ChatPrint( name .. msg .. "DISABLED!")
				end
			end
		else
			local name = "Console"
			if (ply:IsValid()) then name = ply:Nick() end
			local msg = " tried to enable PewPew Energy Usage, but the server does not have the required addons (Spacebuild 3 & co.)!"
			for _, v in pairs( player.GetAll() ) do
				v:ChatPrint( name .. msg )
			end
		end
	end
end
concommand.Add("PewPew_ToggleEnergyUsage", ToggleEnergyUsage)
		