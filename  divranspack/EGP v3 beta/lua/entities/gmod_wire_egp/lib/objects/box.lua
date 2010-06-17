local Obj = EGP:NewObject( "Box" )
Obj.material = ""
Obj.Draw = function( self )
	if (self.a>0) then
		surface.SetDrawColor( self.r, self.g, self.b, self.a )
		if (self.material and (type(self.material == "string" and #self.material>0) or (type(mat) == "Entity" and mat:IsValid()))) then
			surface.DrawTexturedRectRotated( self.x + self.w / 2, self.y + self.h / 2, self.w, self.h, 0 )
		else
			surface.DrawRect( self.x, self.y, self.w, self.h )
		end
	end
end
Obj.Transmit = function( self )
	self.BaseClass.Transmit( self )
end
Obj.Receive = function( self, um )
	local tbl = {}
	table.Merge( tbl, self.BaseClass.Receive( self, um ) )
	return tbl
end
Obj.DataStreamInfo = function( self )
	local tbl = {}
	table.Merge( tbl, self.BaseClass.DataStreamInfo( self ) )
	table.Merge( tbl, { material = self.material, angle = self.angle } )
	return tbl
end