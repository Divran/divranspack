local Obj = EGP:NewObject( "Triangle" )
Obj.x2 = 0
Obj.y2 = 0
Obj.x3 = 0
Obj.y3 = 0
Obj.material = ""
Obj.parent = nil
Obj.Draw = function( self )
	if (self.a>0) then
		surface.SetDrawColor( self.r, self.g, self.b, self.a )
		surface.DrawPoly( { { x = self.x, y = self.y, u = 0, v = 0 }, { x = self.x2, y = self.y2, u = 0, v = 1 }, { x = self.x3, y = self.y3, u = 1, v = 0 } } )
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