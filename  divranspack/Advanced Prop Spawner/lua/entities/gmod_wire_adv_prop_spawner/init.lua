
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.WireDebugName = "Adv Prop Spawner"
ENT.OverlayDelay = 0

function ENT:Initialize()
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	AddAdvPropSpawner( self )
	
	self.Ghost = nil
	self.Ghost = ents.Create("gmod_wire_hologram")
	self.Ghost:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
	self.Ghost:SetPos( self.Entity:GetPos() + self.Entity:GetUp() * ((self.Ghost:OBBMaxs().z-self.Ghost:OBBMins().z) / 2 + 30) )
	self.Ghost:SetAngles( self.Entity:GetAngles() )
	self.Ghost:Spawn()
	self.Ghost:Activate()
	self.Ghost:SetParent(self.Entity)
	
	local r,g,b,a = self.Entity:GetColor()
	self.Ghost:SetColor( r,g,b,a )
	
	self.Props = {}
	
	self.Material = self.Entity:GetMaterial()
	self.Color = Color(r,g,b,a)
	self.Skin = self.Entity:GetSkin() or 0
	self.Model = "models/Combine_Helicopter/helicopter_bomb01.mdl"
	self.Mass = 35
	self.Gravity = true
	self.GhostVisible = true
	
	self.Inputs = WireLib.CreateInputs( self.Entity, { "Position [VECTOR]", "Angle [ANGLE]", "Model [STRING]", "Color [VECTOR4]", "Material [STRING]", "Skin", "Mass", "No Gravity", "Hide Ghost", "Spawn", "Undo" } )
	self.Outputs = WireLib.CreateOutputs( self.Entity, { "Amount", "LastSpawned [ENTITY]", "Props [ARRAY]" } )
	self:SetOverlayText( "Active Props: 0" )
end

function ENT:CheckEnt( ent )
	for k,v in pairs( self.Props ) do
		if (v == ent) then
			return true, k
		end
	end
	return false, 0
end

function ENT:RemoveEnt( ent )
	local bool, index = self:CheckEnt( ent )
	if (bool) then
		table.remove( self.Props, index )
		self:UpdateOutputs()
	end
end

function ENT:TriggerInput( name, value )
	if (name == "Model") then
		if (util.IsValidModel( value ) and util.IsValidProp( value )) then
			self.Ghost:SetModel( value )
			self.Model = value
		end
	elseif (name == "Color") then
		self.Color = Color(math.Clamp(value[1],0,255),math.Clamp(value[2],0,255),math.Clamp(value[3],0,255),math.Clamp(value[4],0,255))
		self.Ghost:SetColor(self.Color.r, self.Color.g, self.Color.b, self.Color.a)
		if (self.HideGhost) then
			self.Ghost:SetColor(self.Color.r, self.Color.g, self.Color.b, 0)
		else
			self.Ghost:SetColor(self.Color.r, self.Color.g, self.Color.b, self.Color.a)
		end
	elseif (name == "Material") then
		self.Material = value
		self.Ghost:SetMaterial( value )
	elseif (name == "Skin") then
		self.Skin = value
		self.Ghost:SetSkin( value )
	elseif (name == "Mass") then
		self.Mass = math.Clamp(value,0.01,50000)
	elseif (name == "NoGravity") then
		if (value != 0) then
			self.Gravity = false
		else
			self.Gravity = true
		end
	elseif (name == "Spawn") then
		if (value != 0) then
			self:SpawnProp()
		end
	elseif (name == "Position") then
		if (value == Vector(0,0,0)) then
			value = self.Entity:GetPos() + self.Entity:GetUp() * ((self.Ghost:OBBMaxs().z-self.Ghost:OBBMins().z) / 2 + 30)
		else
			if (value:Distance(self.Entity:GetPos()) > 500) then
				local Dir = value-self.Entity:GetPos()
				value = self.Entity:GetPos() + Dir:GetNormalized() * 500
			end
		end
		self.Ghost:SetPos(value)
	elseif (name == "Angle") then
		self.Ghost:SetAngles( value )
	elseif (name == "Undo") then
		if (value != 0) then
			if (#self.Props) then
				local ent = self.Props[#self.Props]
				if (ent and ent:IsValid()) then
					self:RemoveEnt(#self.Props)
					ent:Remove()
					WireLib.AddNotify(self:GetPlayer(), "Undone Prop", NOTIFY_UNDO, 2 )
					self:UpdateOutputs()
				end
			end
		end
	elseif (name == "Hide Ghost") then
		if (value == 0) then
			self.HideGhost = false
			self.Ghost:SetColor(self.Color.r,self.Color.g,self.Color.b,self.Color.a)
		elseif (value == 1) then
			self.HideGhost = true
			self.Ghost:SetColor(self.Color.r,self.Color.g,self.Color.b,0)
		elseif (value == 2) then
			self.HideGhost = true
			self.Ghost:SetColor(self.Color.r,self.Color.g,self.Color.b,100)
		end
	end
end

function ENT:UpdateOutputs()
	self:SetOverlayText( "Active Props: " .. #self.Props )
	
	Wire_TriggerOutput( self.Entity, "Amount", #self.Props )
	Wire_TriggerOutput( self.Entity, "LastSpawned", self.Props[#self.Props] )
	Wire_TriggerOutput( self.Entity, "Props", self.Props )
end

function ENT:SpawnProp()
	-- Ply
	local ply = self:GetPlayer()
	
	-- Create Prop
	local ent = MakeProp( ply, self.Ghost:GetPos(), self.Ghost:GetAngles(), self.Model, {}, {} )
	if (!ent) then return end
	
	---- Appearance
	-- Material
	ent:SetMaterial( self.Material )
	
	-- Color
	local clr = self.Color
	ent:SetColor( clr.r, clr.g, clr.b, clr.a )
	
	-- Skin
	ent:SetSkin( self.Skin or 0 )
	
	-- Material
	ent:SetMaterial( self.Material )
	
	---- Physics
	-- Gravity
	local g = 1
	if (self.Gravity == false) then g = 0 end
	ent:SetGravity( g )
	
	-- Mass
	local phys = self.Entity:GetPhysicsObject()
	local phys2 = ent:GetPhysicsObject()
	phys2:SetMass( self.Mass )
	
	-- Gravity
	construct.SetPhysProp( ply, ent, 0, nil,  { GravityToggle = self.Gravity } ) 
	
	-- Velocity
	if (!self.Entity:IsPlayerHolding()) then
		phys2:SetVelocity( phys:GetVelocity() )
		phys:AddAngleVelocity( phys:GetAngleVelocity() - phys2:GetAngleVelocity() )
	end
	
	-- Add Undo
	undo.Create("Prop")
		undo.AddEntity( ent )
		undo.SetPlayer( ply )
	undo.Finish()
	
	-- Add Cleanup
	ply:AddCleanup( "props", ent )
	
	-- Add to table
	table.insert( self.Props, ent )
	
	-- Update
	self:UpdateOutputs()
end


function ENT:ApplyDupeInfo(ply, ent, info, GetEntByID)
	self:SetPlayer(ply)
	self:Initialize()
	self.BaseClass.ApplyDupeInfo(self, ply, ent, info, GetEntByID)
end