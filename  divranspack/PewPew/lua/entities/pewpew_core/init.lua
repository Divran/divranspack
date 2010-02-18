AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()   
	self.Entity:PhysicsInit( SOLID_VPHYSICS )  	
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )      

	self.Outputs = Wire_CreateOutputs( self.Entity, { "Health", "Total Health" })
	
	self.Props = {}
	self.PropHealth = {}
	self.pewpewCoreHealth = 1
	self.pewpewCoreMaxHealth = 1
	self.Entity.Core = self
	
	Wire_TriggerOutput( self.Entity, "Health", self.pewpewCoreHealth or 0 )
	Wire_TriggerOutput( self.Entity, "Total Health", self.pewpewCoreMaxHealth or 0 )
	
	self.Entity:NextThink( CurTime() + 1 )
	return true
end

function ENT:SetOptions( ply )
	self.Owner = ply
end

function ENT:ClearProp( Entity )
	for key, ent in pairs( self.Props ) do
		if (Entity == ent) then
			table.remove( self.Props, key )
			self.Prophealth[ent:EntIndex()] = nil
		end
	end
end

function ENT:Think()
	-- Get all constrained props
	self.Props = constraint.GetAllConstrainedEntities( self.Entity )
	
	-- Loop through all props
	local hp = self.pewpewCoreHealth
	local maxhp = 1
	for _, ent in pairs( self.Props ) do
		if (ent and pewpew:CheckValid( ent ) and pewpew:CheckAllowed( ent )) then
			local health = self.PropHealth[ent:EntIndex()] or 0
			local enthealth = pewpew:GetHealth( ent )
			if (!ent.Core or !pewpew:CheckValid(ent.Core)) then -- if the entity has no core
				ent.Core = self.Entity
				self.PropHealth[ent:EntIndex()] = enthealth
				hp = hp + enthealth
			elseif (ent.Core and pewpew:CheckValid(ent.Core) and ent.Core == self.Entity and enthealth != health) then -- if the entity's health has changed
				hp = hp - health -- subtract the old health
				hp = hp + enthealth -- add the new health
				self.PropHealth[ent:EntIndex()] = enthealth
			elseif (ent.Core and pewpew:CheckValid( ent.Core ) and ent.Core != self.Entity) then -- if the entity already has a core
				self.Owner:ChatPrint("You cannot have several cores in the same contraption. Core self-destructing.")
					local effectdata = EffectData()
					effectdata:SetOrigin( self.Entity:GetPos() )
					effectdata:SetScale( (self.Entity:OBBMaxs() - self.Entity:OBBMins()):Length() )
					util.Effect( "pewpew_deatheffect", effectdata )
				self:Remove()
				return
			end
			maxhp = maxhp + enthealth
		end
	end
	-- Set health
	self.pewpewCoreHealth = hp
	self.pewpewCoreMaxHealth = maxhp
	
	
	-- Set NW ints
	hp = self.Entity:GetNWInt("pewpewMaxHealth")
	if (!hp or hp != self.pewpewCoreMaxHealth) then
		self.Entity:SetNWInt("pewpewMaxHealth", self.pewpewCoreMaxHealth)
	end
	hp = self.Entity:GetNWInt("pewpewHealth")
	if (!hp or hp != self.pewpewCoreHealth) then
		self.Entity:SetNWInt("pewpewHealth", self.pewpewCoreHealth)
	end
	
	-- Wire Output
	Wire_TriggerOutput( self.Entity, "Health", self.pewpewCoreHealth or 0 )
	Wire_TriggerOutput( self.Entity, "Total Health", self.pewpewCoreMaxHealth or 0 )
	
	-- Run again in 1 second
	self.Entity:NextThink( CurTime() + 1 )
	return true
end


-- Old function
--[[function ENT:Think()
	-- Get all constrained props
	local temp = constraint.GetAllConstrainedEntities( self.Entity )
	
	local nr = 0
	for key, ent in pairs(temp) do
		nr = nr + 1
		self.Props[nr] = ent
	end
	
	local hp = self.pewpewCoreHealth
	for key=1, table.Count( self.Props ) do
		local ent = self.Props[key]
		local health = self.PropHealth[key] or 0
		if (ent and pewpew:CheckValid(ent)) then
			-- If one of them has a valid core, self destruct.
			if (ent.Core and pewpew:CheckValid(ent.Core) and ent != self.Entity and ent.Core != self) then
				self.Owner:ChatPrint("You cannot have several cores in the same contraption. Core self-destructing.")
					local effectdata = EffectData()
					effectdata:SetOrigin( self.Entity:GetPos() )
					effectdata:SetScale( (self.Entity:OBBMaxs() - self.Entity:OBBMins()):Length() )
					util.Effect( "pewpew_deatheffect", effectdata )
				self:Remove()
				return
			elseif (!ent.Core and ent != self.Entity) then
				-- if the entity doesn't have a core
				ent.Core = self
				hp = hp + pewpew:GetHealth( ent )
				if (ent != self.Entity) then
					table.insert( self.PropHealth, pewpew:GetHealth( ent ) )
				end
			elseif (ent.Core and ent.Core == self and health != pewpew:GetHealth( ent )) then
				-- if it does have a core
				hp = hp - health
				hp = hp + pewpew:GetHealth( ent )
				self.PropHealth[key] = pewpew:GetHealth( ent )
			end
		end
	end
	self.pewpewCoreHealth = hp
	
	-- Calculate Max health
	hp = 0
	for _, ent in pairs( self.Props ) do
		hp = hp + pewpew:GetHealth( ent )
	end
	self.pewpewCoreMaxHealth = hp
	
	-- Set NW ints
	if (!self.Entity:GetNWInt("pewpewMaxHealth") or self.Entity:GetNWInt("pewpewMaxHealth") != self.pewpewCoreMaxHealth) then
		self.Entity:SetNWInt("pewpewMaxHealth", self.pewpewCoreMaxHealth)
	end
	if (!self.Entity:GetNWInt("pewpewHealth") or self.Entity:GetNWInt("pewpewHealth") != self.pewpewCoreHealth) then
		self.Entity:SetNWInt("pewpewHealth", self.pewpewCoreHealth)
	end
	
	-- Wire Output
	Wire_TriggerOutput( self.Entity, "Health", self.pewpewCoreHealth or 0 )
	Wire_TriggerOutput( self.Entity, "Total Health", self.pewpewCoreMaxHealth or 0 )
	
	-- Run again in 1 second
	self.Entity:NextThink( CurTime() + 1 )
	return true
end]]


function ENT:RemoveAllProps()
	for _, ent in pairs( self.Props ) do
		local effectdata = EffectData()
		effectdata:SetOrigin( ent:GetPos() )
		effectdata:SetScale( (ent:OBBMaxs() - ent:OBBMins()):Length() )
		util.Effect( "pewpew_deatheffect", effectdata )
		ent:Remove()
	end
	self:Remove()
end