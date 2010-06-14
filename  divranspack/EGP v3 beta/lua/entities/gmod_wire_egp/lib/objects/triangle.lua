local Obj = EGP:NewObject( "Triangle" )
Obj.x2 = 0
Obj.y2 = 0
Obj.x3 = 0
Obj.y3 = 0
Obj.material = ""
Obj.Draw = function( self )
	if (self.a>0) then
		surface.SetDrawColor( self.r, self.g, self.b, self.a )
		surface.DrawPoly( { { x = self.x, y = self.y, u = 0, v = 0 }, { x = self.x2, y = self.y2, u = 0, v = 1 }, { x = self.x3, y = self.y2, u = 1, v = 0 } } )
	end
end
Obj.Transmit = function( self )
	umsg.Float( self.x )
	umsg.Float( self.y )
	umsg.Float( self.x2 )
	umsg.Float( self.y2 )
	umsg.Float( self.x3 )
	umsg.Float( self.y3 )
	umsg.String( self.material )
	EGP:SendPosSize( self )
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
	tbl.material = um:ReadString()
	EGP:ReceiveColor( tbl, self, um )
	return tbl
end