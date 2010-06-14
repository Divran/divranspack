local Obj = EGP:NewObject( "Box" )
Obj.material = ""
Obj.Draw = function( self )
	if (self.a > 0 and self.w > 0 and self.h > 0) then
		surface.SetDrawColor( self.r, self.g, self.b, self.a )
		if (self.material and #self.material>0) then
			surface.DrawTexturedRect( self.x, self.y, self.w, self.h )
		else
			surface.DrawRect( self.x, self.y, self.w, self.h )
		end
	end
end
Obj.Transmit = function( self )
	umsg.String(self.material)
	EGP:SendPosSize( self )
	EGP:SendColor( self )
end
Obj.Receive = function( self, um )
	local tbl = {}
	tbl.material = um:ReadString()
	EGP:ReceivePosSize( tbl, um )
	EGP:ReceiveColor( tbl, self, um )
	return tbl
end