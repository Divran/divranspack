local Obj = EGP:NewObject( "Circle" )
Obj.material = ""
Obj.angle = 0
Obj.Draw = function( self )
	if (self.a>0 and self.w > 0 and self.h > 0) then
		local vertices = {}
		for i=0,360,10 do
			local rad = math.rad(i)
			local x = math.cos(rad)
			local u = x
			local y = math.sin(rad)
			local v = y
			
			rad = math.rad(self.angle)
			local tempx = x * self.w * math.cos(rad) - y * self.h * math.sin(rad) + self.x
			y = x * self.w * math.sin(rad) + y * self.h * math.cos(rad) + self.y
			x = tempx
			
			table.insert( vertices, { x = x, y = y, u = u, v = v } )
		end
		
		surface.SetDrawColor( self.r, self.g, self.b, self.a )
		if (vertices and #vertices>0) then
			surface.DrawPoly( vertices )
		end
	end
end
Obj.Transmit = function( self )
	umsg.String(self.material)
	umsg.Short( self.angle )
	EGP:SendPosSize( self )
	EGP:SendColor( self )
end
Obj.Receive = function( self, um )
	local tbl = {}
	tbl.material = um:ReadString()
	tbl.angle = um:ReadShort()
	EGP:ReceivePosSize( tbl, um )
	EGP:ReceiveColor( tbl, self, um )
	return tbl
end