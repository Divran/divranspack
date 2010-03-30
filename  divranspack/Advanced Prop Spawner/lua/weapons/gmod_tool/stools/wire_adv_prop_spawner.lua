TOOL.Category		= "Wire - Physics"
TOOL.Name			= "Adv Prop Spawner"
TOOL.Command		= nil
TOOL.ConfigName		= ""
TOOL.Tab			= "Wire"

if ( CLIENT ) then
    language.Add( "Tool_wire_adv_prop_spawner_name", "Adv Prop Spawner Tool (Wire)" )
    language.Add( "Tool_wire_adv_prop_spawner_desc", "Spawns an Adv Prop Spawner for use with the wire system." )
    language.Add( "Tool_wire_adv_prop_spawner_0", "Primary: Create Prop Spawner" )
	language.Add( "sboxlimit_wire_adv_prop_spawner", "You've hit adv prop spawner limit!" )
	language.Add( "undone_wire_adv_prop_spawner", "Undone Adv Prop Spawner" )
elseif ( SERVER ) then
    CreateConVar('sbox_maxwire_adv_prop_spawners',3)
end

cleanup.Register( "wire_adv_prop_spawners" )

local AdvPropSpawners = {}

function AddAdvPropSpawner( ent )
	table.insert( AdvPropSpawners, ent )
end

local function CheckRemovedEnt( ent )
	for _, e in pairs( AdvPropSpawners ) do
		if (e:IsValid()) then
			if (e == ent) then
				table.remove( AdvPropSpawners, index )
			else
				e:RemoveEnt( ent )
			end
		end
	end
end
hook.Add("EntityRemoved","AdvPropSpawnerRemoved",CheckRemovedEnt)

if (SERVER) then
	function TOOL:CreateSpawner( ply, trace )
		if (!ply:CheckLimit("wire_adv_prop_spawners")) then return end
		local ent = ents.Create( "gmod_wire_adv_prop_spawner" )
		if (!ent:IsValid()) then return end
		
		-- Pos/Model/Angle
		ent:SetModel( "models/jaanus/wiretool/wiretool_siren.mdl" )
		ent:SetPos( trace.HitPos - trace.HitNormal * ent:OBBMins().z )
		ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0) )
		
		ent:SetPlayer( ply )
		
		ent:Spawn()
		ent:Activate()
		
		ply:AddCount( "wire_adv_prop_spawners", ent )
		
		return ent
	end
	
	function TOOL:LeftClick( trace )
		if (!trace) then return end
		local ply = self:GetOwner()
	
		local ent = self:CreateSpawner( ply, trace )
		undo.Create("wire_adv_prop_spawner")
			undo.AddEntity( ent )
			undo.SetPlayer( ply )
		undo.Finish()

		ply:AddCleanup( "wire_adv_prop_spawners", ent )

		return true
	end
else
	function TOOL:LeftClick( trace ) return !trace.Entity:IsPlayer() end
	
	function TOOL.BuildCPanel(panel)
		panel:AddControl("Header", { Text = "#Tool_wire_adv_prop_spawner_name", Description = "#Tool_wire_adv_prop_spawner_desc" })
	end
end
	
function TOOL:UpdateGhostSpawner( ent, ply )
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
	if (!self.GhostEntity or !self.GhostEntity:IsValid()) then
		self:MakeGhostEntity( Model("models/jaanus/wiretool/wiretool_siren.mdl"), Vector(0,0,0), Angle(0,0,0) )
	end
	
	self:UpdateGhostSpawner( self.GhostEntity, self:GetOwner() )
end