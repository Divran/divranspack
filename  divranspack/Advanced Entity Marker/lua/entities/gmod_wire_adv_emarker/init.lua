
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.WireDebugName = "Adv EMarker"
ENT.OverlayDelay = 0

function ENT:Initialize()
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Target = nil
	
	AddAdvEMarker( self.Entity )
	
	self.Marks = {}
	self.Inputs = WireLib.CreateInputs( self.Entity, { "Entity [ENTITY]", "Add Entity", "Remove Entity", "Clear Entities" } )
	self.Outputs = WireLib.CreateOutputs( self.Entity, { "First Entity [ENTITY]", "Entities [ARRAY]", "Nr" } )
	self:SetOverlayText( "Number of entities linked: 0" )
end

function ENT:TriggerInput( name, value )
	if (name == "Entity") then
		if (value:IsValid()) then
			self.Target = value
		end
	elseif (name == "Add Entity") then
		if (self.Target and self.Target:IsValid()) then
			if (value != 0) then
				local bool, index = self:CheckEnt( self.Target )
				if (!bool) then
					self:AddEnt( self.Target )
				end
			end
		end
	elseif (name == "Remove Entity") then
		if (self.Target and self.Target:IsValid()) then
			if (value != 0) then
				local bool, index = self:CheckEnt( self.Target )
				if (bool) then
					self:RemoveEnt( self.Target )
				end
			end
		end
	elseif (name == "Clear Entities") then
		for _, ent in pairs( self.Marks ) do
			self:RemoveEnt( ent )
		end
	end
end

function ENT:UpdateOutputs()
	if (self.Marks and self.Marks[1] and self.Marks[1]:IsValid()) then Wire_TriggerOutput( self.Entity, "First Entity", self.Marks[1] ) end
	Wire_TriggerOutput( self.Entity, "Entities", self.Marks )
	Wire_TriggerOutput( self.Entity, "Nr", #self.Marks )
	self:SetOverlayText( "Number of entities linked: " .. #self.Marks )
	self.Entity:SetNWString( "Adv_EMarker_Marks", glon.encode( self.Marks ) )
end

function ENT:CheckEnt( ent )
	for index, e in pairs( self.Marks ) do
		if (e == ent) then return true, index end
	end
	return false, 0
end

function ENT:AddEnt( ent )
	if (self:CheckEnt( ent )) then return false	end
	self.Marks[#self.Marks+1] = ent
	self:UpdateOutputs()
	return true
end

function ENT:RemoveEnt( ent )
	local bool, index = self:CheckEnt( ent )
	if (bool) then
		table.remove( self.Marks, index )
		self:UpdateOutputs()
	end
end



// Advanced Duplicator Support

function ENT:BuildDupeInfo()
	local info = self.BaseClass.BuildDupeInfo(self) or {}
	
	if (#self.Marks) then
		local tbl = {}
		for index, e in pairs( self.Marks ) do
			tbl[index] = e:EntIndex()
		end
		
		info.marks = tbl
	end
	
	return info
end

function ENT:ApplyDupeInfo(ply, ent, info, GetEntByID)
	self.BaseClass.ApplyDupeInfo(self, ply, ent, info, GetEntByID)

	if (info.marks) then
		local tbl = info.marks
		
		if (!self.Marks) then self.Marks = {} end
		
		for index, entindex in pairs( tbl ) do
			self.Marks[index] = GetEntByID(entindex) or ents.GetByIndex(entindex)
		end
		self:UpdateOutputs()
	end
end
