local Obj = EGP:NewObject( "Line" )
Obj.w = nil
Obj.h = nil
Obj.x2 = 0
Obj.y2 = 0
Obj.Draw = function( self )
	if (self.a>0) then
		surface.SetDrawColor( self.r, self.g, self.b, self.a )
		surface.DrawLine( self.x, self.y, self.x2, self.y2 )
	end
end
Obj.Transmit = function( self )
	umsg.Float(self.x)
	umsg.Float(self.y)
	umsg.Float(self.x2)
	umsg.Float(self.y2)
	EGP:SendColor( self )
end
Obj.Receive = function( self, um )
	local tbl = {}
	tbl.x = um:ReadFloat()
	tbl.y = um:ReadFloat()
	tbl.x2 = um:ReadFloat()
	tbl.y2 = um:ReadFloat()
	EGP:ReceiveColor( tbl, self, um )
	return tbl
end