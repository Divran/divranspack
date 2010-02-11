AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()   
	self.Entity:PhysicsInit( SOLID_VPHYSICS )  	
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )      

	self.Inputs = Wire_CreateInputs( self.Entity, { "Fire" } )
	self.Outputs = Wire_CreateOutputs( self.Entity, { "Can Fire" })
	
	self.CanFire = true
	self.LastFired = 0
	self.Firing = false
end

function ENT:SetUsedBullet( BULLET )
		self.Bullet = BULLET
end

function ENT:FireBullet()
	if (self.Bullet.FireOverride) then
		-- Allows you to override the fire function
		self.Bullet:Fire( self )
	else
		-- Create Bullet
		local ent = ents.Create( "pewpew_base_bullet" )
		if (!ent or !ent:IsValid()) then return end
		-- Set Model
		ent:SetModel( self.Bullet.Model )
		-- Set used bullet
		ent:SetUsedBullet( self.Bullet )
		-- Calculate initial position of bullet
		local boxsize = self.Entity:OBBMaxs() - self.Entity:OBBMins()
		local bulletboxsize = ent:OBBMaxs() - ent:OBBMins()
		local Pos = self.Entity:GetPos() + self.Entity:GetUp() * (boxsize.x/2 + bulletboxsize.x/2 + 50)
		ent:SetPos( Pos )
		-- Add random angle offset
		local num = self.Bullet.Spread or 0
		local randomang = Angle(0,0,0)
		if (num) then
			randomang = Angle( math.Rand(-num,num), math.Rand(-num,num), math.Rand(-num,num) )
		end	
		ent:SetAngles( self.Entity:GetAngles() + randomang )
		-- Spawn
		ent:Spawn()
		ent:Activate()
		
		-- Trail
		if (self.Bullet.Trail) then
			local trail = self.Bullet.Trail
			util.SpriteTrail( ent, 0, trail.Color, false, trail.StartSize, trail.EndSize, trail.Length, 1/(trail.StartSize+trail.EndSize)*0.5, trail.Texture )
		end
		-- Material
		if (self.Bullet.Material) then
			ent:SetMaterial( self.Bullet.Material )
		end
		-- Color
		if (self.Bullet.Color) then
			ent:SetColor( self.Bullet.Color )
		end
		
		-- Recoil
		if (self.Bullet.RecoilForce and self.Bullet.RecoilForce > 0) then
			self.Entity:GetPhysicsObject():AddVelocity( self.Entity:GetUp() * -self.Bullet.RecoilForce )
		end
		
		-- Sound
		if (self.Bullet.FireSound) then
			self:EmitSound( self.Bullet.FireSound )
		end
		
		-- Effect
		if (self.Bullet.FireEffect) then
			local effectdata = EffectData()
			effectdata:SetOrigin( Pos )
			effectdata:SetNormal( self:GetUp() )
			util.Effect( self.Bullet.FireEffect, effectdata )
		end
	end
end

function ENT:Think()
	if (CurTime() - self.LastFired > self.Bullet.Reloadtime and self.CanFire == false) then
		self.CanFire = true
		if (self.Firing) then
			self.LastFired = CurTime()
			self.CanFire = false
			self:FireBullet()
		else
			Wire_TriggerOutput( self.Entity, "Can Fire", 1)
		end
	end
	if (self.Bullet.Reloadtime < 0.5) then
		-- Run more often!
		self.Entity:NextThink( CurTime() )
		return true
	end
end

function ENT:TriggerInput(iname, value)
	if (iname == "Fire") then
		if (value != 0) then
			self.Firing = true
		else
			self.Firing = false
		end
		if (value != 0 and self.CanFire == true) then
			self.LastFired = CurTime()
			self.CanFire = false
			Wire_TriggerOutput(self.Entity, "Can Fire", 0)
			self:FireBullet()
		end
		return true
	end

end
 
 