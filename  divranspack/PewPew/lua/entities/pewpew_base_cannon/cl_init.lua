include('shared.lua')

function ENT:Initialize()
	self.Bullet = nil
end

function ENT:Draw()      
	self.Entity:DrawModel()
	Wire_Render(self.Entity)
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
			self.Bullet.CLThinkFunc(self)
		end
		
		if (self.Bullet.Reloadtime < 0.5) then
			-- Run more often!
			self.Entity:NextThink(CurTime())
			return true
		end
	end
end