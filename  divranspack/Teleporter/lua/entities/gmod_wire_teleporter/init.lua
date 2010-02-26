AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

ENT.WireDebugName = "Teleporter"

function ENT:Initialize()
	
	self.Entity:SetModel( "models/props_c17/utilityconducter001.mdl" )
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:DrawShadow(false)
	
	local phys = self.Entity:GetPhysicsObject()
	
	self.Jumping = false
	self.TargetPos = Vector(0,0,0)
	self.Entities = {}
	self.LocalPos = {}
	
	self:ShowOutput()
	
	self.Inputs = Wire_CreateInputs( self.Entity, { "Jump", "TargetPos [VECTOR]", "X", "Y", "Z" } )
end

CreateConVar("sbox_maxwire_teleporters", 2)
local function MakeWireTeleporter( ply, Data )
	if (!ply:CheckLimit("wire_teleporters")) then return end
	
	local ent = ents.Create("gmod_wire_teleporter")
	if (!ent:IsValid()) then return end
	ent:SetPlayer(ply)
	duplicator.DoGeneric(ent, Data)
	ent:Spawn()
	ent:Activate()
	duplicator.DoGenericPhysics(ent, pl, Data)
	
	ply:AddCount("wire_teleporters", ent)
	ply:AddCleanup("teleporters", ent)
	return ent
end
duplicator.RegisterEntityClass("gmod_wire_teleporter", MakeWireTeleporter, "Data")

function ENT:SpawnFunction( pl, tr )
	
	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	
	local ent = MakeWireTeleporter( pl, {Pos = SpawnPos} )
	
	return ent
end

function ENT:TriggerInput(iname, value)
	if (iname == "Jump") then
		if (value != 0 and !self.Jumping) then
			self:Jump()
		end
	elseif (iname == "TargetPos") then
		self.TargetPos = value
	elseif (iname == "X") then
		self.TargetPos.x = value
	elseif (iname == "Y") then
		self.TargetPos.y = value
	elseif (iname == "Z") then
		self.TargetPos.z = value
	end
	self:ShowOutput()
end

function ENT:ShowOutput()
	local str = "none"
	if (self.TargetPos) then
		str = tostring(self.TargetPos)
	end
	self:SetOverlayText( "-Teleporter-\nTarget Position = " .. str )
end

function ENT:Jump()		
	-- Check for errors
	
	-- Is already teleporting
	if (self.Jumping) then 
		return 
	end

	-- TargetPos doesn't exist
	if (!self.TargetPos) then
		self.Entity:EmitSound("buttons/button8.wav")
		return
	end
	
	-- The target position is outside the world
	if (!util.IsInWorld( self.TargetPos )) then
		self.Entity:EmitSound("buttons/button8.wav")
		return
	end
	
	-- The position hasn't changed
	if (self.Entity:GetPos() == self.TargetPos) then
		self.Entity:EmitSound("buttons/button8.wav")
		return
	end
	
	-- Get the localized positions
	local ents = constraint.GetAllConstrainedEntities( self.Entity )
	
	-- Check world
	for _, ent in pairs( ents ) do
		-- An entity's position will be outside the world after teleporting
		if (self:CheckAllowed( ent ) and !util.IsInWorld( self.TargetPos + (ent:GetPos() - self.Entity:GetPos()))) then
			self.Entity:EmitSound("buttons/button8.wav")
			return
		end
	end
	
	self.Jumping = true
	
	-- Starting sound
	self.Entity:EmitSound("ambient/levels/citadel/weapon_disintegrate2.wav")
	
	-- Save local positions
	self.Entities = {}
	self.LocalPos = {}
	for _, ent in pairs( ents ) do
		if (self:CheckAllowed( ent ) and ent != self.Entity) then			
			-- Save the entity
			table.insert(self.Entities, ent )
			-- Check for bones
			if (ent:GetPhysicsObjectCount() > 1) then
				local tbl = {}
				for i=0, ent:GetPhysicsObjectCount()-1 do
					tbl[i] = self.Entity:WorldToLocal( ent:GetPhysicsObjectNum( i ):GetPos() )
				end
				-- Save the localized position table
				self.LocalPos[ent:EntIndex()] = tbl
			else
				-- Save the localized position
				self.LocalPos[ent:EntIndex()] = self.Entity:WorldToLocal( ent:GetPos() )
			end
		end
	end

	-- Get the directions for the effects
	local Dir1 = (self.TargetPos - self.Entity:GetPos()):Normalize()
	local Dir2 = (self.Entity:GetPos() - self.TargetPos):Normalize()
	
	-- Teleport self
	self.Entity:SetPos( self.TargetPos )
	
	-- End sound
	self.Entity:EmitSound("npc/turret_floor/die.wav", 450, 70)

	-- Effect in
	local effectdata = EffectData()
	effectdata:SetEntity( self.Entity )
	effectdata:SetOrigin( self.Entity:GetPos() + Dir2 * math.Clamp( self.Entity:BoundingRadius() * 5, 180, 4092 ) )
	util.Effect( "jump_in", effectdata )
	DoPropSpawnedEffect( self.Entity )	

	-- Teleport others
	for _, ent in pairs( self.Entities ) do
		if (self.LocalPos[ent:EntIndex()]) then			
			-- Check for bones
			if (ent:GetPhysicsObjectCount() > 1) then
				for i=0, ent:GetPhysicsObjectCount()-1 do
					-- Teleport each bone
					ent:GetPhysicsObjectNum( i ):SetPos( self.Entity:LocalToWorld(self.LocalPos[ent:EntIndex()][i]) )
					ent:GetPhysicsObject():Wake()
				end
			else
				-- Set pos
				ent:SetPos( self.Entity:LocalToWorld(self.LocalPos[ent:EntIndex()]) )
				DoPropSpawnedEffect( ent )
			end
			
			-- Effect in
			effectdata = EffectData()
			effectdata:SetEntity( ent )
			effectdata:SetOrigin( self.Entity:GetPos() + Dir2 * math.Clamp( ent:BoundingRadius() * 5, 180, 4092 ) )
			util.Effect( "jump_in", effectdata )
		end
	end
	
	-- 2 second delay
	timer.Create("teleporter_"..self.Entity:EntIndex(),2,1,function( e ) e.Jumping = false end, self)
end

function ENT:CheckAllowed( e )
	if (e:GetParent():EntIndex() != 0) then return false end
	return true
end