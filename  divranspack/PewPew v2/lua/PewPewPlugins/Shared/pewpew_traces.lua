local function RaySphereIntersection( Start, Dir, Pos, Radius ) -- Thanks to Feha
	Dir = Dir:GetNormal()
	local A = Start + Dir
	local B = Dir:Dot(Pos-Start) / Dir:Dot(A-Start)
	local HitPos = Start + (A - Start) * B
	if (HitPos and B > 0) then
		local Dist = Pos:Distance(HitPos)
		if (Dist < Radius) then
			HitPos = HitPos - Dir * math.sqrt(Radius ^ 2 - Dist ^ 2)
			return HitPos
		end
	end
	return false
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