AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()   
	self.Entity:PhysicsInit( SOLID_VPHYSICS )  	
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )      

	self.Inputs = Wire_CreateInputs( self.Entity, { "Fire" } )
	self.Outputs = Wire_CreateOutputs( self.Entity, { "Can Fire", "Ammo" })
	
	self.CanFire = true
	self.LastFired = 0
	self.Firing = false
end

function ENT:SetOptions( BULLET )
	self.Bullet = BULLET
	self.Ammo = self.Bullet.Ammo
	Wire_TriggerOutput( self.Entity, "Ammo", self.Ammo )
	Wire_TriggerOutput( self.Entity, "Can Fire", 1)
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
		ent:SetOptions( self.Bullet )
		-- Calculate initial position of bullet
		local boxsize = self.Entity:OBBMaxs() - self.Entity:OBBMins()
		local bulletboxsize = ent:OBBMaxs() - ent:OBBMins()
		local Pos = self.Entity:GetPos() + self.Entity:GetUp() * (boxsize.z/2 + bulletboxsize.z/2 + 10)
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
		
		-- Recoil
		if (self.Bullet.RecoilForce and self.Bullet.RecoilForce > 0) then
			self.Entity:GetPhysicsObject():AddVelocity( self.Entity:GetUp() * -self.Bullet.RecoilForce )
		end
		
		-- Sound
		if (self.Bullet.FireSound) then
			local soundpath = ""
			if (table.Count(self.Bullet.FireSound) > 1) then
				soundpath = table.Random(self.Bullet.FireSound)
			else
				soundpath = self.Bullet.FireSound[1]
			end
			self:EmitSound( soundpath )
		end
		
		-- Effect
		if (self.Bullet.FireEffect) then
			local effectdata = EffectData()
			effectdata:SetOrigin( Pos )
			effectdata:SetNormal( self:GetUp() )
			util.Effect( self.Bullet.FireEffect, effectdata )
		end
		
		self.Ammo = self.Ammo - 1
		Wire_TriggerOutput( self.Entity, "Ammo", self.Ammo )
	end
end

function ENT:Think()
	if (CurTime() - self.LastFired > self.Bullet.Reloadtime and self.CanFire == false) then -- if you can fire
		if (self.Ammo <= 0 and self.Bullet.Ammo > 0) then -- check for ammo
			-- if we don't have any ammo left...
			self.CanFire = false
			Wire_TriggerOutput( self.Entity, "Can Fire", 0)
			if (CurTime() - self.LastFired > self.Bullet.AmmoReloadtime) then -- check ammo reloadtime
				self.Ammo = self.Bullet.Ammo
				Wire_TriggerOutput( self.Entity, "Ammo", self.Ammo )
				self.CanFire = true
				if (self.Firing) then 
					self:FireBullet()
					self.CanFire = false
				else
					Wire_TriggerOutput( self.Entity, "Can Fire", 1)
				end
			end
		else
			-- if we DO have ammo left
			self.CanFire = true
			if (self.Firing) then
				self.LastFired = CurTime()
				self.CanFire = false
				self:FireBullet()
			else
				Wire_TriggerOutput( self.Entity, "Can Fire", 1)
			end
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
 
-- Dupe support! Thanks to Free Fall
function ENT:BuildDupeInfo()
	local info = self.BaseClass.BuildDupeInfo(self) or {}
	if (self.Bullet) then
		info.BulletName = self.Bullet.Name
	end
	return info
end

function ENT:ApplyDupeInfo(ply, ent, info, GetEntByID)
	self.BaseClass.ApplyDupeInfo(self, ply, ent, info, GetEntByID)
	if ( !ply:CheckLimit( "pewpew" ) ) then 
		self:Remove()
		return false
	end
	if (info.BulletName) then
		local bullet = pewpew:GetBullet( info.BulletName )
		if (bullet.AdminOnly and !ply:IsAdmin()) then 
			ply:ChatPrint("You must be an admin to spawn this PewPew weapon.")
			self:Remove()
			return false
		end
		if (bullet.SuperAdminOnly and !ply:IsSuperAdmin()) then
			ply:ChatPrint("You must be a super admin to spawn this PewPew weapon.")
			self:Remove()
			return false
		end
		if (bullet) then
			self:SetOptions( bullet )
		else
			self.SetOptions( pewpew.bullets[1] )
			ply:ChatPrint("PewPew Bullet not found! Using the bullet '" .. pewpew.bullets[1].Name .. "' instead to prevent errors.")
		end
	end
	ply:AddCount("pewpew",ent)
end