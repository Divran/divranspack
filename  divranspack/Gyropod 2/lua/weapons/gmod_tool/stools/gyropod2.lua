-- Gyropod 2 tool

TOOL.Category = "Construction"
TOOL.Name = "GyroPod 2"

cleanup.Register("gyropod2")

TOOL.ClientConVar[ "model" ] = "models/props_c17/oildrum001.mdl"

local Models	 = { 	["models/combatmodels/tank_gun.mdl"] = {},
						["models/bull/pewpew_cannon_small.mdl"] = {},
						["models/bull/pewpew_cannon_medium.mdl"] = {},
						["models/bull/pewpew_cannon_big.mdl"] = {},
						["models/props_junk/TrafficCone001a.mdl"] = {},
						["models/props_lab/huladoll.mdl"] = {},
						["models/props_c17/oildrum001.mdl"] = {},
						["models/props_trainstation/trainstation_column001.mdl"] = {},
						["models/Items/combine_rifle_ammo01.mdl"] = {},
						["models/props_combine/combine_mortar01a.mdl"] = {},
						["models/props_combine/breenlight.mdl"] = {},
						["models/props_c17/pottery03a.mdl"] = {},
						["models/props_junk/PopCan01a.mdl"] = {},
						["models/props_trainstation/trainstation_post001.mdl"] = {},
						["models/props_c17/signpole001.mdl"] = {} }


-- This needs to be shared...
function TOOL:GetModel()
	local mdl = self:GetClientInfo("model")
	if (!util.IsValidModel(mdl) or !util.IsValidProp(mdl)) then return "models/props_c17/oildrum001.mdl" end
	return mdl
end
						
if (SERVER) then
	AddCSLuaFile("gyropod2.lua")
	CreateConVar("sbox_maxgyropod2", 5)

	function TOOL:CreatePod( ply, trace, Model )
		if (!ply:CheckLimit("gyropod2")) then return end
		local ent = ents.Create( "gyropod2" )
		if (!ent:IsValid()) then return end
		
		-- Pos/Model/Angle
		ent:SetModel( Model )
		ent:SetPos( trace.HitPos - trace.HitNormal * ent:OBBMins().z )
		ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0) )
		
		ent:SetPlayer(ply)
		
		ent:Spawn()
		ent:Activate()
		return ent
	end
	
	function TOOL:LeftClick( trace )
		if (!trace) then return end
		local ply = self:GetOwner()
		if (trace.Hit) then
			local ent = self:CreatePod( ply, trace, self:GetModel() )
				
			ply:AddCount( "gyropod2", ent)
			ply:AddCleanup( "gyropod2", ent )

			undo.Create( "gyropod2" )
				undo.AddEntity( ent )
				undo.SetPlayer( ply )
			undo.Finish()
			
			return true
		end
			
		return false
	end
	
	function TOOL:Reload( trace )
		if (trace.Hit) then
			if (trace.Entity and ValidEntity(trace.Entity) and !trace.Entity:IsPlayer()) then
				self:GetOwner():ConCommand("gyropod2_model " .. trace.Entity:GetModel())
				self:GetOwner():ChatPrint("Gyropod model set to: " .. trace.Entity:GetModel())
			end
		end
	end	
else
	language.Add( "Tool_gyropod2_name", "Gyropod 2 Tool" )
	language.Add( "Tool_gyropod2_desc", "Used to spawn Gyropods." )
	language.Add( "Tool_gyropod2_0", "Primary: Spawn a Gyropod, Reload: Change the model of the Gyropod." )
	language.Add( "undone_gyropod2", "Undone Gyropod" )
	language.Add( "Cleanup_gyropod2", "Gyropods" )
	language.Add( "Cleaned_gyropod2", "Cleaned up all Gyropods" )
	language.Add( "SBoxLimit_gyropod2", "You've reached the Gyropod limit!" )
	
	
	function TOOL.BuildCPanel( CPanel )
		-- Header stuff
		CPanel:ClearControls()
		CPanel:AddHeader()
		CPanel:AddDefaultControls()
		CPanel:AddControl("Header", { Text = "#Tool_gyropod2_name", Description = "#Tool_gyropod2_desc" })
		
		CPanel:AddControl("ComboBox", {
			Label = "#Presets",
			MenuButton = "1",
			Folder = "gyropod2",

			Options = {
				Default = {
					pewpew_model = "models/combatmodels/tank_gun.mdl",
					pewpew_bulletname = "",
				}
			},

			CVars = {
				[0] = "gyropod2_model",
			}
		})
		
		CPanel:AddControl( "PropSelect", {
			Label = "#Models (Or click Reload to select a model)",
			ConVar = "gyropod2_model",
			Category = "Gyropod",
			Models = Models
		})
	end

	-- Ghost functions
	function TOOL:UpdateGhost( ent, player )
		if (!ent) then return end
		if (!ent:IsValid()) then return end
		local trace = player:GetEyeTrace()
		
		ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0) )
		ent:SetPos( trace.HitPos - trace.HitNormal * ent:OBBMins().z )
		
		ent:SetNoDraw( false )
	end
	
	function TOOL:Think()
		local model = self:GetModel()
		if (!self.GhostEntity or !self.GhostEntity:IsValid() or self.GhostEntity:GetModel() != model) then
			local trace = self:GetOwner():GetEyeTrace()
			self:MakeGhostEntity( Model(model), trace.HitPos, trace.HitNormal:Angle() + Angle(90,0,0) )
		end
		self:UpdateGhost( self.GhostEntity, self:GetOwner() )
	end
end