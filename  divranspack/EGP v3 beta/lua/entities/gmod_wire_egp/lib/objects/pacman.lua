local Obj = EGP:NewObject( "PacMan" )
Obj.material = ""
Obj.angle = 0
Obj.size = 45
Obj.Draw = function( self )
	if (self.a>0 and self.w > 0 and self.h > 0) then
		local vertices = {}
		
		self.size = math.Clamp(self.size,0,359)
		
		table.insert( vertices, { x = self.x, y = self.y, u = 0, v = 0 } )
		for i=0,360-self.size,(360-self.size)/36 do
			local rad = math.rad(i)
			local x = math.cos(rad)
			local y = math.sin(rad)
			
			rad = math.rad(self.angle)
			local tempx = x * self.w * math.cos(rad) - y * self.h * math.sin(rad) + self.x
			y = x * self.w * math.sin(rad) + y * self.h * math.cos(rad) + self.y
			x = tempx
			
			table.insert( vertices, { x = x, y = y, u = 0, v = 0 } )
		end
		
		surface.SetDrawColor( self.r, self.g, self.b, self.a )
		if (vertices and #vertices>0) then
			surface.DrawPoly( vertices )
		end
	end
end
Obj.Transmit = function( self )
	EGP.umsg.String( self.material )
	EGP.umsg.Short( math.Round(self.angle) )
	EGP.umsg.Short( math.Round(self.size) )
	self.BaseClass.Transmit( self )
end
Obj.Receive = function( self, um )
	local tbl = {}
	tbl.material = um:ReadString()
	tbl.angle = um:ReadShort()
	tbl.size = um:ReadShort()
	table.Merge( tbl, self.BaseClass.Receive( self, um ) )
	return tbl
end
Obj.DataStreamInfo = function( self )
	local tbl = {}
	table.Merge( tbl, self.BaseClass.DataStreamInfo( self ) )
	table.Merge( tbl, { material = self.material, angle = self.angle, size = self.size } )
	return tbl
end