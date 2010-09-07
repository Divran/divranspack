--------------------------------------------------------
-- Compatibility
-- Since there may be code changes in later versions of PewPew, 
-- older weapons might break over time
-- This file provides compatibility with previous versions,
-- to make all weapons work, no matter how old.
-- If a weapon's version is nil, it is version 1.0.
--------------------------------------------------------

pewpew.Compatibility = {}

pewpew.Compatibility[1] = function( self, weapon ) -- Make weapons at version 1 work with the latest PewPew version
	-- Convert blast damage multiplier
	if (weapon.RangeDamageMul) then
		weapon.RangeDamageMul = 3-(1-weapon.RangeDamageMul)*2
	end
end

function pewpew:MakeCompatible( weapon )
	if (!weapon.Version) then 
		weapon.Version = 1
	end
	if (pewpew.Compatibility[weapon.Version]) then
		pewpew.Compatibility[weapon.Version]( pewpew, weapon )
	end
end

hook.Add("Initialize","PewPew_Compatibility_Modifying",function() for k,v in ipairs( pewpew.Weapons ) do pewpew:MakeCompatible( v ) end end)