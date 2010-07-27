local Obj = EGP:NewObject( "TriangleOutline" )
Obj.x2 = 0
Obj.y2 = 0
Obj.x3 = 0
Obj.y3 = 0
Obj.material = ""
Obj.parent = nil
Obj.Draw = function( self )
	if (self.a>0) then
		surface.SetDrawColor( self.r, self.g, self.b, self.a )
		surface.DrawLine( self.x, self.y, self.x2, self.y2 )
		surface.DrawLine( self.x2, self.y2, self.x3, self.y3 )
		surface.DrawLine( self.x3, self.y3, self.x, self.y )
	end
end
Obj.Transmit = function( self )
	EGP.umsg.Float( self.x )
	EGP.umsg.Float( self.y )
	EGP.umsg.Float( self.x2 )
	EGP.umsg.Float( self.y2 )
	EGP.umsg.Float( self.x3 )
	EGP.umsg.Float( self.y3 )
	EGP:SendMaterial( self )
	EGP:SendColor( self )
end
Obj.Receive = function( self, um )
	local tbl = {}
	tbl.x = um:ReadFloat()
	tbl.y = um:ReadFloat()
	tbl.x2 = um:ReadFloat()
	tbl.y2 = um:ReadFloat()
	tbl.x3 = um:ReadFloat()
	tbl.y3 = um:ReadFloat()
	EGP:ReceiveMaterial( tbl, um )
	EGP:ReceiveColor( tbl, self, um )
	return tbl
end
Obj.DataStreamInfo = function( self )
	return { material = self.material, x = self.x, y = self.y, x2 = self.x2, y2 = self.y2, x3 = self.x3, y3 = self.y3, r = self.r, g = self.g, b = self.b, a = self.a }
end