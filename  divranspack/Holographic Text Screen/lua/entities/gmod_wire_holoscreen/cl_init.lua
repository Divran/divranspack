
include('shared.lua')

ENT.RenderGroup 		= RENDERGROUP_OPAQUE

function ENT:Draw()
	local text = self:GetNWString("holoscreen_text") or "Holoscreen - By Divran"
	if (text and text != "") then
		local r = self:GetNWInt("holoscreen_color_r") or 255
		local g = self:GetNWInt("holoscreen_color_g") or 255
		local b = self:GetNWInt("holoscreen_color_b") or 255
		local a = self:GetNWInt("holoscreen_color_a") or 255
		local posx = self:GetNWInt("holoscreen_pos_x") or 0
		local posy = self:GetNWInt("holoscreen_pos_y") or 0
		local posz = self:GetNWInt("holoscreen_pos_z") or 0
		local angp = self:GetNWInt("holoscreen_ang_p") or 0
		local angy = self:GetNWInt("holoscreen_ang_y") or 0
		local angr = self:GetNWInt("holoscreen_ang_r") or 0
		local ang = Angle(angr,angy,-angp)
		local font = self:GetNWString("holoscreen_font") or "Default"
		local size = self:GetNWInt("holoscreen_size") or 1
		cam.Start3D2D( self:LocalToWorld( Vector(posx,-posy,20+posz) ), self:LocalToWorldAngles( Angle(0,0,90) + ang ), size )
			surface.SetTextColor( r, g, b, a )
			surface.SetFont( font )
			local w, h = surface.GetTextSize( text )
			surface.SetTextPos( -w/2, -h )
			surface.DrawText( text )
			--draw.SimpleText( text, "ScoreboardText", 0, 0, Clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		cam.End3D2D()
	end
	
	self:DoNormalDraw()
	Wire_Render(self.Entity)
end