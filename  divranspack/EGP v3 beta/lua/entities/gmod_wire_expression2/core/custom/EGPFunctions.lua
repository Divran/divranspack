local ID

local function Update( self, this )
	self.data.EGP[this] = true
end

__e2setcost(35)

--------------------------------------------------------
-- Box
--------------------------------------------------------
e2function void wirelink:egpBox( number index, vector2 size, vector2 pos )
	local bool, obj = EGP:CreateObject( this, EGP.Objects.Names["Box"], { index = index, w = size[1], h = size[2], x = pos[1], y = pos[2] } )
	if (bool) then Update(self,this) end
end

e2function void wirelink:egpBox( number index, vector2 size, vector2 pos, vector4 color )
	local bool, obj = EGP:CreateObject( this, EGP.Objects.Names["Box"], { index = index, w = size[1], h = size[2], x = pos[1], y = pos[2], r = color[1], g = color[2], b = color[3], a = color[4] } )
	if (bool) then Update(self,this) end
end

--------------------------------------------------------
-- Text
--------------------------------------------------------
e2function void wirelink:egpText( number index, string text, vector2 pos )
	local bool, obj = EGP:CreateObject( this, EGP.Objects.Names["Text"], { index = index, text = text, x = pos[1], y = pos[2] } )
	if (bool) then Update(self,this) end
end

__e2setcost(30)

----------------------------
-- Set Text
----------------------------
e2function void wirelink:egpSetText( number index, string text )
	local bool, k, v = EGP:HasObject( this, index )
	if (bool) then
		if (EGP:EditObject( v, { text = text } )) then Update(self,this) end
	end
end

----------------------------
-- Alignment
----------------------------
e2function void wirelink:egpSetAlign( number index, number align )
	local bool, k, v = EGP:HasObject( this, index )
	if (bool) then
		if (EGP:EditObject( v, { align = math.Clamp(align,0,2) } )) then Update(self,this) end
	end
end

----------------------------
-- Font
----------------------------
e2function void wirelink:egpSetFont( number index, string font )
	local bool, k, v = EGP:HasObject( this, index )
	if (bool) then
		local fontid = 0
		for k,v in ipairs( EGP.ValidFonts ) do
			if (v:lower() == font:lower()) then
				fontid = k
			end
		end
		if (EGP:EditObject( v, { fontid = fontid } )) then Update(self,this) end
	end
end

e2function void wirelink:egpSetFont( number index, number fontid )
	local bool, k, v = EGP:HasObject( this, index )
	if (bool) then
		if (EGP.ValidFont[fontid]) then
			if (EGP:EditObject( v, { fontid = fontid } )) then Update(self,this) end
		end
	end
end

__e2setcost(35)

--------------------------------------------------------
-- BoxOutline
--------------------------------------------------------
e2function void wirelink:egpBoxOutline( number index, vector2 size, vector2 pos )
	local bool, obj = EGP:CreateObject( this, EGP.Objects.Names["BoxOutline"], { index = index, w = size[1], h = size[2], x = pos[1], y = pos[2] } )
	if (bool) then Update(self,this) end
end

--------------------------------------------------------
-- Poly
--------------------------------------------------------

__e2setcost(45)

e2function void wirelink:egpPoly( number index, ... )
	if (!EGP:ValidEGP( this )) then return end
	local args = {...}
	if (#args<3) then return end -- No less than 3
	if (#args>17) then return end -- No more than 17
	
	 -- Each arg must be a vec2 or vec4
	for k,v in ipairs( args ) do 
		if (typeids[k] != "xv2" and typeids[k] != "xv4") then return end 
	end
	
	local vertices = {}
	for k,v in ipairs( args ) do
		if (typeids[k] == "xv2") then
			table.insert( vertices, { x = v[1], y = v[2] } )
		else
			table.insert( vertices, { x = v[1], y = v[2], u = v[3], v = v[4] } )
		end
	end
	
	local bool, obj = EGP:CreateObject( this, EGP.Objects.Names["Poly"], { index = index, vertices = vertices } )
	if (bool) then Update(self,this) end
end

e2function void wirelink:egpPoly( number index, array args )
	if (!EGP:ValidEGP( this )) then return end
	if (#args<3) then return end -- No less than 3
	if (#args>17) then return end -- No more than 17
	
	-- Each arg must be a vec2 or vec4
	for k,v in ipairs( args ) do 
		if ((type(v) != "table" or #v != 2) and (type(v) != "table" or #v != 4)) then return end 
	end
	
	local vertices = {}
	for k,v in ipairs( args ) do
		if (#v == 2) then
			table.insert( vertices, { x = v[1], y = v[2] } )
		else
			table.insert( vertices, { x = v[1], y = v[2], u = v[3], v = v[4] } )
		end
	end
	
	local bool, obj = EGP:CreateObject( this, EGP.Objects.Names["Poly"], { index = index, vertices = vertices } )
	if (bool) then Update(self,this) end
end

__e2setcost(35)

--------------------------------------------------------
-- Line
--------------------------------------------------------
e2function void wirelink:egpLine( number index, vector2 pos1, vector2 pos2 )
	local bool, obj = EGP:CreateObject( this, EGP.Objects.Names["Line"], { index = index, x = pos1[1], y = pos1[2], x2 = pos2[1], y2 = pos2[2] } )
	if (bool) then Update(self,this) end
end

--------------------------------------------------------
-- Circle
--------------------------------------------------------
e2function void wirelink:egpCircle( number index, vector2 size, vector2 pos )
	local bool, obj = EGP:CreateObject( this, EGP.Objects.Names["Circle"], { index = index, x = pos[1], y = pos[2], w = size[1], h = size[2] } )
	if (bool) then Update(self,this) end
end

--------------------------------------------------------
-- Triangle
--------------------------------------------------------
e2function void wirelink:egpTriangle( number index, vector2 vert1, vector2 vert2, vector2 vert3 )
	local bool, obj = EGP:CreateObject( this, EGP.Objects.Names["Triangle"], { index = index, x = vert1[1], y = vert1[2], x2 = vert2[1], y2 = vert2[2], x3 = vert3[1], y3 = vert3[2] } )
	if (bool) then Update(self,this) end
end

--------------------------------------------------------
-- PacMan Circle
--------------------------------------------------------
e2function void wirelink:egpPacManCircle( number index, vector2 size, vector2 pos, number angle, number mouthsize )
	local bool, obj = EGP:CreateObject( this, EGP.Objects.Names["PacMan"], { index = index, x = pos[1], y = pos[2], w = size[1], h = size[2], size = mouthsize, angle = angle } )
	if (bool) then Update(self,this) end
end

--------------------------------------------------------
-- Common
--------------------------------------------------------

__e2setcost(30)

----------------------------
-- Size
----------------------------
e2function void wirelink:egpSize( number index, vector2 size )
	local bool, k, v = EGP:HasObject( this, index )
	if (bool) then
		if (EGP:EditObject( v, { w = size[1], h = size[2] } )) then Update(self,this) end
	end
end

e2function void wirelink:egpSize( number index, number size )
	local bool, k, v = EGP:HasObject( this, index )
	if (bool) then
		if (EGP:EditObject( v, { size = size } )) then Update(self,this) end
	end
end

----------------------------
-- Position
----------------------------
e2function void wirelink:egpPos( number index, vector2 pos )
	local bool, k, v = EGP:HasObject( this, index )
	if (bool) then
		if (EGP:EditObject( v, { x = pos[1], y = pos[2] } )) then Update(self,this) end
	end
end

----------------------------
-- Color
----------------------------
e2function void wirelink:egpColor( number index, vector4 color )
	local bool, k, v = EGP:HasObject( this, index )
	if (bool) then
		if (EGP:EditObject( v, { r = color[1], g = color[2], b = color[3], a = color[4] } )) then Update(self,this) end
	end
end

e2function void wirelink:egpColor( number index, vector color )
	local bool, k, v = EGP:HasObject( this, index )
	if (bool) then
		if (EGP:EditObject( v, { r = color[1], g = color[2], b = color[3] } )) then Update(self,this) end
	end
end

e2function void wirelink:egpColor( number index, r,g,b,a )
	local bool, k, v = EGP:HasObject( this, index )
	if (bool) then
		if (EGP:EditObject( v, { r = r, g = g, b = b, a = a } )) then Update(self,this) end
	end
end

----------------------------
-- Material
----------------------------
e2function void wirelink:egpMaterial( number index, string material )
	local bool, k, v = EGP:HasObject( this, index )
	if (bool) then
		if (EGP:EditObject( v, { material = material } )) then Update(self,this) end
	end
end

e2function void wirelink:egpMaterialFromScreen( number index, entity gpu )
	local bool, k, v = EGP:HasObject( this, index )
	if (bool and gpu:IsValid()) then
		if (EGP:EditObject( v, { material = ("<gpu%d>"):format(gpu:EntIndex()) } )) then Update(self,this) end
	end
end

----------------------------
-- Angle
----------------------------

e2function void wirelink:egpAngle( number index, number angle )
	local bool, k, v = EGP:HasObject( this, index )
	if (bool) then
		if (EGP:EditObject( v, { angle = angle } )) then Update(self,this) end
	end
end

--------------------------------------------------------
-- Clear & Remove
--------------------------------------------------------
e2function void wirelink:egpClear()
	if (EGP:ValidEGP( this )) then
		this.RenderTable = {}
		Update(self,this)
	end
end

e2function void wirelink:egpRemove( number index )
	local bool, k, v = EGP:HasObject( this, index )
	if (bool) then
		this.RenderTable[k] = {}
		this.RenderTable[k].remove = true
		this.RenderTable[k].index = index
		Update(self,this)
	end
end

--------------------------------------------------------
-- Additional Functions
--------------------------------------------------------

__e2setcost(20)

e2function vector2 wirelink:egpCursor( entity ply )
	if (!EGP:ValidEGP( this )) then return {-1,-1} end
	if (!ply or !ply:IsValid() or !ply:IsPlayer()) then return {-1,-1} end
	
	local monitor = WireGPU_Monitors[this:GetModel()]
	local ang = this:LocalToWorldAngles(monitor.rot)
	local pos = this:LocalToWorld(monitor.offset)
	local h = 512
	local w = h/monitor.RatioX
	local x = -w/2
	local y = -h/2

	local trace = ply:GetEyeTraceNoCursor()
	local ent = trace.Entity

	local cx = -1
	local cy = -1
	
	if (!EGP:ValidEGP( ent )) then return {-1,-1} end
	
	if (ent == this) then
		local dist = trace.Normal:Dot(trace.HitNormal)*trace.Fraction*-16384
		dist = math.max(dist, trace.Fraction*16384-ent:BoundingRadius())
		local cpos = WorldToLocal(trace.HitPos, Angle(), pos, ang)
		cx = (0.5+cpos.x/(monitor.RS*w)) * 512
		cy = (0.5-cpos.y/(monitor.RS*h)) * 512	
	end
	
	return {cx,cy}
end

--------------------------------------------------------
-- Callbacks
--------------------------------------------------------

__e2setcost(nil)

registerCallback("postexecute",function(self)
	for k,v in pairs( self.data.EGP ) do
		if (k and k:IsValid()) then
			if (v == true) then
				EGP:Transmit( k )
				self.data.EGP[k] = nil
			end
		else
			v = nil
		end
	end
end)

registerCallback("construct",function(self)
	self.data.EGP = {}
end)