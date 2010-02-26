AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()   
	if (self.Bullet.InitializeOverride) then
		-- Allows you to override the Initialize function
		self.Bullet:InitializeFunc( self )
	else
		self.Entity:PhysicsInit( SOLID_VPHYSICS ) 	
		self.Entity:SetMoveType( MOVETYPE_NONE )
		self.Entity:SetSolid( SOLID_NONE )    
		self.FlightDirection = self.Entity:GetUp()
		self.Exploded = false
		
		-- Trail
		if (self.Bullet.Trail) then
			local trail = self.Bullet.Trail
			util.SpriteTrail( self.Entity, 0, trail.Color, false, trail.StartSize, trail.EndSize, trail.Length, 1/(trail.StartSize+trail.EndSize)*0.5, trail.Texture )
		end
		
		-- Material
		if (self.Bullet.Material) then
			self.Entity:SetMaterial( self.Bullet.Material )
		end
		
		-- Color
		if (self.Bullet.Color) then
			local C = self.Bullet.Color
			self.Entity:SetColor( C.r, C.g, C.b, C.a or 255 )
		end
	end
end   

function ENT:SetOptions( BULLET, Cannon )
	self.Bullet = BULLET
	self.Cannon = Cannon
	self.Entity:SetNetworkedString("BulletName", self.Bullet.Name)
end

function ENT:Think()
	if (self.Bullet.ThinkOverride) then
		-- Allows you to override the think function
		return self.Bullet:ThinkFunc( self )
	else
		-- Make it fly
		self.Entity:SetPos( self.Entity:GetPos() + self.FlightDirection * self.Bullet.Speed )
		self.FlightDirection = self.FlightDirection - Vector(0,0,self.Bullet.Gravity / self.Bullet.Speed)
		self.Entity:SetAngles( self.FlightDirection:Angle() + Angle(90,0,0) )
		
		-- Check if it hit something
		local tr = {}
		tr.start = self.Entity:GetPos()
		tr.endpos = self.Entity:GetPos() + self.FlightDirection * self.Bullet.Speed
		tr.filter = self.Entity
		local trace = util.TraceLine( tr )
		
		if (trace.Hit and !self.Exploded) then	
			self.Exploded = true
			if (self.Bullet.ExplodeOverride) then
				-- Allows you to override the Explode function
				self.Bullet:Explode( self, trace )
			else
				-- Player Damage
				if (self.Bullet.PlayerDamageRadius and self.Bullet.PlayerDamage and pewpew.PewPewDamage) then
					util.BlastDamage( self.Entity, self.Entity, trace.HitPos + trace.HitNormal * 10, self.Bullet.PlayerDamageRadius, self.Bullet.PlayerDamage )
				end
				
				-- Effects
				if (self.Bullet.ExplosionEffect) then
					local effectdata = EffectData()
					effectdata:SetOrigin( trace.HitPos + trace.HitNormal * 5 )
					effectdata:SetStart( trace.HitPos + trace.HitNormal * 5 )
					effectdata:SetNormal( trace.HitNormal )
					util.Effect( self.Bullet.ExplosionEffect, effectdata )
				end
				
				-- Sounds
				if (self.Bullet.ExplosionSound) then
					local soundpath = ""
					if (table.Count(self.Bullet.ExplosionSound) > 1) then
						soundpath = table.Random(self.Bullet.ExplosionSound)
					else
						soundpath = self.Bullet.ExplosionSound[1]
					end
					WorldSound( soundpath, trace.HitPos+trace.HitNormal*5,100,100)
				end
					
				-- GCombat Damage
				local damagetype = self.Bullet.DamageType
				if (!damagetype) then return end
				if (damagetype == "BlastDamage") then
					if (trace.Entity and trace.Entity:IsValid()) then
						pewpew:PointDamage( trace.Entity, self.Bullet.Damage )
						pewpew:BlastDamage( trace.HitPos, self.Bullet.Radius, self.Bullet.Damage, self.Bullet.RangeDamageMul, trace.Entity )
					else
						pewpew:BlastDamage( trace.HitPos, self.Bullet.Radius, self.Bullet.Damage, self.Bullet.RangeDamageMul )
					end
				elseif (damagetype == "PointDamage") then
					pewpew:PointDamage( trace.Entity, self.Bullet.Damage )
				elseif (damagetype == "SliceDamage") then
					pewpew:SliceDamage( trace.HitPos, self.FlightDirection, self.Bullet.Damage, self.Bullet.NumberOfSlices or 1, self.Bullet.SliceDistance or 50, self.Entity )
				elseif (damagetype == "EMPDamage") then
					pewpew:EMPDamage( trace.HitPos, self.Bullet.Radius, self.Bullet.Duration )
				end
				
				self.Entity:SetPos( trace.HitPos )
				-- Remove the bullet
				self.Entity:Remove()
			end
		else			
			-- Run more often!
			self.Entity:NextThink( CurTime() )
			return true
		end
	end
end

function ENT:PhysicsCollide(CollisionData, PhysObj)
	if (self.Bullet.PhysicsCollideOverride) then
		self.Bullet.PhysicsCollideFunc(self, CollisionData, PhysObj)
	end
end