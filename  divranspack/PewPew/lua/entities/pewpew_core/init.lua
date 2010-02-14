AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()   
	self.Entity:PhysicsInit( SOLID_VPHYSICS )  	
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )      

	self.Outputs = Wire_CreateOutputs( self.Entity, { "Total Health" })
	
	self.Props = {}
	self.PropHealth = {}
	self.pewpewCoreHealth = 1
	self.Entity.Core = self
	--table.insert( self.Props, {self.Entity, pewpew:GetHealth( self.Entity ) } )
	
	Wire_TriggerOutput( self.Entity, "Total Health", self.pewpewCoreHealth )
	
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
			table.remove( self.PropHealth, key )
		end
	end
end

function ENT:Think()
	-- Get all constrained props
	local temp = constraint.GetAllConstrainedEntities( self.Entity )
	
	local nr = 0
	for key, ent in pairs(temp) do
		nr = nr + 1
		self.Props[nr] = ent
	end
	
	local hp = self.pewpewCoreHealth
	-- Calculate their total health
	--for key, ent in pairs( self.Props ) do
	for key=1, table.Count( self.Props ) do
		local ent = self.Props[key]
		local health = self.PropHealth[key] or 0
		print("KEY: " .. tostring(key) .. " ENT: " .. tostring(ent) .. " HEALTH: " .. tostring(health) )
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
	
	-- Wire Output
	Wire_TriggerOutput( self.Entity, "Total Health", self.pewpewCoreHealth or 0 )
	
	-- Run again in 1 second
	self.Entity:NextThink( CurTime() + 1 )
	return true
end


function ENT:RemoveAllProps()
	for _, ent in pairs( self.Props ) do
		local effectdata = EffectData()
		effectdata:SetOrigin( ent:GetPos() )
		effectdata:SetScale( (ent:OBBMaxs() - ent:OBBMins()):Length() )
		util.Effect( "pewpew_deatheffect", effectdata )
		ent:Remove()
	end
end