local v = _R.Vector
local Length = v.Length
local Dot = v.Dot
local sqrt = math.sqrt

local function RaySphereIntersection( Start, Dir, Pos, Radius ) -- Thanks to Feha
	local A = 2 * Length(Dir)^2
	local B = 2 * Dot(Dir,Start - Pos)
	local C = Length(Pos)^2 + Length(Start)^2 - 2 * Dot(Pos,Start) - Radius^2
	local BAC4 = B^2-(2*A*C)
	if (BAC4 >= 0 and B < 0) then
		return Start + ((-sqrt(BAC4) - B) / A)*Dir
	end
end

local function RayPlaneIntersection( Start, Dir, Pos, Normal ) -- Thanks to Feha
	local A = Dot(Normal, Dir)
	if (A < 0) then
		local B = Dot(Normal, Pos-Start)
		if (B < 0) then
			return (Start + Dir * (B/A))
		end
	elseif (A == 0) then
		if (Dot(Normal, Pos-Start) == 0) then
			return Start
		end
	end
	
	return false
end

local function RayCircleIntersection( Start, Dir, Pos, Normal, Radius )
	local HitPos = RayPlaneIntersection( Start, Dir, Pos, Normal )
	if (HitPos) then
		local Dist = Length(Pos-HitPos)
		if (Dist < Radius) then return HitPos, Dist end
	end
	return false
end

function pewpew:Trace( pos, dir, filter, Bullet ) -- Bullet arg is only necessary for Stargate Event Horizons. It's made to work for bullets, but can be used for lasors as well.
	if (StarGate) then -- If Stargate is installed
	
		--[[ Check for EH
		if (Bullet) then
			for k,v in ipairs( pewpew.SGGates ) do
				if (v and ValidEntity( v ) and v:IsOpen() and !v.ShuttingDown) then -- if open
					local hit, _ = RayCircleIntersection( pos, dir, v:LocalToWorld(v:OBBCenter()), v:GetForward(), 103 ) -- I got 103 using some E2 code
					if (hit) then
						local newpos, newdir = v:TeleportVectorWithEffect( hit, dir:GetNormalized() )
						Bullet.Pos = newpos
						Bullet.Vel = newdir * dir:Length()
						pos = newpos
						dir = newdir
						if (!filter) then filter = {} elseif (type(filter) == "Entity") then filter = {filter} end
						filter[#filter+1] = v
					end
				end
			end
		end]]
	
		if (SERVER) then
			local trace = StarGate.Trace:New( pos, dir, filter )
			
			trace.HitShield = false
			
			if (trace.Hit and trace.Entity and trace.Entity:IsValid()) then
				if (trace.Entity:GetClass() == "shield") then
					local HitPos = RaySphereIntersection( trace.HitPos, dir, trace.Entity:GetPos(), trace.Entity:GetNWInt("size",0) )
					if (HitPos) then
						trace.HitPos = HitPos
						trace.HitNormal = (HitPos - trace.Entity:GetPos()):GetNormal()
						trace.HitShield = true
						return trace
					else
						if (filter and type(filter) == "Entity") then
							filter = { filter }
						elseif (!filter) then 
							filter = {} 
						end
						
						filter[#filter+1] = trace.Entity
						--table.insert( filter, trace.Entity )
						return self:Trace( trace.HitPos, dir, filter )
					end
				elseif (trace.Entity:GetClass() == "event_horizon") then
					if (trace.Entity:GetParent() and string.find(trace.Entity:GetParent():GetClass(),"stargate_") and Bullet) then
						local newpos, newdir = trace.Entity:TeleportVectorWithEffect( trace.HitPos, dir )
						--print("pos: " .. tostring(pos))
						--print("dir: " .. tostring(dir))
						--print("newpos: " .. tostring(newpos))
						--print("newdir: " .. tostring(newdir))
						Bullet.Pos = newpos
						Bullet.Vel = newdir-- * dir:Length()
						pos = newpos
						dir = newdir
						if (!filter) then filter = {} elseif (type(filter) == "Entity") then filter = {filter} end
						filter[#filter+1] = trace.Entity
						filter[#filter+1] = trace.Entity:GetParent()
						filter[#filter+1] = trace.Entity:GetParent().Target
						filter[#filter+1] = trace.Entity:GetParent().Target.EventHorizon
						return self:Trace( pos, dir, filter, Bullet )
					end
				end
			end
			
			return trace		
		else
			for k,v in ipairs( pewpew.SGShields ) do
				if (v and ValidEntity( v ) and !v:GetNWBool("depleted", false) and !v:GetNWBool("containment",false)) then
					local HitPos = RaySphereIntersection( pos, dir, v:GetPos(), v:GetNWInt("size",1) )
					if (HitPos and pos:Distance(HitPos) <= dir:Length()) then
						local ret = {}
						ret.HitPos = HitPos
						ret.Hit = true
						ret.HitNormal = (HitPos - v:GetPos()):GetNormal()
						ret.Entity = v
						return ret
					end
				end
			end
			
			-- If no SG shield was hit, go on with a regular trace..
			local tr = {}
			tr.start = pos
			tr.endpos = pos + dir
			tr.filter = filter
			return util.TraceLine( tr )
		end
	else -- If Stargate isn't installed
		local tr = {}
		tr.start = pos
		tr.endpos = pos + dir
		tr.filter = filter
		return util.TraceLine( tr )
	end
	
end

-- Keep track of stargate shields and gates. Used for the pewpew trace to remove bullets at the right time and check for EHs.
if (CLIENT) then
	pewpew.SGShields = {}

	hook.Add("OnEntityCreated","PewPew_StargateShield_Spawn",function( ent )
		if (ent and ValidEntity( ent )) then
			if (ent:GetClass() == "shield") then
				pewpew.SGShields[#pewpew.SGShields+1] = ent
			end
		end
	end)

	hook.Add("OnEntityRemoved","PewPew_StargateShield_Remove",function( ent )
		if (ent:GetClass() == "shield") then
			for k,v in ipairs( pewpew.SGShields ) do
				if (v == ent) then
					table.remove( pewpew.SGShields, k )
					return
				end
			end
		end
	end)
end