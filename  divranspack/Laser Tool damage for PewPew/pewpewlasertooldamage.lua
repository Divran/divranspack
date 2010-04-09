timer.Simple(1,function()
	if (LaserLib and pewpew and pewpew.Installed == true) then
		local OldFunc = LaserLib.DoDamage
		function LaserLib.DoDamage( target, hitPos, normal, beamDir, damage, attacker, dissolveType, pushProps, killSound, laserEnt )
			if (pewpew:CheckValid( target )) then
				pewpew:PointDamage( target, damage, laserEnt )
			end
			OldFunc( target, hitPos, normal, beamDir, damage, attacker, dissolveType, pushProps, killSound, laserEnt )
		end
	end
end)