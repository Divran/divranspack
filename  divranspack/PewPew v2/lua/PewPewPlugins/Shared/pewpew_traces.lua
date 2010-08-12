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

function pewpew:Trace( pos, dir, filter )
	if (StarGate and StarGate.Trace) then -- If Stargate is installed
		local trace = StarGate.Trace:New( pos, dir, filter )
		
		trace.HitShield = false
		
		if (trace.Hit and trace.Entity and trace.Entity:IsValid() and trace.Entity:GetClass() == "shield") then
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
				
				table.insert( filter, trace.Entity )
				return self:Trace( trace.HitPos, dir, filter )
			end
		end
		
		return trace		
	else -- If Stargate isn't installed
		local tr = {}
		tr.start = pos
		tr.endpos = pos + dir
		tr.filter = filter
		return util.TraceLine( tr )
	end
	
end