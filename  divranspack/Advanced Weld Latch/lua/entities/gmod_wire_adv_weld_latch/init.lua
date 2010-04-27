-- Wire Advanced Weld Latch
-- Made by Divran

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.WireDebugName = "Adv Weld Latch"
ENT.OverlayDelay = 0

function ENT:Initialize()
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Targets = {}
	self.Target = nil
	self.Welded = false
	self.Nocollided = false
	
	self.Inputs = WireLib.CreateInputs( self.Entity, { "Targets [ARRAY]", "Target [ENTITY]", "Weld", "Nocollide" } )
	self.Outputs = WireLib.CreateOutputs( self.Entity, { "Welded", "Nocollided" } )
	
	self:SetOverlayText( "Number of target entities: 0\nTarget: nil\nWelded: No\nNocollided: No" )
end

function ENT:TriggerInput( name, value )
	if (name == "Targets") then
		self.Targets = value
		self:UpdateOutputs()
	elseif (name == "Target") then
		if (value and value:IsValid()) then
			self.Target = value
			self:UpdateOutputs()
		end
	elseif (name == "Weld") then
		if (value != 0) then
			if (self.Welded == false) then
				self.Welded = self:Weld()
				self:UpdateOutputs()
			end
		else
			if (self.Welded == true) then
				self.Welded = self:UnWeld()
				self:UpdateOutputs()
			end
		end
	elseif (name == "Nocollide") then
		if (value != 0) then
			if (self.Nocollided == false) then
				self.Nocollided = self:Nocollide()
				self:UpdateOutputs()
			end
		else
			if (self.Nocollided == true) then
				self.Nocollided = self:UnNocollide()
				self:UpdateOutputs()
			end
		end
	end
end

function ENT:Weld()
	if (#self.Targets > 0 and self.Target and self.Target:IsValid()) then
		for k,v in ipairs( self.Targets ) do
			constraint.Weld(v,self.Target,0,0,0,false)
		end
		return true
	end
	return false
end

function ENT:UnWeld()
	if (#self.Targets > 0 and self.Target and self.Target:IsValid()) then
		for _, ent in ipairs( self.Targets ) do
			if (constraint.HasConstraints( ent )) then
				local con = constraint.FindConstraints( ent, "Weld" )
				for _, const in pairs( con ) do
					if (const.Ent2 == self.Target) then
						const.Constraint:Remove()
						const = nil
					end
				end
			end
		end
		return false
	end
	return true
end

function ENT:Nocollide()
	if (#self.Targets > 0 and self.Target and self.Target:IsValid()) then
		for k,v in ipairs( self.Targets ) do
			constraint.NoCollide(v,self.Target,0,0)
		end
		return true
	end
	return false
end

function ENT:UnNocollide()
	if (#self.Targets > 0 and self.Target and self.Target:IsValid()) then
		for _, ent in ipairs( self.Targets ) do
			if (constraint.HasConstraints( ent )) then
				local con = constraint.FindConstraints( ent, "NoCollide" )
				for _, const in pairs( con ) do
					if (const.Ent2 == self.Target) then
						const.Constraint:Input("EnableCollisions", nil, nil, nil)
						const.Constraint:Remove()
						const = nil
					end
				end
			end
		end
		return false
	end
	return false
end

function ENT:UpdateOutputs()
	-- Trigger outputs
	local n = 0
	if (self.Welded) then n = 1 end
	local n2 = 0
	if (self.Nocollided) then n2 = 1 end
	WireLib.TriggerOutput( self.Entity, "Welded", n )
	WireLib.TriggerOutput( self.Entity, "Nocollided", n2 )
	
	-- Overlay Text
	local t = "No"
	if (self.Welded) then t = "Yes" end
	local t2 = "No"
	if (self.Nocollided) then t = "Yes" end
	self:SetOverlayText( "Number of target entities: " .. #self.Targets .. "\nTarget: " .. tostring(self.Target) .. "\nWelded: " .. t .. "\nNocollided: " .. t2 )
end

function ENT:OnRemove()
	self:UnWeld()
	self:UnNocollide()
end

-- Advanced Duplicator Support
function ENT:ApplyDupeInfo(ply, ent, info, GetEntByID)
	if (!ply:CheckLimit("wire_adv_weld_latches")) then 
		ent:Remove()
		return
	end
	ply:AddCount( "wire_adv_weld_latches", ent )
	self.BaseClass.ApplyDupeInfo(self, ply, ent, info, GetEntByID)
end

