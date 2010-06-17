-- Wire EGP by Divran

TOOL.Category		= "Wire - Display"
TOOL.Name			= "EGP v3"
TOOL.Command		= nil
TOOL.ConfigName		= ""
TOOL.Tab			= "Wire"

TOOL.ClientConVar["model"] = "models/kobilica/wiremonitorbig.mdl"
TOOL.ClientConVar["createflat"] = 1


cleanup.Register( "wire_egps" )

if (SERVER) then
	CreateConVar('sbox_maxwire_egps', 5)

	function TOOL:LeftClick( trace )
		if (trace.Entity and trace.Entity:IsPlayer()) then return false end
		local ply = self:GetOwner()
		if (!ply:CheckLimit( "wire_egps" )) then return false end
		local model = self:GetClientInfo("model")
		if (!util.IsValidModel(model)) then return false end
		
		local ent = self:MakeWireEGP( ply, trace )
		if (!ent) then return end
		
		ply:AddCount( "wire_egp",ent )
		ply:AddCleanup( "wire_egp", ent )

		undo.Create( "wire_egp" )
			undo.AddEntity( ent )
			undo.SetPlayer( ply )
		undo.Finish()
	end
	
	function TOOL:RightClick( trace )
		if (trace.Entity and trace.Entity:IsPlayer()) then return false end
		local ply = self:GetOwner()
		if (!ply:CheckLimit( "wire_egps" )) then return false end
		
		local ent = self:MakeHUDEGP( ply, trace )
		if (!ent) then return end
		
		ply:AddCount( "wire_egp",ent )
		ply:AddCleanup( "wire_egp", ent )

		undo.Create( "wire_egp" )
			undo.AddEntity( ent )
			undo.SetPlayer( ply )
		undo.Finish()
	end
	
	function TOOL:MakeWireEGP( pl, trace )
		if ( !pl:CheckLimit( "wire_egps" ) ) then return false end
		local egp = ents.Create( "gmod_wire_egp" )
		if (!egp:IsValid()) then return false end
		local model = self:GetClientInfo("model")
		egp:SetModel(model)
		local flat = self:GetClientNumber("createflat")
		if (flat == 0) then
			egp:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0) )
			egp:SetPos( trace.HitPos - trace.HitNormal * egp:OBBMins().z )
		else
			egp:SetAngles( trace.HitNormal:Angle() )
			egp:SetPos( trace.HitPos - trace.HitNormal * egp:OBBMins().x )
		end
		
		egp:SetPlayer(pl)
		egp:Spawn()
		return egp
	end
	
	function TOOL:MakeHUDEGP( pl, trace )
		if ( !pl:CheckLimit( "wire_egps" ) ) then return false end
		local egp = ents.Create( "gmod_wire_egp_hud" )
		if (!egp:IsValid()) then return false end
		egp:SetModel("models/bull/dynamicbutton.mdl")
		egp:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0) )
		egp:SetPos( trace.HitPos - trace.HitNormal * egp:OBBMins().z )
		
		egp:SetPlayer(pl)
		egp:Spawn()
		return egp
	end
else
	language.Add( "Tool_wire_egp_name", "E2 Graphics Processor" )
    language.Add( "Tool_wire_egp_desc", "EGP Tool" )
    language.Add( "Tool_wire_egp_0", "Primary: Create EGP" )
	language.Add( "sboxlimit_wire_egps", "You've hit the EGP limit!" )
	language.Add( "Undone_wireegp", "Undone EGP" )
	language.Add("Tool_wire_egp_createflat", "Create flat to surface")
		
	function TOOL:LeftClick( trace ) return (!trace.Entity or (trace.Entity and !trace.Entity:IsPlayer())) end
	function TOOL:RightClick( trace ) return (!trace.Entity or (trace.Entity and !trace.Entity:IsPlayer())) end
end

function TOOL:UpdateGhost( ent, ply )
	if (!ent or !ent:IsValid()) then return end
	local trace = ply:GetEyeTrace()
	
	if (trace.Entity and trace.Entity:IsPlayer()) then
		ent:SetNoDraw( true )
		return
	end
	
	local flat = self:GetClientNumber("createflat")
	if (flat == 0) then
		ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0) )
		ent:SetPos( trace.HitPos - trace.HitNormal * ent:OBBMins().z )
	else
		ent:SetAngles( trace.HitNormal:Angle() )
		ent:SetPos( trace.HitPos - trace.HitNormal * ent:OBBMins().x )
	end
	
	ent:SetNoDraw( false )
end

function TOOL:Think()
	local model = self:GetClientInfo("model")
	if (!self.GhostEntity or !self.GhostEntity:IsValid() or self.GhostEntity:GetModel() != model) then
		local trace = self:GetOwner():GetEyeTrace()
		self:MakeGhostEntity( Model(model), trace.HitPos, trace.HitNormal:Angle() + Angle(90,0,0) )
	end
	self:UpdateGhost( self.GhostEntity, self:GetOwner() )
end


function TOOL.BuildCPanel(panel)
	if !(EGP) then return end
	panel:SetSpacing( 10 )
	panel:SetName( "E2 Graphics Processor" )
	
	panel:AddControl( "Label", { Text = "EGP v3 by Divran|Goluch" }  )
	
	panel:AddControl("Header", { Text = "#Tool_wire_egp_name", Description = "#Tool_wire_egp_desc" })
	WireDermaExts.ModelSelect(panel, "wire_egp_model", list.Get( "WireScreenModels" ), 5)
	panel:AddControl("Checkbox", {Label = "#Tool_wire_egp_createflat",Command = "wire_egp_createflat"})
end