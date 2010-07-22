-- PewPew Bullet Control
-- These functions make bullets fly
------------------------------------------------------------------------------------------------------------

pewpew.Bullets = {}

------------------------------------------------------------------------------------------------------------
-- Add and Remove
function pewpew:FireBullet( Pos, Dir, Owner, WeaponData, Cannon, FireDir )
	if (CLIENT) then return end -- Shouldn't be needed. But just in case
	
	-- Does any other addon have anything to say about this?
	if (self:CallHookBool("PewPew_FireBullet",Pos,Dir,WeaponData,Cannon,Owner) == false) then return end
	
	if (#pewpew.Bullets<255) then -- Only send if there are less than 255 bullets in the air
		umsg.Start("PewPew_FireBullet")
			umsg.Entity(Cannon)
			umsg.Float(Dir.x)
			umsg.Float(Dir.y)
			umsg.Float(Dir.z)
			umsg.Char(FireDir) -- FireDir is used to get the position on the client (better than sending the position as well)
			umsg.Entity(Owner)
			umsg.String(WeaponData.Name)
		umsg.End()
	end
	local NewBullet = { Pos = Pos, Dir = Dir, Owner = Owner, Cannon = Cannon, WeaponData = WeaponData, BulletData = {}, RemoveTimer = CurTime() + 60 }
	table.insert( self.Bullets, NewBullet )
	self:BulletInitialize( NewBullet )
	
end

if (CLIENT) then
	local function ClientFireBullet( um )
		-- Cannon
		local Cannon = um:ReadEntity()
		
		-- Pos/Dir
		local Dir = Vector(um:ReadFloat(),um:ReadFloat(),um:ReadFloat())
		local FireDir = um:ReadChar()
		local temp, Pos = pewpew:GetFireDirection( FireDir, Cannon )
		
		-- Owner
		local Owner = um:ReadEntity()
		
		-- Weapon
		local WpnName = um:ReadString()
		local Weapon = pewpew:GetWeapon( WpnName )
		if (!Weapon) then return end
		
		if (#pewpew.Bullets < 255) then
			local ent = ents.Create("prop_physics")
			if (ent) then 
				ent:SetModel(Weapon.Model)
				ent:SetPos(Pos)
				ent:SetAngles(Dir:Angle() + Angle(90,0,0) + (Weapon.AngleOffset or Angle(0,0,0)) )
				ent:Spawn()
			end
			local NewBullet = { Pos = Pos, Dir = Dir, Owner = Owner, WeaponData = Weapon, BulletData = {}, Prop = ent, RemoveTimer = CurTime() + 30 }
			table.insert( pewpew.Bullets, NewBullet )
			pewpew:BulletInitialize( NewBullet )
		end
	end
	usermessage.Hook("PewPew_FireBullet",ClientFireBullet)
end

function pewpew:RemoveBullet( Index )
	timer.Simple( 0, 
		function(Index) 
			if (#pewpew.Bullets>0) then 
				if (pewpew.Bullets[Index]) then
					if (CLIENT) then
						if (pewpew.Bullets[Index].Prop and pewpew.Bullets[Index].Prop:IsValid()) then
							pewpew.Bullets[Index].Prop:Remove()
						end
					end
					table.remove( pewpew.Bullets, Index )
				end
			end 
		end, Index ) -- Remove next tick
end

------------------------------------------------------------------------------------------------------------
-- Initialize
function pewpew:DefaultBulletInitialize( Bullet )
	local D = Bullet.WeaponData
	local B = Bullet.BulletData
	B.Exploded = false
	local tk = self.ServerTick or 66.7
	B.TraceDelay = CurTime() + (D.Speed + (1/((D.Speed*tk))) * 0) / (1/tk) * tk
	
	-- Lifetime
	B.Lifetime = false
	if (D.Lifetime) then
		if (D.Lifetime[1] > 0 and D.Lifetime[2] > 0) then
			if (D.Lifetime[1] == D.Lifetime[2]) then
				B.Lifetime = CurTime() + D.Lifetime[1]
			else
				B.Lifetime = CurTime() + math.Rand(D.Lifetime[1],D.Lifetime[2])
			end
		end
	end
	if (CLIENT) then
		if (Bullet.Prop) then
			/*
			print("PROP:",tostring(Bullet.Prop))
			-- Trail
			if (D.Trail) then
				local trail = ents.Create("env_spritetrail")
				print("TRAIL:",tostring(trail))
				trail:SetPos( Bullet.Prop:GetPos() )
				trail:SetEntity("Parent",Bullet.Prop)
				local trl = D.Trail
				trail:SetKeyValue("lifetime",tostring(trl.Length))
				trail:SetKeyValue("startwidth",tostring(trl.StartSize))
				trail:SetKeyValue("endwidth",tostring(trl.EndSize))
				trail:SetKeyValue("spritename",tostring(trl.Texture))
				local clr = trl.Color
				trail:SetKeyValue("rendercolor",tostring(clr.r) .. " " .. tostring(clr.g) .. " " .. tostring(clr.b))
				trail:SetKeyValue("renderamt","5")
				trail:SetKeyValue("rendermode",tostring(0))
				trail:Spawn()
			end
			*/
			
			-- Material
			if (D.Material) then
				Bullet.Prop:SetMaterial( D.Material )
			end
			
			-- Color
			if (D.Color) then
				local C = D.Color
				Bullet.Prop:SetColor( C.r, C.g, C.b, C.a or 255 )
			end
		end
	end
end

function pewpew:BulletInitialize( Bullet )
	if (SERVER) then
		if (Bullet.WeaponData.InitializeOverride) then
			-- Allows you to override the Initialize function
			Bullet.WeaponData:InitializeFunc( Bullet )
		else
			self:DefaultBulletInitialize( Bullet )
		end
	else
		if (Bullet.WeaponData.CLInitializeOverride) then
			Bullet.WeaponData.CLInitializeFunc( Bullet )
		else
			self:DefaultBulletInitialize( Bullet )
		end
	end
end

------------------------------------------------------------------------------------------------------------
-- Tick

function pewpew:DefaultBulletThink( Bullet, Index, LagCompensation )
	if (!Index and Bullet) then -- If index is nil, attempt to find it
		for k,v in pairs( self.Bullets ) do
			if (Bullet.Pos == v.Pos) then
				Index = k
				break
			end
		end

		-- If Index is still nil, abort
		if (!Index) then return end
	elseif (!Bullet and Index) then -- If bullet is nil, attempt to find it
		Bullet = self.Bullets[Index]
		-- If Bullet is still nil, abort
		if (!Bullet) then return end
	elseif (!Bullet and !Index) then return end
	
	local D = Bullet.WeaponData
	local B = Bullet.BulletData
	
	-- Make it fly
	Bullet.Pos = Bullet.Pos + Bullet.Dir * D.Speed * (LagCompensation or 1)
	local grav = D.Gravity or 0

	if (D.AffectedByNoGrav) then
		if (CAF and CAF.GetAddon("Spacebuild")) then
			if (false) then -- TODO: Gravity check
				grav = grav
			end
		end
	end
	
	if (grav and grav != 0) then -- Only pull if needed
		Bullet.Dir = Bullet.Dir - Vector(0,0,grav / (D.Speed or 1)) * (LagCompensation or 1)
	end
	
	if (CLIENT) then 
		if (Bullet.RemoveTimer and Bullet.RemoveTimer < CurTime()) then -- There's no way a bullet can fly for that long.
			pewpew:RemoveBullet( Index )
		elseif (Bullet.Prop and Bullet.Prop:IsValid()) then
			Bullet.Prop:SetPos( Bullet.Pos )
			Bullet.Prop:SetAngles( Bullet.Dir:Angle() + Angle( 90,0,0 ) + (D.AngleOffset or Angle(0,0,0)) )
			if (CurTime() > B.TraceDelay) then
				local trace = pewpew:DefaultTraceBullet( Bullet )
				
				if (!trace) then error("[PewPew] Invalid trace") return end
				
				if (trace.Hit and !B.Exploded) then
					B.Exploded = true
					self:RemoveBullet( Index )
				end
			end
		end
	else
		if (Bullet.RemoveTimer and Bullet.RemoveTimer < CurTime()) then self:RemoveBullet( Index ) end -- There's no way a bullet can fly for that long.
	
		-- Lifetime
		if (B.Lifetime) then
			if (CurTime() > B.Lifetime) then
				if (D.ExplodeAfterDeath) then
					local trace = pewpew:DefaultTraceBullet( Bullet )					
					self:ExplodeBullet( Index, Bullet, trace )
				else
					self:RemoveBullet( Index )
				end
			end
		end
		
		if (CurTime() > B.TraceDelay) then
			local trace = pewpew:DefaultTraceBullet( Bullet )
			
			if (!trace) then error("[PewPew] Invalid trace") return end
			
			if (trace.Hit and !B.Exploded) then
				B.Exploded = true
				self:ExplodeBullet( Index , Bullet, trace )
			end
		end
	end
end

------------------
-- Recieve tick
local LastTick = 0
local HasTick = false
pewpew.ServerTick = 0

if (CLIENT) then
	usermessage.Hook("PewPew_ServerTick",function(um)
		pewpew.ServerTick = um:ReadFloat()
	end)
else
	hook.Add("PlayerInitialSpawn","PewPew_ServerTick_InitialSpawn",function(ply)
		timer.Simple(0.5,function(ply)
			if (ply and ply:IsValid()) then -- check if the client was disconnected on spawn
				umsg.Start("PewPew_ServerTick",ply)
					umsg.Float(pewpew.ServerTick)
				umsg.End()
			end
		end,ply)
	end)
end
-----------------

function pewpew:BulletThink()
	if (SERVER) then
		if (HasTick != nil) then
			if (HasTick == false) then
				LastTick = CurTime()
				HasTick = true
			else
				self.ServerTick = (CurTime() - LastTick)
				HasTick = nil
			end
		end
	else
		LastTick = CurTime() - LastTick
	end
			
	for k,v in pairs( self.Bullets ) do
		if (SERVER) then
			if (v.WeaponData.ThinkOverride) then
				-- Allows you to override the think function
				v.WeaponData:ThinkFunc( v )
			else
				self:DefaultBulletThink( v, k )
			end
		else
			local LagCompensation = LastTick / self.ServerTick
			if (v.WeaponData.CLThinkOverride) then
				-- Allows you to override the think function
				v.WeaponData.CLThinkFunc( v, LagCompensation )
			else
				self:DefaultBulletThink( v, k , LagCompensation)
			end
			
		end
	end -- Loop end		
	if (CLIENT) then LastTick = CurTime() end
end
hook.Add("Tick","PewPew_BulletThink",function() pewpew:BulletThink() end)
--if (SERVER) then hook.Add("Tick","PewPew_BulletThink",function() pewpew:BulletThink() end) end
--if (CLIENT) then hook.Add("Think","PewPew_BulletThink",function() pewpew:BulletThink() end) end

------------------------------------------------------------------------------------------------------------
-- Trace
------------------------------------------------------------------------------------------------------------
function pewpew:DefaultTraceBullet( Bullet )
	local D = Bullet.WeaponData
	local B = Bullet.BulletData
	
	local Pos = Bullet.Pos - Bullet.Dir * D.Speed
	local Dir = Bullet.Dir * D.Speed
	local Filter
	if (CLIENT) then Filter = Bullet.Prop end
	return pewpew:Trace( Pos, Dir, Filter )
end

------------------------------------------------------------------------------------------------------------
-- Explode
------------------------------------------------------------------------------------------------------------

function pewpew:DefaultExplodeBullet( Index, Bullet, trace )
	local D = Bullet.WeaponData
	local B = Bullet.BulletData
	-- Effects
	if (D.ExplosionEffect) then
		local effectdata = EffectData()
		effectdata:SetOrigin( trace.HitPos + trace.HitNormal * 5 )
		effectdata:SetStart( trace.HitPos + trace.HitNormal * 5 )
		effectdata:SetNormal( trace.HitNormal )
		util.Effect( D.ExplosionEffect, effectdata )
	end
	
	-- Sounds
	if (D.ExplosionSound) then
		local soundpath = ""
		if (table.Count(D.ExplosionSound) > 1) then
			soundpath = table.Random(D.ExplosionSound)
		else
			soundpath = D.ExplosionSound[1]
		end
		WorldSound( soundpath, trace.HitPos+trace.HitNormal*5,100,100)
	end
	
	-- Damage
	local damagetype = D.DamageType
	local damaged = false
	if (damagetype and type(damagetype) == "string") then
		local damagedealer = Bullet.Cannon
		if (!damagedealer:IsValid()) then damagedealer = Bullet.Owner end
		if (damagetype == "BlastDamage") then
			if (trace.Entity and trace.Entity:IsValid()) then
				-- Stargate shield damage
				if (trace.Entity:GetClass() == "shield") then
					trace.Entity:Hit(nil,trace.HitPos,D.Damage,trace.HitNormal)
					damaged = true
				else
					pewpew:PointDamage( trace.Entity, D.Damage, damagedealer )
				end
				self:BlastDamage( trace.HitPos, D.Radius, D.Damage, D.RangeDamageMul, trace.Entity, damagedealer )
			else
				self:BlastDamage( trace.HitPos, D.Radius, D.Damage, D.RangeDamageMul, damagedealer )
			end
			
			-- Player Damage
			if (D.PlayerDamageRadius and D.PlayerDamage and self:GetConVar( "Damage" )) then
				util.BlastDamage( damagedealer, damagedealer, trace.HitPos + trace.HitNormal * 10, D.PlayerDamageRadius, D.PlayerDamage )
			end
		elseif (damagetype == "PointDamage") then
			self:PointDamage( trace.Entity, D.Damage, damagedealer )
		elseif (damagetype == "SliceDamage") then
			self:SliceDamage( trace.HitPos, Bullet.Dir, D.Damage, D.NumberOfSlices or 1, D.SliceDistance or 50, D.ReducedDamagePerSlice or 0, damagedealer )
		elseif (damagetype == "EMPDamage") then
			self:EMPDamage( trace.HitPos, D.Radius, D.Duration, damagedealer )
		elseif (damagetyp == "DefenseDamage") then
			self:DefenseDamage( trace.Entity, D.Damage )
		elseif (damagetype == "FireDamage") then
			pewpew:FireDamage( trace.Entity, D.DPS, D.Duration, self, damagedealer )
		end
	end
	
	-- Stargate shield damage
	if (trace.Entity and trace.Entity:IsValid() and trace.Entity:GetClass() == "shield" and !damaged) then
		trace.Entity:Hit(nil,trace.HitPos,D.Damage,trace.HitNormal)
	end
	
	-- Remove the bullet
	self:RemoveBullet( Index )
end

function pewpew:ExplodeBullet( Index, Bullet, trace )
	if (!trace) then return end
	
	if (Bullet.WeaponData.ExplodeOverride) then
		-- Allows you to override the Explode function
		Bullet.WeaponData:Explode( Bullet, Index, trace )
	else
		self:DefaultExplodeBullet( Index, Bullet, trace )
	end
end