AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()   
	if (self.Bullet.InitializeOverride) then
		-- Allows you to override the Initialize function
		self.Bullet:InitializeFunc( self )
	else
		self.flightvector = self.Entity:GetUp()
		self.Entity:PhysicsInit( SOLID_VPHYSICS ) 	
		self.Entity:SetMoveType( MOVETYPE_NONE )
		self.Entity:SetSolid( SOLID_VPHYSICS )    
		self.FlightDirection = self.Entity:GetUp()
	end
end   

function ENT:SetUsedBullet( BULLET )
	self.Bullet = BULLET
end

function ENT:Think()
	if (self.Bullet.ThinkOverride) then
		-- Allows you to override the think function
		self.Bullet:ThinkFunc( self )
	else
		-- Make it fly
		self.Entity:SetPos( self.Entity:GetPos() + self.FlightDirection * self.Bullet.Speed )
		self.FlightDirection = self.FlightDirection - Vector(0,0,self.Bullet.PitchChange / self.Bullet.Speed)
		self.Entity:SetAngles( self.FlightDirection:Angle() + Angle(90,0,0) )
		
		-- Check if it hit something
		local tr = {}
		tr.start = self.Entity:GetPos()
		tr.endpos = self.Entity:GetPos() + self.FlightDirection * self.Bullet.Speed
		tr.filter = self.Entity
		local trace = util.TraceLine( tr )
		
		if (trace.Hit) then	
			if (self.Bullet.ExplodeOverride) then
				-- Allows you to override the Explode function
				self.Bullet:Explode( self, trace )
			else
				-- Player Damage
				if (self.Bullet.PlayerDamageRadius and self.Bullet.PlayerDamage) then
					util.BlastDamage( self.Entity, self.Entity, trace.HitPos + trace.HitNormal * 10, self.Bullet.PlayerDamageRadius, self.Bullet.PlayerDamage )
				end
				
				-- Effects
				if (self.Bullet.ExplosionEffect) then
					local effectdata = EffectData()
					effectdata:SetOrigin( trace.HitPos )
					effectdata:SetStart( trace.HitPos )
					effectdata:SetNormal( trace.HitNormal )
					util.Effect( self.Bullet.ExplosionEffect, effectdata )
				end
				
				-- Remove the bullet
				self.Entity:Remove()
								
				-- GCombat Damage
				local damagetype = self.Bullet.DamageType
				if (!damagetype) then return end
				if (damagetype == "BlastDamage") then
					pewpew:BlastDamage( trace.HitPos, self.Bullet.Radius, self.Bullet.Damage, self.Bullet.RangeDamageMul )
				elseif (damagetype == "PointDamage") then
					pewpew:PointDamage( trace.Entity, self.Bullet.Damage )
				end
			end
		end
		
		-- Run more often!
		self.Entity:NextThink( CurTime() )
		return true
	end
end