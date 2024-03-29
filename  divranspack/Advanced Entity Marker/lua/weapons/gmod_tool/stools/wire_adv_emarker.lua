TOOL.Category		= "Wire - Detection"
TOOL.Name			= "Adv Entity Marker"
TOOL.Command		= nil
TOOL.ConfigName		= ""
TOOL.Tab			= "Wire"

if ( CLIENT ) then
    language.Add( "Tool_wire_adv_emarker_name", "Adv Entity Marker Tool (Wire)" )
    language.Add( "Tool_wire_adv_emarker_desc", "Spawns an Adv Entity Marker for use with the wire system." )
    language.Add( "Tool_wire_adv_emarker_0", "Primary: Create Entity Marker, Secondary: Add a link, Reload: Remove a link" )
	language.Add( "Tool_wire_adv_emarker_1", "Now select the entity to link to.")
	language.Add( "Tool_wire_adv_emarker_2", "Now select the entity to unlink." )
	language.Add( "sboxlimit_wire_adv_emarker", "You've hit adv entity marker limit!" )
	language.Add( "undone_wire_adv_emarker", "Undone Adv Wire Entity Marker" )
elseif ( SERVER ) then
    CreateConVar('sbox_maxwire_adv_emarkers',3)
end

TOOL.ClientConVar[ "model" ] = "models/jaanus/wiretool/wiretool_siren.mdl"
cleanup.Register( "wire_adv_emarkers" )


function TOOL:GetModel()
	local mdl = self:GetClientInfo("model")
	if (!util.IsValidModel(mdl) or !util.IsValidProp(mdl)) then return "models/jaanus/wiretool/wiretool_siren.mdl" end
	return mdl
end

local AdvEntityMarkers = {}

function AddAdvEMarker( ent )
	table.insert( AdvEntityMarkers, ent )
end

local function CheckRemovedEnt( ent )
	for index, e in pairs( AdvEntityMarkers ) do
		if (e:IsValid()) then
			if (e == ent) then
				table.remove( AdvEntityMarkers, index )
			else
				local bool, index = e:CheckEnt( ent )
				if (bool) then
					e:RemoveEnt( ent )
				end
			end
		end
	end
end
hook.Add("EntityRemoved","AdvEntityMarkerEntRemoved",CheckRemovedEnt)

if (SERVER) then
	function TOOL:CreateMarker( ply, trace, Model )
		if (!ply:CheckLimit("wire_adv_emarkers")) then return end
		local ent = ents.Create( "gmod_wire_adv_emarker" )
		if (!ent:IsValid()) then return end
		
		-- Pos/Model/Angle
		ent:SetModel( Model )
		ent:SetPos( trace.HitPos - trace.HitNormal * ent:OBBMins().z )
		ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0) )
		
		ent:SetPlayer( ply )
		
		ent:Spawn()
		ent:Activate()
		
		ply:AddCount( "wire_adv_emarkers", ent )
		
		return ent
	end
	
	function TOOL:LeftClick( trace )
		if (!trace) then return end
		local ply = self:GetOwner()
	
		local ent = self:CreateMarker( ply, trace, self:GetModel() )
		
		local const = WireLib.Weld( ent, trace.Entity, trace.PhysicsBone, true )
		undo.Create("wire_adv_emarker")
			undo.AddEntity( ent )
			undo.AddEntity( const )
			undo.SetPlayer( ply )
		undo.Finish()

		ply:AddCleanup( "wire_adv_emarkers", ent )

		return true
	end
	
	
	function TOOL:RightClick( trace )
		if (!trace) then return end
		local ply = self:GetOwner()
		
		if (trace.Entity:IsValid()) then
			local ent = trace.Entity
			if (self:GetStage() == 0 and ent:GetClass() == "gmod_wire_adv_emarker") then
				self.marker = ent
				self:SetStage(1)
			elseif (self:GetStage() == 1) then
				local ret = self.marker:AddEnt(ent)
				if (ret) then
					self:SetStage(0)
					ply:ChatPrint("Added entity: " .. tostring(ent) .. " to the Adv Entity Marker.")
				else
					ply:ChatPrint("The Entity Marker is already linked to that entity.")
				end
			end
		end
		
		return true
	end
	
	function TOOL:Reload( trace )
		if (!trace) then return end
		local ply = self:GetOwner()
		
		if (trace.Entity:IsValid()) then
			local ent = trace.Entity
			if (self:GetStage() == 0 and ent:GetClass() == "gmod_wire_adv_emarker") then
				self.marker = ent
				self:SetStage(2)
			elseif (self:GetStage() == 2) then
				local ret = self.marker:CheckEnt(ent)
				if (ret) then
					self:SetStage(0)
					self.marker:RemoveEnt( ent )
					ply:ChatPrint("Removed entity: " .. tostring(ent) .. " from the Adv Entity Marker.")
				else
					ply:ChatPrint("The Entity Marker is not linked to that entity.")
				end
			end
		end
		
		return true
	end
else
	function TOOL:LeftClick( trace ) return !trace.Entity:IsPlayer() end
	function TOOL:RightClick( trace ) return !trace.Entity:IsPlayer() end
	function TOOL:Reload( trace ) return !trace.Entity:IsPlayer() end
	
	function TOOL.BuildCPanel(panel)
		panel:AddControl("Header", { Text = "#Tool_wire_adv_emarker_name", Description = "#Tool_wire_adv_emarker_desc" })
		WireDermaExts.ModelSelect(panel, "wire_adv_emarker_model", list.Get( "Wire_Misc_Tools_Models" ), 8)
	end
end
	
function TOOL:UpdateGhostEmarker( ent, ply )
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
	
	self:UpdateGhostEmarker( self.GhostEntity, self:GetOwner() )
	
	local ply = self:GetOwner()
	local trace = ply:GetEyeTrace()
	if (trace.Hit and trace.Entity and trace.Entity:IsValid() and trace.Entity:GetClass() == "gmod_wire_adv_emarker") then
		if (trace.Entity != self.viewing) then
			self.viewing = trace.Entity
		end
	end
end

function TOOL:DrawHUD()
	if (self.viewing and self.viewing:IsValid()) then
		local marks = glon.decode(self.viewing:GetNWString( "Adv_EMarker_Marks" ))
		if (marks and #marks > 0) then
			local markerpos = self.viewing:GetPos():ToScreen()
			for _, ent in pairs( marks ) do
				if (ent:IsValid()) then
					local markpos = ent:GetPos():ToScreen()
					if ( markpos.x > 0 and markpos.x < ScrW() and
						 markpos.y > 0 and markpos.y < ScrW() ) then
						surface.SetDrawColor( 255,255,100,255 )
						surface.DrawLine( markerpos.x, markerpos.y, markpos.x, markpos.y )
					end
				end
			end
		end
	end
end