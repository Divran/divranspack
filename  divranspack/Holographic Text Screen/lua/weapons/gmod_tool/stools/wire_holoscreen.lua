TOOL.Category		= "Wire - Display"
TOOL.Name			= "Holographic Screen"
TOOL.Command		= nil
TOOL.ConfigName		= ""
TOOL.Tab			= "Wire"

if ( CLIENT ) then
    language.Add( "Tool_wire_holoscreen_name", "Holographic Screen Tool (Wire)" )
    language.Add( "Tool_wire_holoscreen_desc", "Spawns a Holographic Screen for use with the wire system." )
    language.Add( "Tool_wire_holoscreen_0", "Primary: Create Holographic Screen" )
	language.Add( "sboxlimit_wire_holoscreen", "You've hit holoscreen limit!" )
	language.Add( "undone_wire_holoscreen", "Undone Holographic Screen" )
elseif ( SERVER ) then
    CreateConVar('sbox_maxwire_holoscreens',10)
end

TOOL.ClientConVar[ "model" ] = "models/jaanus/wiretool/wiretool_siren.mdl"
cleanup.Register( "wire_holoscreens" )


function TOOL:GetModel()
	local mdl = self:GetClientInfo("model")
	if (!util.IsValidModel(mdl) or !util.IsValidProp(mdl)) then return "models/jaanus/wiretool/wiretool_siren.mdl" end
	return mdl
end

if (SERVER) then
	function TOOL:CreateScreen( ply, trace, Model )
		if (!ply:CheckLimit("wire_holoscreens")) then return end
		local ent = ents.Create( "gmod_wire_holoscreen" )
		if (!ent:IsValid()) then return end
		
		-- Pos/Model/Angle
		ent:SetModel( Model )
		ent:SetPos( trace.HitPos - trace.HitNormal * ent:OBBMins().z )
		ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0) )
		
		ent:Spawn()
		ent:Activate()
		
		ply:AddCount( "wire_holoscreens", ent )
		
		return ent
	end
	
	function TOOL:LeftClick( trace )
		if (!trace) then return end
		local ply = self:GetOwner()
	
		local ent = self:CreateScreen( ply, trace, self:GetModel() )
		
		local const = WireLib.Weld( ent, trace.Entity, trace.PhysicsBone, true )
		undo.Create("wire_holoscreen")
			undo.AddEntity( ent )
			undo.AddEntity( const )
			undo.SetPlayer( ply )
		undo.Finish()

		ply:AddCleanup( "wire_holoscreens", ent )

		return true
	end
	
	
else
	function TOOL:LeftClick( trace ) return !trace.Entity:IsPlayer() end
	
	function TOOL.BuildCPanel(panel)
		panel:AddControl("Header", { Text = "#Tool_wire_holoscreen_name", Description = "#Tool_wire_holoscreen" })
		WireDermaExts.ModelSelect(panel, "wire_holoscreen_model", list.Get( "Wire_Misc_Tools_Models" ), 8)
	end
end
	
function TOOL:UpdateGhostScreen( ent, ply )
	if (!ent or !ent:IsValid()) then return end
	local trace = ply:GetEyeTrace()
	if (!trace.Hit or trace.Entity:IsPlayer()) then
		ent:SetNoDraw( true )
		return
	end
	
	local Ang = trace.HitNormal:Angle() + Angle(90,0,0)
	ent:SetAngles(Ang)
	
	local Pos = trace.HitPos - trace.HitNormal * ent:OBBMins().z
	ent:SetPos( Pos )
	
	ent:SetNoDraw( false )
end

TOOL.viewing = nil

function TOOL:Think()
	local model = self:GetModel()
	
	if (!self.GhostEntity or !self.GhostEntity:IsValid() or self.GhostEntity:GetModel() != model ) then
		self:MakeGhostEntity( Model(model), Vector(0,0,0), Angle(0,0,0) )
	end
	
	self:UpdateGhostScreen( self.GhostEntity, self:GetOwner() )
end