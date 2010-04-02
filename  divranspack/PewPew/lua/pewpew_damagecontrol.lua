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

-- Damage Blocked Table
pewpew.SafeZones = {}

-- Damage Log
pewpew.DamageLog = {}
pewpew.DamageLogSend = true

------------------------------------------------------------------------------------------------------------

-- Blast Damage (A normal explosion)  (The damage formula is "clamp(Damage - (distance * RangeDamageMul), 0, Damage)")
function pewpew:BlastDamage( Position, Radius, Damage, RangeDamageMul, IgnoreEnt, DamageDealer )
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
					self:DealDamageBase( ent, dmg, DamageDealer )
				end
			else
				distance = Position:Distance( ent:GetPos() )
				dmg = math.Clamp(Damage - (distance * RangeDamageMul), 0, Damage)
				if (ent.Core and ent.Core:IsValid()) then dmg = dmg / 2 end
				self:DealDamageBase( ent, dmg, DamageDealer )
			end
		end
	end
end

-- Point Damage - (Deals damage to 1 single entity)
function pewpew:PointDamage( TargetEntity, Damage, DamageDealer )
	if (!self.Damage) then return end
	if (TargetEntity:IsPlayer()) then
		if (DamageDealer and DamageDealer:IsValid()) then
			TargetEntity:TakeDamage( Damage, DamageDealer )
		end
	else
		self:DealDamageBase( TargetEntity, Damage, DamageDealer )
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
					self:DealDamageBase( HitEnt, Damage, DamageDealer ) -- Deal damage to entities
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

-- Defense Damage (Used to destroy PewPew bullets. Each PewPew Bullet has 100 health.)
function pewpew:DefenseDamage( TargetEntity, Damage )
	-- Check for errors
	if (!TargetEntity or TargetEntity:GetClass() != "pewpew_base_bullet" or !Damage or Damage == 0 or !TargetEntity.Bullet) then return end
	-- Does it have health?
	if (!TargetEntity.pewpewHealth) then TargetEntity.pewpewHealth = 100 end
	
	-- Damage
	TargetEntity.pewpewHealth = TargetEntity.pewpewHealth - Damage
	-- Did it die?
	if (TargetEntity.pewpewHealth <= 0) then
		if (TargetEntity.Bullet.ExplodeAfterDeath and TargetEntity.Bullet.ExplodeAfterDeath == true) then
			TargetEntity:Explode()
		else
			TargetEntity:Remove()
		end
	end
end

------------------------------------------------------------------------------------------------------------
-- Base Code

-- Base code for dealing damage
function pewpew:DealDamageBase( TargetEntity, Damage, DamageDealer )
		if (!self.Damage) then return end
	-- Check for errors
	if (!Damage or Damage == 0) then return end
	if (!self:CheckValid( TargetEntity )) then return end
	-- Check if allowed
	if (self:FindSafeZone( TargetEntity:GetPos() )) then return end
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
	if (!TargetEntity.pewpewHealth) then
		self:SetHealth( TargetEntity )
	end
	-- Check if the entity has too much health
	self:ReduceHealth( TargetEntity )
	-- Check if the entity has a core
	if (TargetEntity.pewpew.Core and self:CheckValid(TargetEntity.pewpew.Core)) then
		self:DamageCore( TargetEntity.pewpew.Core, Damage )
		return
	end
	if (self.CoreDamageOnly) then return end
	-- Deal damage
	TargetEntity.pewpewHealth = TargetEntity.pewpewHealth - math.abs(Damage)
	TargetEntity:SetNWInt("pewpewHealth",TargetEntity.pewpewHealth)
	self:CheckIfDead( TargetEntity )
	
	-- Damage Log
	pewpew:DamageLogAdd( TargetEntity, Damage, DamageDealer )
end

------------------------------------------------------------------------------------------------------------
-- Damage Log

function pewpew:DamageLogAdd( TargetEntity, Damage, DamageDealer )
	Damage = Damage or "- Error -"
	
	local DealerName
	if (DamageDealer and DamageDealer.Owner) then
		DealerName = DamageDealer.Owner:Nick() or "- Error -"
	else
		DealerName = "- Error -"
	end
	
	local Weapon
	if (DamageDealer and DamageDealer.Bullet) then
		Weapon = DamageDealer.Bullet.Name or "- Error -"
	else
		Weapon = "- Error -"
	end
	
	local Victim
	local VictimName
	if (CPPI) then
		if (TargetEntity and TargetEntity:CPPIGetOwner()) then
			Victim = TargetEntity:CPPIGetOwner()
			VictimName = TargetEntity:CPPIGetOwner():Nick() or "- Error -"
		else
			VictimName = "- Error -"
		end
	else
		VictimName = "- CPPI Not Installed -"
	end
	
	local DiedB = false
	if (self:GetHealth( TargetEntity ) < Damage) then
		DiedB = true
	end
	
	local Time = os.date( "%c", os.time() )
	
	local Nr = #self.DamageLog
	if (Nr > 0 and self.DamageLog[Nr] and self.DamageLog[Nr][2] and self.DamageLog[Nr][2] == TargetEntity:EntIndex()) then
		self.DamageLog[Nr][1] = Time
		local add = 0
		if (self.DamageLog[Nr] and self.DamageLog[Nr][3]) then
			add = self.DamageLog[Nr][3]
		end
		self.DamageLog[Nr][3] = Damage + add
		self.DamageLog[Nr][4] = DealerName
		self.DamageLog[Nr][6] = DiedB
		if (self.DamageLogSend) then
			umsg.Start( "PewPew_Admin_Tool_SendLog_Umsg" )
				umsg.Short(Nr)
				umsg.String(Time)
				umsg.Long(math.Round(self.DamageLog[Nr][3]))
				umsg.String(DealerName)
				umsg.Bool(DiedB)
			umsg.End()
			--datastream.StreamToClients( player.GetAll(), "PewPew_Admin_Tool_SendLog", { Nr, Time, math.Round(self.DamageLog[Nr][3]), DealerName, Died } )
		end
		if (DiedB) then
			timer.Simple(0.1,function()
				pewpew.DamageLog[Nr][2] = "- Died -"
			end)
		end
	else
		local ID = TargetEntity:EntIndex()
		if (DiedB) then ID = "- Died -" end
		local tbl = { Time, ID, math.Round(Damage), DealerName, VictimName, DiedB } 
		table.insert( self.DamageLog, tbl )
		if (self.DamageLogSend) then
			umsg.Start( "PewPew_Admin_Tool_SendLog_Umsg" )
				umsg.Short(-1)
				umsg.String(Time)
				umsg.Short(TargetEntity:EntIndex())
				umsg.Long(math.Round(Damage))
				umsg.String(DealerName)
				umsg.String(VictimName)
				umsg.Bool(DiedB)
			umsg.End()
			--datastream.StreamToClients( player.GetAll(), "PewPew_Admin_Tool_SendLog", { false, tbl } )
		end
	end
	
	if (Nr > 150) then
		table.remove( self.DamageLog )
	end
	
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
	local health = self:GetHealth( ent )
	ent.pewpewHealth = health
	ent.pewpewMaxMass = mass
	ent:SetNWInt("pewpewHealth",health)
	ent:SetNWInt("pewpewMaxHealth",health)
end

-- Repairs the entity by the set amount
function pewpew:RepairHealth( ent, amount )
	-- Check for errors
	if (!self:CheckValid( ent )) then return end
	if (!self:CheckAllowed( ent )) then return end
	if (!ent.pewpew) then ent.pewpew = {} end
	if (!ent.pewpewHealth or !ent.pewpewMaxMass) then return end
	if (!amount or amount == 0) then return end
	-- Get the max allowed health
	local maxhealth = self:GetMaxHealth( ent )
	-- Add health
	ent.pewpewHealth = math.Clamp(ent.pewpewHealth+math.abs(amount),0,maxhealth)
	-- Make the health changeable again with weight tool
	if (ent.pewpewHealth == maxhealth) then
		ent.pewpewHealth = nil
		ent.pewpewMaxMass = nil
	end
	ent:SetNWInt("pewpewHealth",ent.pewpewHealth or 0)
	ent:SetNWInt("pewpewMaxHealth",maxhealth or 0)
end

-- Returns the health of the entity without setting it
function pewpew:GetHealth( ent )
	if (!self:CheckValid( ent )) then return 0 end
	if (!self:CheckAllowed( ent )) then return 0 end
	if (!ent.pewpew) then ent.pewpew = {} end
	local phys = ent:GetPhysicsObject()
	if (!phys:IsValid()) then return 0 end
	local mass = phys:GetMass() or 0
	local volume = phys:GetVolume() / 1000
	if (ent.pewpewHealth) then
		-- Check if the entity has too much health (if the player changed the mass to something huge then back again)
		if (ent.pewpewHealth > mass / 5 + volume) then
			return (mass / 5 + volume) * (mass/ent.pewpewMaxMass)
		end
		return ent.pewpewHealth
	else
		return (mass / 5 + volume)
	end
end

-- Returns the maximum health of the entity without setting it
function pewpew:GetMaxHealth( ent )
	if (!self:CheckValid( ent )) then return 0 end
	if (!self:CheckAllowed( ent )) then return 0 end
	local phys = ent:GetPhysicsObject()
	if (!phys:IsValid()) then return 0 end
	local volume = phys:GetVolume() / 1000
	local mass = phys:GetMass() or 0
	if (ent.pewpewMaxMass) then
		if (mass >= ent.pewpewMaxMass) then
			return ent.pewpewMaxMass / 5 + volume
		else
			return (mass / 5 + volume) * (mass/ent.pewpewMaxMass)
		end
	else
		local mass = phys:GetMass() or 0
		return mass / 5 + volume
	end
end

-- Reduce the health if it's too much (if the player changed the mass to something huge then back again)
function pewpew:ReduceHealth( ent )
	if (!self:CheckValid( ent )) then return end
	if (!self:CheckAllowed( ent )) then return end
	if (!ent.pewpewHealth) then return end
	local maxhp = self:GetMaxHealth( ent )
	if (ent.pewpewHealth > maxhp) then
		ent.pewpewHealth = maxhp
		ent:SetNWInt("pewpewHealth",ent.pewpewHealth or 0)
		ent:SetNWInt("pewpewMaxHealth",maxhp or 0)
	end
end

------------------------------------------------------------------------------------------------------------
-- Checks

-- Check if the entity should be removed
function pewpew:CheckIfDead( ent )
	if (!ent.pewpew) then ent.pewpew = {} end
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
-- Damage Safe Zones

-- Add a Safe Zone. If you want to parent the safe zone to an entity, make sure the position is local.
function pewpew:AddSafeZone( Position, Radius, ParentEntity )
	if (!Position or !Radius) then 
		return 
	end
	table.insert( self.SafeZones, { Position, Radius, ParentEntity } )
end

-- Remove a Safe Zone. In can be a vector, number, or entity (if entity, it must be the entity the safe zone is "parented" to)
function pewpew:RemoveSafeZone( In )
	-- If the type is a vector
	if (type(In) == "vector") then
		-- Find the safe zone
		local bool, index = self:FindSafeZone( In )
		-- Found it?
		if (bool) then
			-- Remove it
			table.remove( self.SafeZones, index )
		else
			-- Notify
		end
	-- If the type is a number
	elseif (type(In) == "number") then
		-- Remove the safe zone
		if (self.SafeZones[In]) then
			table.remove( self.SafeZones, In )
		end
	elseif (type(In) == "entity") then
		for index,tbl in pairs( self.SafeZones ) do
			if (tbl[3]) then
				if (tbl[3]:IsValid()) then
					if (tbl[3] == In) then
						table.remove( self.SafeZones, index )
					end
				else
					self:RemoveSafeZone( index )
					return
				end
			end
		end
	end
end

-- Modify an already existing Safe Zone
function pewpew:ModifySafeZone( In, Position, Radius, ParentEntity )
	if (!Position or !Radius) then return end
	if (type(In) == "vector") then
		local bool, index = self:FindSafeZone( In )
		if (bool) then
			self.SafeZones[index] = { Position, Radius, ParentEntity }
		end
	elseif (type(In) == "number") then
		self.SafeZones[In] = { Position, Radius, ParentEntity }
	elseif (type(In) == "entity") then
		for index,tbl in pairs( self.SafeZones ) do
			if (tbl[3]) then
				if (tbl[3]:IsValid()) then
					if (tbl[3] == In) then
						self.SafeZones[index] = { Position, Radius, ParentEntity }
						return
					end
				else
					self:RemoveSafeZone( index )
					return
				end
			end
		end
	end
end

-- Check if a position is inside a Safe Zone
function pewpew:FindSafeZone( Position )
	for index,tbl in pairs( self.SafeZones ) do
		CheckPosition = tbl[1]
		-- Parented?
		if (tbl[3]) then
			-- Valid entity?
			if (tbl[3]:IsValid()) then
				CheckPosition = tbl[3]:LocalToWorld(CheckPosition)
			else
				self:RemoveSafeZone( index )
				return false, index
			end
		end
		-- Check distance
		if (Position:Distance(CheckPosition) <= tbl[2]) then
			return true, index
		end
	end
	return false, 0
end

------------------------------------------------------------------------------------------------------------
-- Other useful functions

-- FindInCone (Note: copied from E2 then edited)
 function pewpew:FindInCone( Pos, Dir, Dist, Degrees )
	local found = ents.FindInSphere( Pos, Dist )
	local ret = {}

	local cosDegrees = math.cos(math.rad(Degrees))
	
	for _, v in pairs( found ) do
		if (Dir:Dot( ( v:GetPos() - Pos):GetNormalized() ) > cosDegrees) then
			ret[#ret+1] = v
		end	
	end
	
	return ret	
end



------------------------------------------------------------------------------------------------------------
-- Toggle Damage
local function ToggleDamage( ply, command, arg )
	if ( (ply:IsValid() and ply:IsAdmin()) or !ply:IsValid() ) then
		if (!arg[1]) then return end
		local bool = false
		if (tonumber(arg[1]) != 0) then bool = true end
		local OldSetting = pewpew.Damage
		pewpew.Damage = bool
		local name = "Console"
		if (ply:IsValid()) then name = ply:Nick() end
		local msg = " has changed PewPew Damage and it is now "
		if (OldSetting != pewpew.Damage) then
			if (pewpew.Damage) then
				for _, v in pairs( player.GetAll() ) do
					v:ChatPrint( "[PewPew] " .. name .. msg .. "ON!")
				end
			else
				for _, v in pairs( player.GetAll() ) do
					v:ChatPrint( "[PewPew] " .. name .. msg .. "OFF!")
				end
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
		local OldSetting = pewpew.Firing
		pewpew.Firing = bool
		if (OldSetting != pewpew.Firing) then
			local name = "Console"
			if (ply:IsValid()) then name = ply:Nick() end
			local msg = " has changed PewPew Firing and it is now "
			if (pewpew.Firing) then
				for _, v in pairs( player.GetAll() ) do
					v:ChatPrint( "[PewPew] " .. name .. msg .. "ON!")
				end
			else
				for _, v in pairs( player.GetAll() ) do
					v:ChatPrint( "[PewPew] " .. name .. msg .. "OFF!")
				end
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
		local OldSetting = pewpew.Numpads
		pewpew.Numpads = bool
		if (OldSetting != pewpew.Numpads) then
			local name = "Console"
			if (ply:IsValid()) then name = ply:Nick() end
			local msg = " has changed PewPew Numpads and they are now "
			if (pewpew.Numpads) then
				for _, v in pairs( player.GetAll() ) do
					v:ChatPrint( "[PewPew] " .. name .. msg .. "ENABLED!")
				end
			else
				for _, v in pairs( player.GetAll() ) do
					v:ChatPrint( "[PewPew] " .. name .. msg .. "DISABLED!")
				end
			end
		end
	end
end
concommand.Add("PewPew_ToggleNumpads", ToggleNumpads)

-- Damage Multiplier
local function DamageMul( ply, command, arg )
	if ( (ply:IsValid() and ply:IsAdmin()) or !ply:IsValid() ) then
		if ( !arg[1] ) then return end
		local OldSetting = pewpew.DamageMul
		pewpew.DamageMul = math.max( arg[1], 0.01 )
		if (OldSetting != pewpew.DamageMul) then
			local name = "Console"
			local msg = " has changed the PewPew Damage Multiplier to "
			if (ply:IsValid()) then name = ply:Nick() end
			for _, v in pairs( player.GetAll() ) do
				v:ChatPrint( "[PewPew] " .. name .. msg .. pewpew.DamageMul)
			end
		end
	end
end
concommand.Add("PewPew_DamageMul",DamageMul)

-- Damage Multiplier vs cores
local function CoreDamageMul( ply, command, arg )
	if ( (ply:IsValid() and ply:IsAdmin()) or !ply:IsValid() ) then
		if ( !arg[1] ) then return end
		local OldSetting = pewpew.CoreDamageMul
		pewpew.CoreDamageMul = math.max( arg[1], 0.01 )
		if (OldSetting != pewpew.CoreDamageMul) then
			local name = "Console"
			local msg = " has changed the PewPew Core Damage Multiplier to "
			if (ply:IsValid()) then name = ply:Nick() end
			for _, v in pairs( player.GetAll() ) do
				v:ChatPrint( "[PewPew] " .. name .. msg .. pewpew.CoreDamageMul)
			end
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
		local OldSetting = pewpew.CoreDamageOnly
		pewpew.CoreDamageOnly = bool
		if (OldSetting != pewpew.CoreDamageOnly) then
			local name = "Console"
			if (ply:IsValid()) then name = ply:Nick() end
			local msg = " has changed PewPew Core Damage Only and it is now "
			if (pewpew.CoreDamageOnly) then
				for _, v in pairs( player.GetAll() ) do
					v:ChatPrint( "[PewPew] " .. name .. msg .. "ON!")
				end
			else
				for _, v in pairs( player.GetAll() ) do
					v:ChatPrint( "[PewPew] " .. name .. msg .. "OFF!")
				end
			end
		end
	end
end
concommand.Add("PewPew_ToggleCoreDamageOnly", ToggleCoreDamageOnly)

-- Repair tool rate
local function RepairToolHeal( ply, command, arg )
	if ( (ply:IsValid() and ply:IsAdmin()) or !ply:IsValid() ) then
		if ( !arg[1] ) then return end
		local OldSetting = pewpew.RepairToolHeal
		pewpew.RepairToolHeal = math.max( arg[1], 20 )
		if (OldSetting != pewpew.RepairToolHeal) then
			local name = "Console"
			if (ply:IsValid()) then name = ply:Nick() end
			local msg = " has changed the speed at which the Repair Tool heals to "
			for _, v in pairs( player.GetAll() ) do
				v:ChatPrint( "[PewPew] " .. name .. msg .. pewpew.RepairToolHeal)
			end
		end
	end
end
concommand.Add("PewPew_RepairToolHeal",RepairToolHeal)

-- Repair tool rate vs cores
local function RepairToolHealCores( ply, command, arg )
	if ( (ply:IsValid() and ply:IsAdmin()) or !ply:IsValid() ) then
		if ( !arg[1] ) then return end
		local OldSetting = pewpew.RepairToolHealCores
		pewpew.RepairToolHealCores = math.max( arg[1], 20 )
		if (OldSetting != pewpew.RepairToolHealCores) then
			local name = "Console"
			if (ply:IsValid()) then name = ply:Nick() end
			local msg = " has changed the speed at which the Repair Tool heals cores to "
			for _, v in pairs( player.GetAll() ) do
				v:ChatPrint( "[PewPew] " .. name .. msg .. pewpew.RepairToolHealCores)
			end
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
			local OldSetting = pewpew.EnergyUsage
			pewpew.EnergyUsage = bool
			if (OldSetting != pewpew.EnergyUsage) then
				local name = "Console"
				if (ply:IsValid()) then name = ply:Nick() end
				local msg = " has changed PewPew Energy Usage and it is now "
				if (pewpew.EnergyUsage) then
					for _, v in pairs( player.GetAll() ) do
						v:ChatPrint( "[PewPew] " .. name .. msg .. "ENABLED!")
					end
				else
					for _, v in pairs( player.GetAll() ) do
						v:ChatPrint( "[PewPew] " .. name .. msg .. "DISABLED!")
					end
				end
			end
		elseif (arg[1] != "0") then
			local msg = "You cannot enable Energy Usage, because the server does not have the required addons (Spacebuild 3 & co.)!"
			ply:ChatPrint( "[PewPew] " .. msg )
		end
	end
end
concommand.Add("PewPew_ToggleEnergyUsage", ToggleEnergyUsage)

-- Send Damage Log
local function ToggleDamageLog( ply, command, arg )
	if ( (ply:IsValid() and ply:IsAdmin()) or !ply:IsValid() ) then
		if (!arg[1]) then return end
		local bool = false
		if (tonumber(arg[1]) != 0) then bool = true end
		local OldSetting = pewpew.DamageLogSend
		pewpew.DamageLogSend = bool
		if (OldSetting != pewpew.DamageLogSend) then
			local name = "Console"
			if (ply:IsValid()) then name = ply:Nick() end
			local msg = " has changed Damage Log Sending and it is now "
			if (pewpew.DamageLogSend) then
				for _, v in pairs( player.GetAll() ) do
					v:ChatPrint( "[PewPew] " .. name .. msg .. "ON!")
				end
				datastream.StreamToClients( ply, "PewPew_Admin_Tool_SendLog", { true, pewpew.DamageLog } )
			else
				for _, v in pairs( player.GetAll() ) do
					v:ChatPrint( "[PewPew] " .. name .. msg .. "OFF!")
				end
			end
		end
	end
end
concommand.Add("PewPew_ToggleDamageLogSending", ToggleDamageLog)