local Obj = EGP:NewObject( "Text" )
Obj.h = nil
Obj.w = nil
Obj.text = ""
Obj.fontid = 0
Obj.size = 1
Obj.align = 0
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
		
		if (align != 0) then
			local textwidth, textheight = surface.GetTextSize(self.text)
			local falign = self.align
			local halign, valign = falign%10, math.floor(falign/10)
					
			local x = self.x - (textwidth * (halign/2))
			local y = self.y - (textheight * (valign/2))
			surface.SetTextPos( x, y )
		else
			surface.SetTextPos( self.x, self.y )
		end
		
		surface.DrawText( self.text )
	end
end
Obj.Transmit = function( self )
	umsg.Float( self.x )
	umsg.Float( self.y )
	umsg.String( self.text )
	umsg.Char( self.fontid-128 )
	umsg.Char( math.Clamp(self.size,0,200)-128 )
	umsg.Char( math.Clamp(self.align,0,2) )
	EGP:SendColor( self )
end
Obj.Receive = function( self, um )
	local tbl = {}
	tbl.x = um:ReadFloat()
	tbl.y = um:ReadFloat()
	tbl.text = um:ReadString()
	tbl.fontid = um:ReadChar()+128
	tbl.size = um:ReadChar()+128
	tbl.align = um:ReadChar()
	EGP:ReceiveColor( tbl, self, um )
	return tbl
end