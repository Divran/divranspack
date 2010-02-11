-- Returns 1 if the entity is a PewPew Cannon
e2function number entity:pewIsCannon()
	if (!validPhysics(this)) then return 0 end
	if (this:GetClass() == "pewpew_base_cannon") then return 1 end
	return 0
end

-- Returns the health of the entity
e2function number entity:pewHealth()
	if (!validPhysics(this)) then return 0 end
	if (!this.pewpewHealth) then 
		pewpew:SetHealth( this )
	end
	return this.pewpewHealth
end

-- Returns the name of the bullet of the cannon
e2function string entity:pewBulletName()
	if (!validPhysics(this)) then return "" end
	if (this:GetClass() != "pewpew_base_cannon") then return "" end
	return this.Bullet.Name or ""
end

-- Returns the damage
e2function number entity:pewDamage()
	if (!validPhysics(this)) then return 0 end
	if (this:GetClass() != "pewpew_base_cannon") then return 0 end
	return this.Bullet.Damage or 0
end

-- Returns the damage radius
e2function number entity:pewDamageRadius()
	if (!validPhysics(this)) then return 0 end
	if (this:GetClass() != "pewpew_base_cannon") then return 0 end
	return this.Bullet.Radius or 0
end

-- Returns the reload time
e2function number entity:pewReloadTime()
	if (!validPhysics(this)) then return 0 end
	if (this:GetClass() != "pewpew_base_cannon") then return 0 end
	return this.Bullet.Reloadtime or 0
end

-- Returns the spread
e2function number entity:pewSpread()
	if (!validPhysics(this)) then return 0 end
	if (this:GetClass() != "pewpew_base_cannon") then return 0 end
	return this.Bullet.Spread or 0
end

-- Returns the damage vs players
e2function number entity:pewPlayerDamage()
	if (!validPhysics(this)) then return 0 end
	if (this:GetClass() != "pewpew_base_cannon") then return 0 end
	return this.Bullet.PlayerDamage or 0
end

-- Returns the radius vs players
e2function number entity:pewPlayerDamageRadius()
	if (!validPhysics(this)) then return 0 end
	if (this:GetClass() != "pewpew_base_cannon") then return 0 end
	return this.Bullet.PlayerDamageRadius or 0
end

-- Returns the speed of the bullet
e2function number entity:pewSpeed()
	if (!validPhysics(this)) then return 0 end
	if (this:GetClass() != "pewpew_base_cannon") then return 0 end
	return this.Bullet.Speed or 0
end

-- Returns the pitch change (aka how fast it drops toward the ground)
e2function number entity:pewPitchChange()
	if (!validPhysics(this)) then return 0 end
	if (this:GetClass() != "pewpew_base_cannon") then return 0 end
	return this.Bullet.PitchChange or 0
end

-- Returns the recoil force
e2function number entity:pewRecoilForce()
	if (!validPhysics(this)) then return 0 end
	if (this:GetClass() != "pewpew_base_cannon") then return 0 end
	return this.Bullet.RecoilForce or 0
end


-- Returns the damage type
e2function string entity:pewDamageType()
	if (!validPhysics(this)) then return "" end
	if (this:GetClass() != "pewpew_base_cannon") then return "" end
	return this.Bullet.DamageType or ""
end