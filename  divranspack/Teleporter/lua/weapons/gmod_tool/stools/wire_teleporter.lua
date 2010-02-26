TOOL.Category		= "Wire - Physics"
TOOL.Name			= "Teleporter"
TOOL.Command		= nil
TOOL.ConfigName		= ""
TOOL.Tab			= "Wire"

if ( CLIENT ) then
    language.Add( "Tool_wire_teleporter_name", "Teleporter Tool (Wire)" )
    language.Add( "Tool_wire_teleporter_desc", "Spawns a teleporter." )
    language.Add( "Tool_wire_teleporter_0", "Primary: Create Teleporter, Reload: Change model" )
	language.Add( "sboxlimit_wire_teleporter", "You've hit the teleporter limit!" )
	language.Add( "undone_wireteleporter", "Undone Wire Teleporter" )
elseif ( SERVER ) then
    CreateConVar('sbox_maxwire_emarkers',5)
end

TOOL.ClientConVar[ "model" ] = "models/props_c17/utilityconducter001.mdl"

cleanup.Register( "wire_teleporters" )

function TOOL:MakeTeleporter( ply, Pos, Ang, Model )
	if (!ply:CheckLimit("wire_teleporters")) then return end
	local ent = ents.Create( "gmod_wire_teleporter" )
	if (!ent:IsValid()) then return end
	ent:SetModel( Model )
	ent:SetPos( Pos )
	ent:SetAngles( Ang )	
	ent:Spawn()
	ent:Activate()
	return ent
end

function TOOL:LeftClick(trace)
	if (!trace.Hit) then return false end
	if (trace.Entity:IsPlayer()) then return false end
	if ( CLIENT ) then return true end
	
	local ply = self:GetOwner()
	
	if (!ply:CheckLimit( "wire_teleporters" ) ) then return false end
	local Ang = trace.HitNormal:Angle()
	Ang.pitch = Ang.pitch + 90
	
	local ent = self:MakeTeleporter( ply, trace.HitPos, Ang, self:GetModel() )
	if (!ent) then return false end
	ent:SetPos( trace.HitPos - trace.HitNormal * ent:OBBMins().z )
	local const = WireLib.Weld( ent, trace.Entity, trace.PhysicsBone, true )
	undo.Create("wireteleporter")
		undo.AddEntity( ent )
		undo.AddEntity( const )
		undo.SetPlayer( ply )
	undo.Finish()
	
	ply:AddCleanup( "wire_teleporters", ent )
	
	return true
end

function TOOL:Reload( trace )
	if (trace.Hit) then
		if (trace.Entity and ValidEntity(trace.Entity) and !trace.Entity:IsPlayer()) then
			self:GetOwner():ConCommand("wire_teleporter_model " .. trace.Entity:GetModel())
			self:GetOwner():ChatPrint("Teleporter model set to: " .. trace.Entity:GetModel())
		end
	end
end	


function TOOL:UpdateGhostTeleporter( ent, player )

	if ( !ent || !ent:IsValid() ) then return end

	local tr 	= utilx.GetPlayerTrace( player, player:GetCursorAimVector() )
	local trace 	= util.TraceLine( tr )
	
	if (!trace.Hit || trace.Entity:IsPlayer() || trace.Entity:GetClass() == "gmod_wire_emarker" ) then
		ent:SetNoDraw( true )
		return
	end
	
	local Ang = trace.HitNormal:Angle()
	Ang.pitch = Ang.pitch + 90

	local min = ent:OBBMins()
	ent:SetPos( trace.HitPos - trace.HitNormal * min.z )
	ent:SetAngles( Ang )

	ent:SetNoDraw( false )

end

function TOOL:Think()
	local model = self:GetModel()
	
	if (!self.GhostEntity || !self.GhostEntity:IsValid() || self.GhostEntity:GetModel() != model ) then
		self:MakeGhostEntity( Model(model), Vector(0,0,0), Angle(0,0,0) )
	end
	
	self:UpdateGhostTeleporter( self.GhostEntity, self:GetOwner() )
end

function TOOL:GetModel()
	local model = "models/props_c17/utilityconducter001.mdl"
	local modelcheck = self:GetClientInfo( "model" )

	if (util.IsValidModel(modelcheck) and util.IsValidProp(modelcheck)) then
		model = modelcheck
	end
	
	return model
end

if (CLIENT) then
	local TeleModels = { ["models/props_c17/utilityconducter001.mdl"] = {} }

	function TOOL.BuildCPanel(panel)
		panel:AddControl("Header", { Text = "#Tool_wire_teleporter_name", Description = "#Tool_wire_teleporter_desc" })
		CPanel:AddControl( "PropSelect", {
			Label = "#Models (Or click Reload to select a model)",
			ConVar = "wire_teleporter_model",
			Category = "Wire Teleporter",
			Models = TeleModels
		})
	end
end
