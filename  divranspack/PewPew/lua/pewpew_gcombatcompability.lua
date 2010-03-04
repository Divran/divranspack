-- pewpew_gcombatcompability
-- These functions take care of GCombat compability
------------------------------------------------------------------------------------------------------------
COMBATDAMAGEENGINE = 1
gcombat = {}

------------------------------------------------------------------------------------------------------------
-- Blast Damage GCombat compability

function gcombat.hcgexplode( position, radius, damage, pierce)
	pewpew:BlastDamage( position, radius, damage, 0.6 )
end
cbt_hcgexplode = gcombat.hcgexplode

function gcombat.nrgexplode( position, radius, damage, pierce)
	pewpew:BlastDamage( position, radius, damage, 0.6 )
end
cbt_nrgexplode = gcombat.nrgexplode

------------------------------------------------------------------------------------------------------------
-- Point Damage GCombat compability

function gcombat.devhit( entity, damage, pierce )
	-- default to fail
	local attack = 0
	
	-- success?
	if (pewpew:CheckValid( entity )) then attack = 1 end

	pewpew:PointDamage( entity, damage )
	
	-- did it die?
	if (!entity:IsValid()) then
		attack = 2
	end
end
cbt_dealdevhit = gcombat.devhit

function gcombat.hcghit( entity, damage, pierce, src, dest)
	-- default to fail
	local attack = 0
	
	-- success?
	if (pewpew:CheckValid( entity )) then attack = 1 end
	
	pewpew:PointDamage( entity, damage )
	
	-- did it die?
	if (!entity:IsValid()) then
		attack = 2
	end
	
	if (attack == 2) then
		local effectdata1 = EffectData()
		effectdata1:SetOrigin(src)
		effectdata1:SetStart(dest)
		effectdata1:SetScale( 10 )
		effectdata1:SetRadius( 100 )
		util.Effect( "Explosion", effectdata1 )
	elseif attack == 1 then
		local effectdata1 = EffectData()
		effectdata1:SetOrigin(src)
		effectdata1:SetStart(dest)
		effectdata1:SetScale( 10 )
		effectdata1:SetRadius( 100 )
		util.Effect( "HelicopterMegaBomb", effectdata1 )
	elseif attack == 0 then
		local effectdata1 = EffectData()
		effectdata1:SetOrigin(src)
		effectdata1:SetStart(dest)
		effectdata1:SetScale( 10 )
		effectdata1:SetRadius( 100 )
		util.Effect( "RPGShotDown", effectdata1 )
	end
end
cbt_dealhcghit = gcombat.hcghit

function gcombat.nrghit( entity, damage, pierce, src, dest)

	-- default to fail
	local attack = 0
	
	-- success?
	if (pewpew:CheckValid( entity )) then attack = 1 end
	
	pewpew:PointDamage( entity, damage )
	
	-- died?
	if (!entity:IsValid()) then
		attack = 2
	end
	
	-- effects
	if (attack == 2) then
		local effectdata1 = EffectData()
		effectdata1:SetOrigin(src)
		effectdata1:SetStart(dest)
		effectdata1:SetScale( 10 )
		effectdata1:SetRadius( 100 )
		util.Effect( "cball_bounce", effectdata1 )
	elseif attack == 1 then
		local effectdata1 = EffectData()
		effectdata1:SetOrigin(src)
		effectdata1:SetStart(dest)
		util.Effect( "ener_succeed", effectdata1 )
	elseif attack == 0 then
		local effectdata1 = EffectData()
		effectdata1:SetOrigin(src)
		effectdata1:SetStart(dest)
		util.Effect( "ener_fail", effectdata1 )
	end
end
cbt_dealnrghit = gcombat.nrghit