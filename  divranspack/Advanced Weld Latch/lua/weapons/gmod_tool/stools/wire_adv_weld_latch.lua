-- Wire Advanced Weld Latch
-- Made by Divran

TOOL.Category		= "Wire - Physics"
TOOL.Name			= "Adv Weld Latch"
TOOL.Command		= nil
TOOL.ConfigName		= ""
TOOL.Tab			= "Wire"

if ( CLIENT ) then
    language.Add( "Tool_wire_adv_weld_latch_name", "Adv Weld Latch Tool (Wire)" )
    language.Add( "Tool_wire_adv_weld_latch_desc", "Spawns an Adv Weld Latch for use with the wire system." )
    language.Add( "Tool_wire_adv_weld_latch_0", "Primary: Create Weld Latch" )
	language.Add( "sboxlimit_wire_adv_weld_latch", "You've hit the adv weld latch limit!" )
	language.Add( "undone_wire_adv_weld_latch", "Undone Adv Wire Weld Latch" )
elseif ( SERVER ) then
    CreateConVar('sbox_maxwire_adv_weld_latches',3)
end

TOOL.ClientConVar[ "model" ] = "models/jaanus/wiretool/wiretool_siren.mdl"
cleanup.Register( "wire_adv_weld_latches" )


function TOOL:GetModel()
	local mdl = self:GetClientInfo("model")
	if (!util.IsValidModel(mdl) or !util.IsValidProp(mdl)) then return "models/jaanus/wiretool/wiretool_siren.mdl" end
	return mdl
end

if (SERVER) then
	function TOOL:CreateLatch( ply, trace, Model )
		if (!ply:CheckLimit("wire_adv_weld_latchs")) then return end
		local ent = ents.Create( "gmod_wire_adv_weld_latch" )
		if (!ent:IsValid()) then return end
		
		-- Pos/Model/Angle
		ent:SetModel( Model )
		ent:SetPos( trace.HitPos - trace.HitNormal * ent:OBBMins().z )
		ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0) )
		
		ent:SetPlayer( ply )
		
		ent:Spawn()
		ent:Activate()
		
		ply:AddCount( "wire_adv_weld_latches", ent )
		
		return ent
	end
	
	function TOOL:LeftClick( trace )
		if (!trace) then return end
		local ply = self:GetOwner()
	
		local ent = self:CreateLatch( ply, trace, self:GetModel() )
		
		local const = WireLib.Weld( ent, trace.Entity, trace.PhysicsBone, true )
		undo.Create("wire_adv_weld_latch")
			undo.AddEntity( ent )
			undo.AddEntity( const )
			undo.SetPlayer( ply )
		undo.Finish()

		ply:AddCleanup( "wire_adv_weld_latches", ent )

		return true
	end
	
else
	function TOOL:LeftClick( trace ) return !trace.Entity:IsPlayer() end
	
	function TOOL.BuildCPanel(panel)
		panel:AddControl("Header", { Text = "#Tool_wire_adv_weld_latch_name", Description = "#Tool_wire_adv_weld_latch_desc" })
		WireDermaExts.ModelSelect(panel, "wire_adv_weld_latch_model", list.Get( "Wire_Misc_Tools_Models" ), 8)
	end
end
	
function TOOL:UpdateGhostLatch( ent, ply )
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
	
	self:UpdateGhostLatch( self.GhostEntity, self:GetOwner() )
end