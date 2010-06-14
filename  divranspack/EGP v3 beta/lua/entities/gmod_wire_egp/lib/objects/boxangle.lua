local Obj = EGP:NewObject( "BoxAngle" )
Obj.material = ""
Obj.angle = 0
Obj.Draw = function( self )
	if (self.a>0) then
		surface.SetDrawColor( self.r, self.g, self.b, self.a )
		surface.DrawTexturedRectRotated( self.x, self.y, self.w, self.h, self.angle )
	end
end
Obj.Transmit = function( self )
	umsg.Short(self.angle)
	umsg.String(self.material)
	EGP:SendPosSize( self )
	EGP:SendColor( self )
end
Obj.Receive = function( self, um )
	local tbl = {}
	tbl.angle = um:ReadShort()
	tbl.material = um:ReadString()
	EGP:ReceivePosSize( tbl, um )
	EGP:ReceiveColor( tbl, self, um )
	return tbl
end