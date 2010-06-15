local Obj = EGP:NewObject( "Poly" )
Obj.w = nil
Obj.h = nil
Obj.x = nil
Obj.y = nil
Obj.vertices = {}
Obj.material = ""
Obj.Draw = function( self )
	if (self.a>0 and #self.vertices>2) then
		surface.SetDrawColor( self.r, self.g, self.b, self.a )
		if (self.vertices and #self.vertices>0) then
			surface.DrawPoly( vertices )
		end
	end
end
Obj.Transmit = function( self )
	EGP.umsg.Char(math.Clamp(#self.vertices,0,128)-128)
	for i=1,math.min(#self.vertices,128) do
		EGP.umsg.Float( self.vertices[i].x )
		EGP.umsg.Float( self.vertices[i].y )
		EGP.umsg.Float( self.vertices[i].u )
		EGP.umsg.Float( self.vertices[i].v )
	end
	EGP.umsg.String(self.material)
	EGP:SendColor( self )
end
Obj.Receive = function( self, um )
	local tbl = {}
	local nr = um:ReadChar()+128
	tbl.vertices = {}
	for i=1,nr do
		table.insert( tbl.vertices, { x = um:ReadFloat(), y = um:ReadFloat(), u = um:ReadFloat(), v = um:ReadFloat() } )
	end
	tbl.material = um:ReadString()
	EGP:ReceiveColor( tbl, self, um )
	return tbl
end
Obj.DataStreamInfo = function( self )
	return { vertices = self.vertices, material = self.material, r = self.r, g = self.g, b = self.b, a = self.a }
end