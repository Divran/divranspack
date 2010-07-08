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
	
	local function SpawnEnt( ply, Pos, Ang, model, class)
		if (!ply:CheckLimit("wire_egps")) then return false end
		local ent = ents.Create(class)
		if (model) then ent:SetModel(model) end
		ent:SetAngles(Ang)
		ent:SetPos(Pos)
		ent:Spawn()
		ent:SetPlayer(ply)
		
		ply:AddCount( "wire_egps", ent )
		
		return ent
	end
	
	local function SpawnEGP( ply, Pos, Ang, model )
		return SpawnEnt( ply, Pos, Ang, model, "gmod_wire_egp" )
	end
	duplicator.RegisterEntityClass("gmod_wire_egp", SpawnEGP, "Pos", "Ang", "model")
	local function SpawnHUD( ply, Pos, Ang, model )
		return SpawnEnt( ply, Pos, Ang, model, "gmod_wire_egp_hud" )
	end
	duplicator.RegisterEntityClass("gmod_wire_egp_hud", SpawnHUD, "Pos", "Ang", "model")

	function TOOL:LeftClick( trace )
		if (trace.Entity and trace.Entity:IsPlayer()) then return false end
		local ply = self:GetOwner()
		if (!ply:CheckLimit( "wire_egps" )) then return false end
		local model = self:GetClientInfo("model")
		if (!util.IsValidModel(model)) then return false end
		
		local model = self:GetClientInfo("model")
		local ang
		local pos = trace.HitPos
		local flat = self:GetClientNumber("createflat")
		if (flat == 1) then
			ang =  trace.HitNormal:Angle() + Angle(90,0,0)
		else
			ang = trace.HitNormal:Angle()
		end
		
		local ent = SpawnEGP( ply, pos, ang, model )
		if (!ent) then return end
		
		if (flat == 1) then
			ent:SetPos( trace.HitPos + trace.HitNormal * ent:OBBMaxs().z )
		else
			ent:SetPos( trace.HitPos + trace.HitNormal * ent:OBBMaxs().x )
		end
		
		ply:AddCleanup( "wire_egp", ent )

		undo.Create( "wire_egp" )
			undo.AddEntity( ent )
			undo.SetPlayer( ply )
		undo.Finish()
		
		return true
	end
	
	function TOOL:RightClick( trace )
		if (trace.Entity and trace.Entity:IsPlayer()) then return false end
		local ply = self:GetOwner()
		if (!ply:CheckLimit( "wire_egps" )) then return false end
		
		local ent = SpawnHUD( ply, trace.HitPos + trace.HitNormal * 0.25, trace.HitNormal:Angle() + Angle(90,0,0) )
		if (!ent) then return end
		
		ply:AddCleanup( "wire_egp", ent )

		undo.Create( "wire_egp" )
			undo.AddEntity( ent )
			undo.SetPlayer( ply )
		undo.Finish()
		
		return true
	end
else
	language.Add( "Tool_wire_egp_name", "E2 Graphics Processor" )
    language.Add( "Tool_wire_egp_desc", "EGP Tool" )
    language.Add( "Tool_wire_egp_0", "Primary: Create EGP, Secondary: Create EGP HUD, Reload: Respawn and reload the GPU RenderTarget (Client side) - use if the screen is gone due to lag." )
	language.Add( "sboxlimit_wire_egps", "You've hit the EGP limit!" )
	language.Add( "Undone_wire_egp", "Undone EGP" )
	language.Add( "Tool_wire_egp_createflat", "Create flat to surface" )
		
	function TOOL:LeftClick( trace ) return (!trace.Entity or (trace.Entity and !trace.Entity:IsPlayer())) end
	function TOOL:RightClick( trace ) return (!trace.Entity or (trace.Entity and !trace.Entity:IsPlayer())) end
	function TOOL:Reload( trace )
		if (!EGP:ValidEGP( trace.Entity )) then return false end
		if (trace.Entity:GetClass() == "gmod_wire_egp_hud") then return false end
		if (trace.Entity:GetClass() == "gmod_wire_egp_emitter") then return false end
		trace.Entity.GPU:Finalize()
		trace.Entity.GPU = GPULib.WireGPU( trace.Entity )
		trace.Entity:EGP_Update()
		LocalPlayer():ChatPrint("GPU RenderTarget reloaded.")
	end
end

function TOOL:UpdateGhost( ent, ply )
	if (!ent or !ent:IsValid()) then return end
	local trace = ply:GetEyeTrace()
	
	if (trace.Entity and trace.Entity:IsPlayer()) then
		ent:SetNoDraw( true )
		return
	end
	
	local flat = self:GetClientNumber("createflat")
	if (flat == 1) then
		ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0) )
		ent:SetPos( trace.HitPos + trace.HitNormal * ent:OBBMaxs().z )
	else
		ent:SetAngles( trace.HitNormal:Angle() )
		ent:SetPos( trace.HitPos + trace.HitNormal * ent:OBBMaxs().x )
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
	
	panel:AddControl( "Label", { Text = "EGP v3 by Divran" }  )
	
	panel:AddControl("Header", { Text = "#Tool_wire_egp_name", Description = "#Tool_wire_egp_desc" })
	WireDermaExts.ModelSelect(panel, "wire_egp_model", list.Get( "WireScreenModels" ), 5)
	panel:AddControl("Checkbox", {Label = "#Tool_wire_egp_createflat",Command = "wire_egp_createflat"})
end