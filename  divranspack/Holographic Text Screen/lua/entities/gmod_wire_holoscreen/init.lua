
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.WireDebugName = "Holo Screen"
ENT.OverlayDelay = 0

ENT.AllowedFonts = { 	"DebugFixed",
						"DebugFixedSmall",
						"DefaultFixedOutline",
						"MenuItem",
						"Default",
						"TabLarge",
						"DefaultBold",
						"DefaultUnderline",
						"DefaultSmall",
						"DefaultSmallDropShadow",
						"DefaultVerySmall",
						"DefaultLarge",
						"UiBold",
						"MenuLarge",
						"ConsoleText",
						"Marlett",
						"Trebuchet18",
						"Trebuchet19",
						"Trebuchet20",
						"Trebuchet22",
						"Trebuchet24",
						"HUDNumber",
						"HUDNumber1",
						"HUDNumber2",
						"HUDNumber3",
						"HUDNumber4",
						"HUDNumber5",
						"HudHintTextLarge",
						"HudHintTextSmall",
						"CenterPrintText",
						"HudSelectionText",
						"DefaultFixed",
						"DefaultFixedDropShadow",
						"CloseCaption_Normal",
						"CloseCaption_Bold",
						"CloseCaption_BoldItalic",
						"TitleFont",
						"TitleFont2",
						"ChatFont",
						"TargetID",
						"TargetIDSmall",
						"HL2MPTypeDeath",
						"BudgetLabel" }

function ENT:Initialize()
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Text = "Holoscreen - By Divran"
	self.TextColor = Color(255,255,255,255)
	self.PosOffset = Vector(0,0,0)
	self.Size = 1
	self.Font = "Default"
	
	self.Inputs = WireLib.CreateInputs( self.Entity, { "Text [STRING]", "Color [VECTOR]", "Alpha", "Size", "Offset Pos [VECTOR]", "Font [STRING]" } )
	
	self:SetOverlayText( "Holographic Screen" )
	self:UpdateText()
end

function ENT:TriggerInput( name, value )
	if (name == "Text") then
		self.Text = value
	elseif (name == "Color") then
		self.TextColor = Color(math.Clamp(value.x,0,255),math.Clamp(value.y,0,255),math.Clamp(value.z,0,255), self.TextColor.a)
	elseif (name == "Alpha") then
		self.TextColor.a = math.Clamp(value,0,255)
	elseif (name == "Size") then
		self.Size = math.Clamp(value,0.1,5)
	elseif (name == "Offset Pos") then
		self.PosOffset = Vector(math.Clamp(value.x,-200,200),math.Clamp(value.y,-200,200),math.Clamp(value.z,-200,200))
	elseif (name == "Font") then
		if (table.HasValue( self.AllowedFonts, value )) then
			self.Font = value
		end
	end
		
	self:UpdateText()
end

function ENT:UpdateText()
	self:SetNWString("holoscreen_text", self.Text )
	self:SetNWInt("holoscreen_color_r", self.TextColor.r )
	self:SetNWInt("holoscreen_color_g", self.TextColor.g )
	self:SetNWInt("holoscreen_color_b", self.TextColor.b )
	self:SetNWInt("holoscreen_color_a", self.TextColor.a )
	self:SetNWInt("holoscreen_pos_x", self.PosOffset.x )
	self:SetNWInt("holoscreen_pos_y", self.PosOffset.y )
	self:SetNWInt("holoscreen_pos_z", self.PosOffset.z )
	self:SetNWString("holoscreen_font", self.Font )
	self:SetNWInt("holoscreen_size", self.Size )
end



function ENT:ApplyDupeInfo(ply, ent, info, GetEntByID)
	if (!ply:CheckLimit("wire_holoscreens")) then 
		ent:Remove()
		return
	end
	ply:AddCount( "wire_holoscreens", ent )
	self.BaseClass.ApplyDupeInfo(self, ply, ent, info, GetEntByID)
end
