local Obj = EGP:NewObject( "Poly" )
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
	umsg.Char(math.Clamp(#self.vertices,0,128)-128)
	for i=1,math.min(#self.vertices,128) do
		umsg.Float( self.vertices[i].x )
		umsg.Float( self.vertices[i].y )
		umsg.Float( self.vertices[i].u )
		umsg.Float( self.vertices[i].v )
	end
	umsg.String(self.material)
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