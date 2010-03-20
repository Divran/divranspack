TOOL.Category		= "Wire - Physics"
TOOL.Name			= "Teleporter"
TOOL.Command		= nil
TOOL.ConfigName		= ""
TOOL.Tab			= "Wire"

if ( CLIENT ) then
    language.Add( "Tool_wire_teleporter_name", "Teleporter Tool" )
    language.Add( "Tool_wire_teleporter_desc", "Spawns a Teleporter." )
    language.Add( "Tool_wire_teleporter_0", "Primary: Create Teleporter, Reload: Change Teleporter Model" )
	language.Add( "sboxlimit_wire_teleporter", "You've hit the teleporter limit!" )
	language.Add( "undone_wire_teleporter", "Undone Teleporter" )
elseif ( SERVER ) then
    CreateConVar('sbox_maxwire_teleporters',2)
end

TOOL.ClientConVar[ "model" ] = "models/props_c17/utilityconducter001.mdl"
cleanup.Register( "wire_teleporters" )


function TOOL:GetModel()
	local mdl = self:GetClientInfo("model")
	if (!util.IsValidModel(mdl) or !util.IsValidProp(mdl)) then return "models/props_c17/utilityconducter001.mdl" end
	return mdl
end

if (SERVER) then
	function TOOL:CreateTeleporter( ply, trace, Model )
		if (!ply:CheckLimit("wire_teleporters")) then return end
		local ent = ents.Create( "gmod_wire_teleporter" )
		if (!ent:IsValid()) then return end
		
		-- Pos/Model/Angle
		ent:SetModel( Model )
		ent:SetPos( trace.HitPos - trace.HitNormal * ent:OBBMins().z )
		ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0) )
		
		ent:Spawn()
		ent:Activate()
		
		ply:AddCount( "wire_teleporters", ent )
		
		return ent
	end
	
	function TOOL:LeftClick( trace )
		if (!trace) then return end
		local ply = self:GetOwner()
	
		local ent = self:CreateTeleporter( ply, trace, self:GetModel() )
		
		local const = WireLib.Weld( ent, trace.Entity, trace.PhysicsBone, true )
		undo.Create("wire_teleporter")
			undo.AddEntity( ent )
			undo.AddEntity( const )
			undo.SetPlayer( ply )
		undo.Finish()

		ply:AddCleanup( "wire_teleporters", ent )

		return true
	end
	
	
else
	function TOOL:LeftClick( trace ) return !trace.Entity:IsPlayer() end
	
	local TeleModels = { ["models/props_c17/utilityconducter001.mdl"] = {},
						 ["models/Combine_Helicopter/helicopter_bomb01.mdl"] = {},
						 ["models/props_combine/combine_interface001.mdl"] = {},
						 ["models/props_combine/combine_interface002.mdl"] = {},
						 ["models/props_combine/combine_interface003.mdl"] = {},
						 ["models/props_combine/combine_emitter01.mdl"] = {},
						 ["models/props_junk/sawblade001a.mdl"] = {},
						 ["models/props_combine/health_charger001.mdl"] = {},
						 ["models/props_combine/suit_charger001.mdl"] = {},
						 ["models/props_lab/reciever_cart.mdl"] = {},
						 ["models/props_lab/reciever01a.mdl"] = {},
						 ["models/props_lab/reciever01b.mdl"] = {},
						 ["models/props_lab/reciever01d.mdl"] = {},
						 ["models/props_c17/pottery03a.mdl"] = {},
						 ["models/props_wasteland/laundry_washer003.mdl"] = {} }

	function TOOL.BuildCPanel(panel)
		panel:AddControl("Header", { Text = "#Tool_wire_teleporter_name", Description = "#Tool_wire_teleporter_desc" })
		panel:AddControl( "PropSelect", {
			Label = "#Models (Or click Reload to select a model)",
			ConVar = "wire_teleporter_model",
			Category = "Teleporter",
			Models = TeleModels
		})
	end
end

function TOOL:Reload( trace )
	if (!trace) then return end
	if (!trace.Hit) then return end
	if (trace.Entity) then
		if (CLIENT) then
			RunConsoleCommand("wire_teleporter_model", trace.Entity:GetModel())
		else
			self:GetOwner():ChatPrint("Teleporter model set to: " .. trace.Entity:GetModel())
		end
	end
	return true
end
	
function TOOL:UpdateGhostTeleporter( ent, ply )
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

function TOOL:Think()
	local model = self:GetModel()
	
	if (!self.GhostEntity or !self.GhostEntity:IsValid() or self.GhostEntity:GetModel() != model ) then
		self:MakeGhostEntity( Model(model), Vector(0,0,0), Angle(0,0,0) )
	end
	
	self:UpdateGhostTeleporter( self.GhostEntity, self:GetOwner() )
end