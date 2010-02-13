include('shared.lua')

function ENT:Draw()
	if (self.Bullet and self.Bullet.CLDrawOverride) then
		self.Bullet.CLDrawFunc(self)
	else
		self.Entity:DrawModel()
	end
end
 
function ENT:Think()
	local Name = self.Entity:GetNetworkedString("BulletName")
	if ((self.Bullet and Name ~= self.Bullet.Name and Name ~= "") or (not self.Bullet and Name ~= "")) then
		self.Bullet = pewpew:GetBullet(Name)
		
		if (self.Bullet.CLInitializeOverride) then
			self.Bullet.CLInitializeFunc(self)
		end
	end

	if (self.Bullet) then
		if (self.Bullet.CLThinkOverride) then
			return self.Bullet.CLThinkFunc(self)
		end
		
		if (self.Bullet.Reloadtime < 0.5) then
			-- Run more often!
			self.Entity:NextThink(CurTime())
			return true
		end
	end
end