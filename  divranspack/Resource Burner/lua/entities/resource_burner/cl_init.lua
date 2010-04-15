-- Resource Burner
-- Made by Divran

include('shared.lua')

ENT.RenderGroup 		= RENDERGROUP_OPAQUE

function ENT:DoNormalDraw( DontDraw )
	if (DontDraw) then return end
	local str = self:GetNWString("OverlayText")
	if ( LocalPlayer():GetEyeTrace().Entity == self.Entity and EyePos():Distance( self.Entity:GetPos() ) < 512) then
		AddWorldTip( self.Entity:EntIndex(), str, 0.5, self.Entity:GetPos(), self.Entity  )
	end
	self:DrawModel()
end