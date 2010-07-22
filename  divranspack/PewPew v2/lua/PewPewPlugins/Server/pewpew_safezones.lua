-- Pewpew Safe Zones
-- These functions add safe zones
------------------------------------------------------------------------------------------------------------

-- Damage Blocked Table
pewpew.SafeZones = {}

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
	elseif (type(In) == "Entity") then
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
	elseif (type(In) == "Entity") then
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

-- Used below...
local function check( ... )
	for k,v in pairs( {...} ) do
		if (type(v) == "Entity" and v and v:IsValid()) then
			if (pewpew:FindSafeZone(v:GetPos())) then return false end
		end
	end
end

-- Block damage from being dealt if the damage dealer is inside a safe zone
function pewpew:BlockInitBlastDamage(a,b,c,d,e,DamageDealer)
	return check(DamageDealer)
end
hook.Add("PewPew_InitBlastDamage","PewPew_SafeZone_InitBlastDamage",pewpew.BlockInitBlastDamage)

-- Block damage from being dealt if the damaged prop is inside a safe zone
function pewpew:BlockBlastDamage( ent )
	return check(ent)
end
hook.Add("PewPew_ShouldDoBlastDamage","PewPew_SafeZone_BlastDamage",pewpew.BlockBlastDamage)

-- Block slice damage from being dealt if the damage dealer is inside a safe zone
function pewpew:BlockInitSliceDamage( a,b,c,d,e,f,DamageDealer )
	return check(DamageDealer)
end
hook.Add("PewPew_InitSliceDamage","PewPew_SafeZone_SliceDamage",pewpew.BlockInitSliceDamage)

-- Block emp damage from being dealt if the damaged prop is inside a safe zone
function pewpew:BlockEMPDamage( ent,a,b,DamageDealer )
	return check(ent,DamageDealer)
end
hook.Add("PewPew_ShouldDoEMPDamage","PewPew_SafeZone_EMPDamage",pewpew.BlockEMPDamage)

function pewpew:BlockPointDamage( TargetEntity,Damage,DamageDealer )
	return check(TargetEntity,DamageDealer)
end
hook.Add("PewPew_ShouldDoPointDamage","PewPew_SafeZone_PointDamage",pewpew.BlockPointDamage)

function pewpew:BlockFireDamage( TargetEntity,a,b,DamageDealer )
	return check(TargetEntity,DamageDealer)
end
hook.Add( "PewPew_ShouldDoFireDamage","PewPew_SafeZone_FireDamage",pewpew.BlockFireDamage)

function pewpew:BlockDamage( TargetEntity, Damage, DamageDealer )
	return check(TargetEntity,DamageDealer)
end
hook.Add("PewPew_ShouldDamage","PewPew_SafeZone_BaseDamage",pewpew.BlockDamage)