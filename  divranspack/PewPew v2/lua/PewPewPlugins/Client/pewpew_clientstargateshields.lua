-- Keep track of stargate shields client side. Used for the pewpew trace to remove bullets at the right time.

pewpew.SGShields = {}

hook.Add("OnEntityCreated","PewPew_StargateShield_Spawn",function( ent )
	if (ent and ValidEntity( ent ) and ent:GetClass() == "shield") then
		table.insert( pewpew.SGShields, ent )
	end
end)

hook.Add("OnEntityRemoved","PewPew_StargateShield_Remove",function( ent )
	if (ent:GetClass() == "shield") then
		for k,v in ipairs( pewpew.SGShields ) do
			if (v == ent) then
				table.remove( pewpew.SGShields, k )
				return
			end
		end
	end
end)
