
ENT.RenderGroup 		= RENDERGROUP_BOTH

language.Add( "Cleanup_hoverdrivecontrolers", "Hoverdrive Controllers" )
language.Add( "Cleaned_hoverdrivecontrolers", "Cleaned up Hoverdrive Controllers" )
language.Add( "SBoxLimit_wire_hoverdrives", "You have hit the Hoverdrive Controllers limit!" )

include('shared.lua')

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	self.Refraction = Material( "sprites/heatwave" )
	self.Glow		= Material( "sprites/light_glow02_add" )
	self.ShouldDraw = 1
	
	self.NextSmokeEffect = 0

end


/*---------------------------------------------------------
   Name: Draw
---------------------------------------------------------*/
function ENT:Draw()

	if ( self.ShouldDraw == 0 ) then return end
	self.BaseClass.Draw( self )	
	
	Wire_Render(self.Entity)
	
end

/*---------------------------------------------------------
   Name: DrawTranslucent
   Desc: Draw translucent
---------------------------------------------------------*/
function ENT:DrawTranslucent()

end


/*---------------------------------------------------------
   Name: Think
   Desc: Client Think - called every frame
---------------------------------------------------------*/
function ENT:Think()
	self.BaseClass.Think(self)
end

