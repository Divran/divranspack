local Obj = EGP:NewObject( "Text" )
Obj.h = nil
Obj.w = nil
Obj.text = ""
Obj.fontid = 0
Obj.size = 1
Obj.valign = 0
Obj.halign = 0
Obj.Draw = function( self )
	if (self.text and #self.text>0) then
		surface.SetTextColor( self.r, self.g, self.b, self.a )
		
		local font = EGP.ValidFonts[self.fontid] or "WireGPU_ConsoleFont"
		if (self.size != 1) then
			local fontname = "WireEGP_"..self.size.."_"..self.fontid
			if (!table.HasValue( EGP.ValidFonts, fontname )) then 
				surface.CreateFont(font,self.size,800,true,false,fontname)
				table.insert( EGP.ValidFonts, fontname )
			end
			surface.SetFont( fontname )
		else
			surface.SetFont( font )
		end
		
		local w,h
		local x, y = self.x, self.y
		if (self.halign != 0) then
			w,h = surface.GetTextSize( self.text )
			x = x - (w * ((self.halign%10)/2))
		end
		if (self.valign) then
			if (!h) then _,h = surface.GetTextSize( self.text ) end
			y = y - (h * ((self.valign%10)/2))
		end
		
		surface.SetTextPos( x, y )
		
		surface.DrawText( self.text )
	end
end
Obj.Transmit = function( self )
	EGP.umsg.Float( self.x )
	EGP.umsg.Float( self.y )
	EGP.umsg.String( self.text )
	EGP.umsg.Char( self.fontid-128 )
	EGP.umsg.Char( math.Clamp(self.size,0,200)-128 )
	EGP.umsg.Char( math.Clamp(self.valign,0,2) )
	EGP.umsg.Char( math.Clamp(self.halign,0,2) )
	EGP.umsg.Short( self.parent )
	EGP:SendColor( self )
end
Obj.Receive = function( self, um )
	local tbl = {}
	tbl.x = um:ReadFloat()
	tbl.y = um:ReadFloat()
	tbl.text = um:ReadString()
	tbl.fontid = um:ReadChar()+128
	tbl.size = um:ReadChar()+128
	tbl.valign = um:ReadChar()
	tbl.halign = um:ReadChar()
	tbl.parent = um:ReadShort()
	EGP:ReceiveColor( tbl, self, um )
	return tbl
end
Obj.DataStreamInfo = function( self )
	return { align = self.align, size = self.size, r = self.r, g = self.g, b = self.b, a = self.a, text = self.text, fontid = self.fontid }
end